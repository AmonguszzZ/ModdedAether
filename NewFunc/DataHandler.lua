
export type PlayerInfo = {
    name: string,
    displayName: string,
    userId: number,
    accountAge: number,
    level: number,
}

export type Currencies = {
    coins: number,
    gems: number,
    timescaleTickets: number,
    reviveTickets: number,
    spinTickets: number,
}

export type Skills = {
    skillTreeUnlocked: boolean,
    skillsEnabled: boolean,
    note: string?,
    unlockedSkills: { [string]: number },
}

export type EvolvedTowerProgression = {
    baseTower: string,
    level: number,
    experience: number,
    requiredExp: number,
    remainingExp: number,
    maxLevel: number,
    baseExp: number,
    growthRate: number,
    owned: boolean,
}

export type Trials = {
    unlocked: boolean,
    minLevel: number,
    levelsNeeded: number,
    current: {
        id: string,
        modifier: string,
        title: string,
        map: string,
        description: string,
        timeRemaining: string,
    },
    upcoming: {
        id: string,
        modifier: string,
        title: string,
        map: string,
        description: string,
    },
    rotationIntervalHours: number,
    modifiers: { [string]: any },
}

export type Loadout = {
    equippedTowers: { string },
    equippedConsumables: { string },
    pets: { [string]: any },
}

export type OwnedTowerInfo = {
    skin: string,
    golden: boolean,
    evolved: boolean,
    equipped: boolean,
}

export type TowerPurchaseInfo = {
    name: string,
    owned: boolean,
    canPurchase: boolean,
    price: number,
    currency: string,
    minLevel: number,
    levelsNeeded: number,
    currencyNeeded: number,
    specialRequirement: string?,
}

export type Inventory = {
    consumables: { [string]: number },
    crates: { [string]: number },
    flairs: { string },
    stickers: { [string]: { Equipped: boolean, Sorting: number } },
    equippedTotem: string,
    equippedTag: string,
    equippedFlair: string,
}

export type PlayerData = {
    level: number,
    isCached: boolean,
    inMatch: boolean,
    player: PlayerInfo,
    currencies: Currencies,
    skills: Skills,
    evolvedProgression: { [string]: EvolvedTowerProgression },
    trials: Trials,
    loadout: Loadout,
    ownedTowers: { [string]: OwnedTowerInfo },
    totalTowersOwned: number,
    goldenTowersOwned: { string },
    evolvedTowersOwned: { string },
    towerPurchases: { [string]: TowerPurchaseInfo },
    inventory: Inventory,
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local PlayerDataHandler = {}

local function getUserCacheFile(): string
    return "GravityScript/cache_" .. tostring(LocalPlayer.UserId) .. ".json"
end

local function decodeJson(rawString: any): any
    if type(rawString) ~= "string" then
        return rawString
    end
    local success, result = pcall(HttpService.JSONDecode, HttpService, rawString:gsub("^\x01", ""))
    return success and result or rawString
end

local function readCacheFile(): any?
    local userPath = getUserCacheFile()
    if isfile and readfile and isfile(userPath) then
        local s, content = pcall(readfile, userPath)
        if s and content and content ~= "" then
            local decSuccess, parsed = pcall(HttpService.JSONDecode, HttpService, content)
            if decSuccess and type(parsed) == "table" then
                return parsed
            end
        end
    end
    return nil
end

local function saveCacheFile(cacheData: any)
    if not (writefile and HttpService) then return end
    pcall(function()
        local encoded = HttpService:JSONEncode(cacheData)
        writefile(getUserCacheFile(), encoded)
    end)
end

--[=[
    Fetches full player stats, economy, loadout, trials, and inventory.
    Automatically handles in-game matches by falling back to per-user cached lobby data.
    @return PlayerData
]=]
function PlayerDataHandler.getStats(): PlayerData
    local inMatch: boolean = (game.PlaceId ~= 3260590327)
    local isCached: boolean = false

    -- 0. Level & Currency Resolution from LocalPlayer instances
    local playerLevel: number = 0
    local lvlObj = LocalPlayer:FindFirstChild("Level")
    if lvlObj and (lvlObj:IsA("IntValue") or lvlObj:IsA("NumberValue")) then
        playerLevel = tonumber(lvlObj.Value) or 0
    end
    if playerLevel == 0 then
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        local lvlVal = leaderstats and (leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("level"))
        if lvlVal and (lvlVal:IsA("IntValue") or lvlVal:IsA("NumberValue")) then
            playerLevel = tonumber(lvlVal.Value) or 0
        end
    end

    local function getPlayerIntValue(name: string): number
        local obj = LocalPlayer:FindFirstChild(name)
        if obj and obj:IsA("IntValue") then
            return obj.Value
        end
        return 0
    end

    local liveCoins = getPlayerIntValue("Coins")
    local liveGems = getPlayerIntValue("Gems")
    local liveTimescale = getPlayerIntValue("TimescaleTickets")
    local liveRevive = getPlayerIntValue("ReviveTickets")
    local liveSpin = getPlayerIntValue("SpinTickets")

    local liveTag = "Default"
    local tagObj = LocalPlayer:FindFirstChild("Tag")
    if tagObj and tagObj:IsA("StringValue") and tagObj.Value ~= "" then
        liveTag = tagObj.Value
    end

    local liveFlair = ""
    local flairObj = LocalPlayer:FindFirstChild("Flair")
    if flairObj and flairObj:IsA("StringValue") and flairObj.Value ~= "" then
        liveFlair = flairObj.Value
    end

    local data: PlayerData = {
        level = playerLevel,
        isCached = false,
        inMatch = inMatch,
        player = {
            name = LocalPlayer.Name,
            displayName = LocalPlayer.DisplayName,
            userId = LocalPlayer.UserId,
            accountAge = LocalPlayer.AccountAge,
            level = playerLevel,
        },
        currencies = {
            coins = liveCoins,
            gems = liveGems,
            timescaleTickets = liveTimescale,
            reviveTickets = liveRevive,
            spinTickets = liveSpin,
        },
        skills = {
            skillTreeUnlocked = (playerLevel >= 15),
            skillsEnabled = true,
            note = nil,
            unlockedSkills = {},
        },
        evolvedProgression = {
            Operator = { baseTower = "Scout", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, baseExp = 50, growthRate = 1.09, owned = false },
            Juggernaut = { baseTower = "Minigunner", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, baseExp = 50, growthRate = 1.09, owned = false },
            Enforcer = { baseTower = "Shotgunner", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, baseExp = 50, growthRate = 1.09, owned = false },
            Kingpin = { baseTower = "Crook Boss", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, baseExp = 50, growthRate = 1.09, owned = false },
        },
        trials = {
            unlocked = false,
            minLevel = 40,
            levelsNeeded = 0,
            current = { id = "none", modifier = "None", title = "None", map = "None", description = "None", timeRemaining = "00:00:00" },
            upcoming = { id = "none", modifier = "None", title = "None", map = "None", description = "None" },
            rotationIntervalHours = 3,
            modifiers = {},
        },
        loadout = {
            equippedTowers = {},
            equippedConsumables = {},
            pets = {},
        },
        ownedTowers = {},
        totalTowersOwned = 0,
        goldenTowersOwned = {},
        evolvedTowersOwned = {},
        towerPurchases = {},
        inventory = {
            consumables = {},
            crates = {},
            flairs = {},
            stickers = {},
            equippedTotem = "Default",
            equippedTag = liveTag,
            equippedFlair = liveFlair,
        },
    }

    local inventoryState: any = nil

    ----------------------------------------------------------------------
    -- 1. Currencies & Settings via filtergc
    ----------------------------------------------------------------------
    if type(filtergc) == "function" then
        local matchedStores = filtergc("table", { Keys = { "getState" } })
        for _, store in ipairs(matchedStores) do
            local success, state = pcall(store.getState, store)
            if success and type(state) == "table" then
                if state.coins ~= nil then
                    data.currencies.coins = tonumber(state.coins) or data.currencies.coins
                    data.currencies.gems = tonumber(state.gems) or data.currencies.gems
                    data.currencies.timescaleTickets = tonumber(state.timescaletickets) or data.currencies.timescaleTickets
                    data.currencies.reviveTickets = tonumber(state.revivetickets) or data.currencies.reviveTickets
                    data.currencies.spinTickets = tonumber(state.spintickets) or data.currencies.spinTickets

                    if state.level ~= nil and tonumber(state.level) and tonumber(state.level) > 0 then
                        playerLevel = tonumber(state.level) or playerLevel
                    end
                end

                if state.Game and state.Game["Skills Enabled"] ~= nil then
                    data.skills.skillsEnabled = (state.Game["Skills Enabled"] == true)
                elseif state.SkillsEnabled ~= nil then
                    data.skills.skillsEnabled = (state.SkillsEnabled == true)
                end

                if state.inventory and not inventoryState then
                    inventoryState = state
                end
            end
        end
    end

    data.level = playerLevel
    data.player.level = playerLevel
    data.skills.skillTreeUnlocked = (playerLevel >= 15)

    ----------------------------------------------------------------------
    -- 2. Loadout via PlayerReplicator (Strict player matching)
    ----------------------------------------------------------------------
    local stateReps = ReplicatedStorage:FindFirstChild("StateReplicators")
    local myPlayerReplicator = nil

    if stateReps then
        for _, child in ipairs(stateReps:GetChildren()) do
            if child.Name == "PlayerReplicator" then
                local uId = child:GetAttribute("UserId")
                local pName = child:GetAttribute("Name")
                if uId == LocalPlayer.UserId or pName == LocalPlayer.Name or pName == LocalPlayer.DisplayName then
                    myPlayerReplicator = child
                    break
                end
            end
        end
        if not myPlayerReplicator then
            myPlayerReplicator = stateReps:FindFirstChild("PlayerReplicator")
        end
    end

    if myPlayerReplicator then
        for key, rawVal in pairs(myPlayerReplicator:GetAttributes()) do
            local decoded = decodeJson(rawVal)
            if key == "EquippedTowers" and type(decoded) == "table" then
                data.loadout.equippedTowers = decoded
            elseif key == "EquippedConsumables" and type(decoded) == "table" then
                data.loadout.equippedConsumables = decoded
            elseif key == "Pets" and type(decoded) == "table" then
                data.loadout.pets = decoded
            end
        end
    end

    ----------------------------------------------------------------------
    -- 3. Live Inventory & Owned Towers (Lobby)
    ----------------------------------------------------------------------
    if inventoryState and inventoryState.inventory then
        for _, item in ipairs(inventoryState.inventory) do
            if item.type == "tower" and item.name then
                local isGolden = item.golden == true
                local isEvolved = item.evolved == true or item.name:find("Evolved") ~= nil
                local isEquipped = table.find(data.loadout.equippedTowers, item.name) ~= nil

                data.ownedTowers[item.name] = {
                    skin = item.skin or "Default",
                    golden = isGolden,
                    evolved = isEvolved,
                    equipped = isEquipped,
                }

                if isGolden then
                    table.insert(data.goldenTowersOwned, item.name)
                end
                if isEvolved then
                    table.insert(data.evolvedTowersOwned, item.name)
                end
                data.totalTowersOwned += 1
            end
        end

        data.inventory.consumables = inventoryState.consumables or {}
        data.inventory.crates = inventoryState.crates or {}
        data.inventory.flairs = inventoryState.flairs or {}
        data.inventory.stickers = inventoryState.stickers or {}
        data.inventory.equippedFlair = inventoryState.equippedFlair or liveFlair

        for totemName, totemInfo in pairs(inventoryState.totems or {}) do
            if totemInfo.Equipped then
                data.inventory.equippedTotem = totemName
                break
            end
        end

        for tagName, tagInfo in pairs(inventoryState.tags or {}) do
            if tagInfo.Equipped then
                data.inventory.equippedTag = tagName
                break
            end
        end
    end

    ----------------------------------------------------------------------
    -- 4. Evolved Tower Progression (Live)
    ----------------------------------------------------------------------
    local baseTowers = { "Scout", "Minigunner", "Shotgunner", "Crook Boss" }
    local towerExpMemoryTable = nil
    local maxTowerExpSum = 0

    if type(filtergc) == "function" then
        for _, baseName in ipairs(baseTowers) do
            local matchedTables = filtergc("table", { Keys = { baseName } })
            for _, tableCandidate in ipairs(matchedTables) do
                local isNumericMap = true
                local expSum = 0
                for k, v in pairs(tableCandidate) do
                    if type(k) ~= "string" or not table.find(baseTowers, k) or type(v) ~= "number" or v < 0 or v > 100000 then
                        isNumericMap = false
                        break
                    end
                    expSum += v
                end
                if isNumericMap and expSum >= maxTowerExpSum then
                    towerExpMemoryTable = tableCandidate
                    maxTowerExpSum = expSum
                end
            end
        end
    end

    for evolvedName, prog in pairs(data.evolvedProgression) do
        local baseName = prog.baseTower
        local currentExp = 0
        if towerExpMemoryTable and type(towerExpMemoryTable[baseName]) == "number" then
            currentExp = towerExpMemoryTable[baseName]
        end

        local currentLevel = 0
        local accumulatedXP = 0
        for lvl = 1, prog.maxLevel do
            local needed = math.floor(prog.baseExp * (prog.growthRate ^ (lvl - 1)))
            if currentExp >= accumulatedXP + needed then
                accumulatedXP += needed
                currentLevel = lvl
            else
                break
            end
        end

        prog.experience = currentExp
        prog.level = currentLevel

        local isOwned = (data.ownedTowers["Evolved" .. evolvedName] ~= nil) or (data.ownedTowers[evolvedName] ~= nil)
        prog.owned = isOwned
        prog.remainingExp = isOwned and 0 or math.max(0, prog.requiredExp - currentExp)
    end

    ----------------------------------------------------------------------
    -- 5. Skill Tree Progression (Live)
    ----------------------------------------------------------------------
    local activeTreeController = nil
    if type(filtergc) == "function" then
        local treeControllers = filtergc("table", { Keys = { "GetSkillDataForNode", "UpdateNodeState" } })
        for _, controller in ipairs(treeControllers) do
            if controller.Trees and controller.Trees[1] then
                activeTreeController = controller
                break
            end
        end
    end

    if activeTreeController and activeTreeController.Trees and activeTreeController.Trees[1] then
        local tree = activeTreeController.Trees[1]
        for _, tile in pairs(tree.Tiles or {}) do
            local skillName: string? = tile.SkillData and tile.SkillData.displayName
            local currentLevel: number? = nil

            if tile.Atoms and tile.Atoms.Level then
                if type(tile.Atoms.Level) == "function" then
                    local s, res = pcall(tile.Atoms.Level)
                    if s and type(res) == "number" then
                        currentLevel = res
                    end
                elseif type(tile.Atoms.Level) == "number" then
                    currentLevel = tile.Atoms.Level
                end
            end

            if not currentLevel or currentLevel == 0 then
                local surfaceGui = tile._surfaceGui or (tile.Mesh and tile.Mesh:FindFirstChild("TileSurfaceGui"))
                if surfaceGui then
                    local frame = surfaceGui:FindFirstChild("Frame")
                    local nameLabel = frame and frame:FindFirstChild("SkillName")
                    if nameLabel and not skillName then
                        skillName = nameLabel.Text
                    end

                    local skillLevelLabel = surfaceGui:FindFirstChild("SkillLevel", true)
                    if skillLevelLabel and skillLevelLabel:IsA("TextLabel") then
                        local text = skillLevelLabel.Text
                        currentLevel = tonumber(text:match("^(%d+)/"))
                        if not currentLevel and text:find("MAX") then
                            currentLevel = tonumber(text:match("%[(%d+)%]"))
                        end
                    end
                end
            end

            if skillName and currentLevel and currentLevel > 0 then
                data.skills.unlockedSkills[skillName] = currentLevel
            end
        end
    end

    ----------------------------------------------------------------------
    -- 6. Match Fallback: Hydrate from Cache or Active Loadout
    ----------------------------------------------------------------------
    local hasRichLobbyData = (data.totalTowersOwned > 0)

    if not hasRichLobbyData then
        local cached = readCacheFile()
        if cached then
            isCached = true
            data.isCached = true

            if cached.ownedTowers then
                data.ownedTowers = cached.ownedTowers
                data.totalTowersOwned = 0
                for tName, tInfo in pairs(data.ownedTowers) do
                    data.totalTowersOwned += 1
                    tInfo.equipped = table.find(data.loadout.equippedTowers, tName) ~= nil
                end
                data.goldenTowersOwned = cached.goldenTowersOwned or {}
                data.evolvedTowersOwned = cached.evolvedTowersOwned or {}
            end

            if next(data.skills.unlockedSkills) == nil and cached.skills and cached.skills.unlockedSkills then
                data.skills.unlockedSkills = cached.skills.unlockedSkills
                data.skills.note = "Skill data loaded from cache (in match)."
            end

            if cached.evolvedProgression then
                for evoName, cachedProg in pairs(cached.evolvedProgression) do
                    if data.evolvedProgression[evoName] then
                        data.evolvedProgression[evoName].owned = cachedProg.owned
                        data.evolvedProgression[evoName].experience = cachedProg.experience or 0
                        data.evolvedProgression[evoName].level = cachedProg.level or 0
                        data.evolvedProgression[evoName].remainingExp = cachedProg.remainingExp or 0
                    end
                end
            end
        else
            -- No cache file for this user yet: match loadout towers are definitely owned!
            if #data.loadout.equippedTowers > 0 then
                for _, tName in ipairs(data.loadout.equippedTowers) do
                    if tName and tName ~= "" and not data.ownedTowers[tName] then
                        data.ownedTowers[tName] = {
                            skin = "Default",
                            golden = false,
                            evolved = false,
                            equipped = true,
                        }
                        data.totalTowersOwned += 1
                    end
                end
            end
        end
    else
        -- In lobby: automatically persist user-specific cache!
        saveCacheFile({
            userId = LocalPlayer.UserId,
            userName = LocalPlayer.Name,
            lastCachedTime = os.time(),
            skills = { unlockedSkills = data.skills.unlockedSkills },
            evolvedProgression = data.evolvedProgression,
            goldenTowersOwned = data.goldenTowersOwned,
            evolvedTowersOwned = data.evolvedTowersOwned,
            ownedTowers = data.ownedTowers,
            inventory = data.inventory,
        })
    end

    ----------------------------------------------------------------------
    -- 7. Trials Rotation & Modifiers
    ----------------------------------------------------------------------
    pcall(function()
        local trialData = require(ReplicatedStorage.Client.Interfaces.Lobby.Components.NewMatchmaking.MatchmakingTrialData)
        local Trials = require(ReplicatedStorage.Shared.Modules.Asset.Handlers.Trials)

        local currentRot = trialData.getCurrentRotation()
        local currentResolved = trialData.resolve(currentRot)
        local minLvl = (currentResolved.queue and currentResolved.queue.requirements and currentResolved.queue.requirements.minLevel) or 40

        data.trials.minLevel = minLvl
        data.trials.unlocked = (playerLevel >= minLvl)
        data.trials.levelsNeeded = math.max(0, minLvl - playerLevel)
        data.trials.rotationIntervalHours = 3

        data.trials.current = {
            id = currentResolved.trialName or currentResolved.id or "trial",
            modifier = currentResolved.title or currentResolved.trialName or "",
            title = currentResolved.title or "",
            map = currentResolved.mapName or "",
            description = currentResolved.subtitle or "",
            timeRemaining = trialData.formatSecondsLeft(currentRot.expiresAt - os.time()),
        }

        local nextRot = trialData.getCurrentRotation(currentRot.expiresAt + 60)
        local nextResolved = trialData.resolve(nextRot)

        data.trials.upcoming = {
            id = nextResolved.trialName or nextResolved.id or "trial",
            modifier = nextResolved.title or nextResolved.trialName or "",
            title = nextResolved.title or "",
            map = nextResolved.mapName or "",
            description = nextResolved.subtitle or "",
        }

        for _, trialName in ipairs(trialData.getTrialNames()) do
            local modInfo = Trials(trialName)
            if modInfo then
                data.trials.modifiers[trialName] = modInfo
            end
        end
    end)

    ----------------------------------------------------------------------
    -- 8. Tower Purchases (Shop catalog)
    ----------------------------------------------------------------------
    local towerFolder = ReplicatedStorage:FindFirstChild("Content") and ReplicatedStorage.Content:FindFirstChild("Tower")
    if towerFolder then
        for _, child in ipairs(towerFolder:GetChildren()) do
            local towerName = child.Name
            if towerName:find("^Evolved") then continue end

            local price = 0
            local currency = "Coins"
            local minLevel = 0
            local specialReq: string? = nil

            local statsMod = child:FindFirstChild("Stats")
            if statsMod and statsMod:IsA("ModuleScript") then
                local s, stats = pcall(require, statsMod)
                if s and type(stats) == "table" and stats.Properties then
                    local p = stats.Properties
                    minLevel = p.Level or 0
                    if p.Price then
                        price = p.Price.Value or 0
                        local pType = p.Price.Type or "2"
                        currency = (pType == "3" and "Gems") or (pType == "1" and "Free") or "Coins"
                        specialReq = p.Price.PreviewText
                    end
                end
            end

            if minLevel == 0 and specialReq then
                local lvlFromReq = tonumber(specialReq:match("LEVEL%s*(%d+)"))
                if lvlFromReq then minLevel = lvlFromReq end
            end

            local isOwned = (data.ownedTowers[towerName] ~= nil)
            local levelsNeeded = math.max(0, minLevel - playerLevel)
            local balance = (currency == "Gems" and data.currencies.gems) or data.currencies.coins
            local currencyNeeded = isOwned and 0 or math.max(0, price - balance)
            local canPurchase = (not isOwned) and (levelsNeeded == 0) and (currencyNeeded == 0) and (price > 0)

            data.towerPurchases[towerName] = {
                name = towerName,
                owned = isOwned,
                canPurchase = canPurchase,
                price = price,
                currency = currency,
                minLevel = minLevel,
                levelsNeeded = levelsNeeded,
                currencyNeeded = currencyNeeded,
                specialRequirement = specialReq,
            }
        end
    end

    return data
end

PlayerDataHandler.getData = PlayerDataHandler.getStats
PlayerDataHandler.get = PlayerDataHandler.getStats

setmetatable(PlayerDataHandler, {
    __call = function(_)
        return PlayerDataHandler.getStats()
    end,
})

return PlayerDataHandler
