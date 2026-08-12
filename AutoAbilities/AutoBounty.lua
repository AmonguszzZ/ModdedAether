-- ==========================================
-- AutoBounty.lua Library
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerUserId = LocalPlayer.UserId
local PlayerName = LocalPlayer.Name

local RemoteFunction = ReplicatedStorage:FindFirstChild("RemoteFunction")

local AutoBounty = {}

-- Active thread tracker
local activeBountyThread = nil

-- Persistent enemy cache for tracking wave data
local enemyCache = {}
local lastEnemySpawnTime = 0

-- Helper: Get Difficulty/Mode from ReplicatedStorage
local function getDifficulty()
    local state = ReplicatedStorage:FindFirstChild("State")
    if not state then return nil end

    local diffObj = state:FindFirstChild("Difficulty")
    if not diffObj then return nil end

    if diffObj:IsA("ValueBase") then
        return diffObj.Value
    else
        return diffObj:GetAttribute("Value") or diffObj.Name
    end
end

-- Helper: Read Current Wave from GameStateReplicator
local function getCurrentWave()
    local stateReplicators = ReplicatedStorage:FindFirstChild("StateReplicators")
    if not stateReplicators then return 0 end

    local gameStateReplicator = stateReplicators:FindFirstChild("GameStateReplicator")
    if gameStateReplicator then
        local waveAttr = gameStateReplicator:GetAttribute("Wave")
        if waveAttr and type(waveAttr) == "number" then
            return waveAttr
        end
    end

    return 0
end

-- Helper: Check if current wave is a Boss Wave based on Difficulty
local function isBossWave()
    local diff = getDifficulty()
    local currentWave = getCurrentWave()

    if not diff or currentWave == 0 then return false end

    diff = string.lower(tostring(diff))

    local waveConfig = {
        ["easy"]         = { maxWave = 20, bossWaves = {20} },
        ["casual"]       = { maxWave = 25, bossWaves = {25} },
        ["inter"]        = { maxWave = 30, bossWaves = {30} },
        ["intermediate"] = { maxWave = 30, bossWaves = {30} },
        ["molten"]       = { maxWave = 35, bossWaves = {35} },
        ["fallen"]       = { maxWave = 40, bossWaves = {40} },
        ["frost"]        = { maxWave = 40, bossWaves = {40} },
    }

    local config = waveConfig[diff]
    if config then
        for _, bossWaveNum in ipairs(config.bossWaves) do
            if currentWave == bossWaveNum then
                return true
            end
        end
    end

    return false
end

-- Helper: Get all Evolved Kingpins (Path 1 only) belonging strictly to local player
local function getMyKingpins()
    local myKingpins = {}
    local towersFolder = Workspace:FindFirstChild("Towers")
    if not towersFolder then return myKingpins end

    for _, tower in ipairs(towersFolder:GetChildren()) do
        local replicator = tower:FindFirstChild("TowerReplicator")
        if replicator then
            local ownerId = replicator:GetAttribute("OwnerId")
            local ownerName = replicator:GetAttribute("OwnerName")
            local towerName = replicator:GetAttribute("Name")
            local pathAttr = replicator:GetAttribute("Path")

            local isOwner = (ownerId and ownerId == PlayerUserId) or (ownerName and ownerName == PlayerName)

            if isOwner and towerName and string.lower(towerName) == "evolvedkingpin" and pathAttr == 1 then
                table.insert(myKingpins, tower)
            end
        end
    end

    return myKingpins
end

-- Helper: Check if an NPC is a Boss via its StatusEffects container
local function isBossNPC(npcReplicator)
    local statusEffects = npcReplicator:FindFirstChild("StatusEffects")
    if statusEffects then
        local bossAttr = statusEffects:GetAttribute("Boss")
        if bossAttr ~= nil then
            return true
        end
    end
    return false
end

-- Helper: Update enemy cache & reset spawn timer when new "Enemies" type appears
local function updateEnemyCache()
    local stateReplicators = ReplicatedStorage:FindFirstChild("StateReplicators")
    if not stateReplicators then return end

    local npcReplicatorsFolder = stateReplicators:FindFirstChild("NPCReplicators") or stateReplicators
    if not npcReplicatorsFolder then return end

    local currentEnemies = {}

    -- Add/Update active enemies in the cache
    for _, npc in ipairs(npcReplicatorsFolder:GetChildren()) do
        local npcType = npc:GetAttribute("Type")
        local health = npc:GetAttribute("Health") or npc:GetAttribute("MaxHealth") or 0

        if npcType == "Enemies" and health > 0 then
            currentEnemies[npc] = true
            if not enemyCache[npc] then
                -- New enemy detected -> Reset 5-second timer
                enemyCache[npc] = {
                    Instance = npc,
                    MaxHealth = npc:GetAttribute("MaxHealth") or 0,
                    FirstSeen = os.clock()
                }
                lastEnemySpawnTime = os.clock()
                print(string.format("[AutoBounty]: New enemy spawned (%d HP). Resetting 5s timer.", enemyCache[npc].MaxHealth))
            end
        end
    end

    -- Delete any NPCReplicator from cache if it no longer exists or died
    for npc, _ in pairs(enemyCache) do
        if not currentEnemies[npc] or not npc:IsDescendantOf(game) then
            enemyCache[npc] = nil
        end
    end
end

-- Helper: Find best target based on mode
local function getTargetEnemy(mode)
    updateEnemyCache()

    -- UNIVERSAL MODE: Decides whether to filter for Bosses or High HP based on wave
    local isBossSearchOnly = false
    if mode == "Universal" then
        local currentDifficulty = getDifficulty() or "Unknown"
        local currentWave = getCurrentWave()
        local bossWaveActive = isBossWave()

        if bossWaveActive then
            print("[Universal Mode]: Boss Wave detected! Filtering strictly for Bosses...")
            isBossSearchOnly = true
        end
    elseif mode == "Boss" then
        isBossSearchOnly = true
    end

    -- Filter cache down to available valid candidates
    local candidates = {}
    for npc, data in pairs(enemyCache) do
        local health = npc:GetAttribute("Health") or data.MaxHealth
        if health > 0 then
            if isBossSearchOnly then
                if isBossNPC(npc) then
                    candidates[npc] = data
                end
            else
                candidates[npc] = data
            end
        end
    end

    -- Find the candidate with the highest HP
    local highestEnemy = nil
    local maxHPFound = -1

    for npc, data in pairs(candidates) do
        if data.MaxHealth > maxHPFound then
            maxHPFound = data.MaxHealth
            highestEnemy = npc
        end
    end

    if not highestEnemy then
        return nil
    end

    -- 1. Instant Lock Threshold: If target has >= 60,000 HP, lock on immediately (even on Bosses)
    if maxHPFound >= 60000 then
        print(string.format("[AutoBounty]: Target with >= 60k HP found (%d HP)! Locking on.", maxHPFound))
        return highestEnemy
    end

    -- 2. Timer Check: Otherwise wait 5 seconds after the last spawn to let enemies settle
    local timeSinceLastSpawn = os.clock() - lastEnemySpawnTime

    if timeSinceLastSpawn < 5 then
        print(string.format("[AutoBounty]: Under 60k HP. Waiting for spawns to settle... (%.1fs / 5s)", timeSinceLastSpawn))
        return nil
    end

    return highestEnemy
end

--- AutoBounty Mode Selector
-- @param mode (string): "Universal", "Highest HP", "High HP", "Boss", "Low HP", or "Off"
function AutoBounty.Bounty(mode)
    -- Cancel any previously active bounty thread
    if activeBountyThread then
        task.cancel(activeBountyThread)
        activeBountyThread = nil
        print("[AutoBounty]: Stopped previous Bounty loop.")
    end

    -- Reset tracking data
    enemyCache = {}
    lastEnemySpawnTime = 0

    -- Turn off if disabled
    if not mode or mode == "Off" or mode == false then
        print("[AutoBounty]: Disabled.")
        return
    end

    print(string.format("[AutoBounty]: Initialized targeting loop. Mode selected: [%s]", tostring(mode)))

    -- Main operational loop
    activeBountyThread = task.spawn(function()
        while task.wait(0.5) do
            local kingpins = getMyKingpins()
            
            if #kingpins > 0 then
                local targetReplicator = getTargetEnemy(mode)

                if targetReplicator then
                    for _, kingpin in ipairs(kingpins) do
                        if RemoteFunction then
                            pcall(function()
                                RemoteFunction:InvokeServer(
                                    "Troops",
                                    "Abilities",
                                    "Activate",
                                    {
                                        Troop = kingpin,
                                        Name = "Bounty",
                                        Data = {
                                            ReplicatorFolder = targetReplicator
                                        }
                                    }
                                )
                            end)
                        end
                    end
                end
            end
        end
    end)
end

return AutoBounty
