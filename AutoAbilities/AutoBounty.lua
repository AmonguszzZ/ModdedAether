local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerUserId = LocalPlayer.UserId
local PlayerName = LocalPlayer.Name

local RemoteFunction = ReplicatedStorage:FindFirstChild("RemoteFunction")

local AutoBounty = {}

local activeBountyThread = nil
local activeAbilityThread = nil

local enemyCache = {}
local lastEnemySpawnTime = 0

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

local function updateEnemyCache()
    local stateReplicators = ReplicatedStorage:FindFirstChild("StateReplicators")
    if not stateReplicators then return end

    local npcReplicatorsFolder = stateReplicators:FindFirstChild("NPCReplicators") or stateReplicators
    if not npcReplicatorsFolder then return end

    local currentEnemies = {}

    for _, npc in ipairs(npcReplicatorsFolder:GetChildren()) do
        local npcType = npc:GetAttribute("Type")
        local health = npc:GetAttribute("Health") or npc:GetAttribute("MaxHealth") or 0

        if npcType == "Enemies" and health > 0 then
            currentEnemies[npc] = true
            if not enemyCache[npc] then
                enemyCache[npc] = {
                    Instance = npc,
                    MaxHealth = npc:GetAttribute("MaxHealth") or 0,
                    FirstSeen = os.clock()
                }
                lastEnemySpawnTime = os.clock()
            end
        end
    end

    for npc, _ in pairs(enemyCache) do
        if not currentEnemies[npc] or not npc:IsDescendantOf(game) then
            enemyCache[npc] = nil
        end
    end
end

local function getTargetEnemy(mode)
    updateEnemyCache()

    local isBossSearchOnly = false
    if mode == "Universal" then
        if isBossWave() then
            isBossSearchOnly = true
        end
    elseif mode == "Boss" then
        isBossSearchOnly = true
    end

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

    if maxHPFound >= 60000 then
        return highestEnemy
    end

    local timeSinceLastSpawn = os.clock() - lastEnemySpawnTime
    if timeSinceLastSpawn < 5 then
        return nil
    end

    return highestEnemy
end

local function getTargetByName(targetName)
    local stateReplicators = ReplicatedStorage:FindFirstChild("StateReplicators")
    if not stateReplicators then return nil end

    local npcReplicatorsFolder = stateReplicators:FindFirstChild("NPCReplicators") or stateReplicators
    if not npcReplicatorsFolder then return nil end

    local searchName = string.lower(tostring(targetName))

    for _, npc in ipairs(npcReplicatorsFolder:GetChildren()) do
        local npcType = npc:GetAttribute("Type")
        local health = npc:GetAttribute("Health") or npc:GetAttribute("MaxHealth") or 0
        local nameAttr = npc:GetAttribute("Name")

        if npcType == "Enemies" and health > 0 and nameAttr then
            if string.lower(tostring(nameAttr)) == searchName then
                return npc
            end
        end
    end

    return nil
end

function AutoBounty.Bounty(mode)
    if activeBountyThread then
        task.cancel(activeBountyThread)
        activeBountyThread = nil
    end

    enemyCache = {}
    lastEnemySpawnTime = 0

    if not mode or mode == "Off" or mode == false then
        return
    end

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
                                        Data = { ReplicatorFolder = targetReplicator }
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

function AutoBounty.Ability(targetName, isLoop)
    if activeAbilityThread then
        task.cancel(activeAbilityThread)
        activeAbilityThread = nil
    end

    if not targetName or targetName == "Off" or targetName == false then
        print("[AutoBounty]: Stopped Specific Ability target loop.")
        return
    end

    local shouldLoop = (isLoop == true)

    activeAbilityThread = task.spawn(function()
        while task.wait(0.5) do
            local kingpins = getMyKingpins()

            if #kingpins > 0 then
                local targetReplicator = getTargetByName(targetName)

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
                                        Data = { ReplicatorFolder = targetReplicator }
                                    }
                                )
                            end)
                        end
                    end

                    if not shouldLoop then
                     
                        activeAbilityThread = nil
                        break
                    end
                end
            end
        end
    end)
end

return AutoBounty
