local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local PlayerDataChecker = {}

local function decodeJson(rawString)
    if type(rawString) ~= "string" then
        return rawString
    end
    local success, result = pcall(HttpService.JSONDecode, HttpService, rawString:gsub("^\x01", ""))
    return success and result or rawString
end

function PlayerDataChecker.getStats()
    local data = {
        player = {
            name = LocalPlayer.Name,
            displayName = LocalPlayer.DisplayName,
            userId = LocalPlayer.UserId,
            accountAge = LocalPlayer.AccountAge
        },
        currencies = {
            coins = 0,
            gems = 0,
            timescaleTickets = 0,
            reviveTickets = 0,
            spinTickets = 0
        },
        progression = {
            level = 0,
            experience = 0,
            triumphs = 0,
            wins = 0,
            loses = 0,
            rank = -1,
            tutorial = 0,
            tag = "Default",
            flair = "none",
            medals = {
                normal = 0,
                easy = 0,
                insane = 0
            }
        },
        skills = {
            skillTreeUnlocked = false,
            skillsEnabled = true,
            unlockedSkills = {}
        },
        evolvedProgression = {
            Operator = { baseTower = "Scout", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, owned = false },
            Juggernaut = { baseTower = "Minigunner", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, owned = false },
            Enforcer = { baseTower = "Shotgunner", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, owned = false },
            Kingpin = { baseTower = "Crook Boss", level = 0, experience = 0, requiredExp = 2549, remainingExp = 2549, maxLevel = 20, owned = false }
        },
        replicator = {
            loginStreak = 0,
            streak = 0,
            mapsCleared = 0,
            pvpWins = 0,
            pvpLosses = 0,
            enemiesKilled = 0,
            enemiesSent = 0,
            vipPlus = false,
            legacyVip = false,
            econ = 0,
            cash = 0,
            luck = 0
        },
        loadout = {
            equippedTowers = {},
            equippedPvpTowers = {},
            equippedConsumables = {},
            pets = {}
        },
        ownedTowers = {},
        totalTowersOwned = 0,
        goldenTowersOwned = {},
        evolvedTowersOwned = {},
        inventory = {
            consumables = {},
            crates = {},
            flairs = {},
            stickers = {},
            equippedTotem = "Default",
            equippedTag = "Default"
        },
        challenge = nil,
        availableMissions = {},
        playtimeRewardTimer = nil
    }

    local playerReplicator = ReplicatedStorage:FindFirstChild("StateReplicators") and ReplicatedStorage.StateReplicators:FindFirstChild("PlayerReplicator")
    if playerReplicator then
        local directMapping = {
            EquippedTowers = function(v) data.loadout.equippedTowers = v end,
            EquippedPVPTowers = function(v) data.loadout.equippedPvpTowers = v end,
            EquippedConsumables = function(v) data.loadout.equippedConsumables = v end,
            Pets = function(v) data.loadout.pets = v end,
            Medals = function(v) data.progression.medals = v end
        }

        for key, rawValue in pairs(playerReplicator:GetAttributes()) do
            local decodedValue = decodeJson(rawValue)
            local mapper = directMapping[key]
            if mapper then
                mapper(decodedValue)
            else
                local lowerCamelKey = key:sub(1, 1):lower() .. key:sub(2)
                if data.replicator[lowerCamelKey] ~= nil then
                    data.replicator[lowerCamelKey] = decodedValue
                end
            end
        end
    end

    for _, store in ipairs(filtergc("table", { Keys = {"getState"} })) do
        local success, state = pcall(store.getState, store)
        if not success or type(state) ~= "table" then
            continue
        end

        if state.coins ~= nil then
            data.currencies.coins = state.coins
            data.currencies.gems = state.gems
            data.currencies.timescaleTickets = state.timescaletickets
            data.currencies.reviveTickets = state.revivetickets
            data.currencies.spinTickets = state.spintickets
            data.progression.level = state.level
            data.progression.experience = state.experience
            data.progression.triumphs = state.triumphs
            data.progression.wins = state.wins
            data.progression.loses = state.loses
            data.progression.tutorial = state.tutorial
            data.skills.skillTreeUnlocked = (state.level or 0) >= 15
        end

        if state.inventory and data.totalTowersOwned == 0 then
            for _, item in ipairs(state.inventory) do
                if item.type ~= "tower" or not item.name then
                    continue
                end

                local isGolden = item.golden == true
                local isEvolved = item.evolved == true or item.name:find("Evolved") ~= nil

                data.ownedTowers[item.name] = {
                    skin = item.skin or "Default",
                    golden = isGolden,
                    evolved = isEvolved,
                    equipped = table.find(data.loadout.equippedTowers, item.name) ~= nil
                }

                if isGolden then
                    table.insert(data.goldenTowersOwned, item.name)
                end
                if isEvolved then
                    table.insert(data.evolvedTowersOwned, item.name)
                    local cleanName = item.name:gsub("^Evolved%s*", "")
                    if data.evolvedProgression[cleanName] then
                        data.evolvedProgression[cleanName].owned = true
                        data.evolvedProgression[cleanName].remainingExp = 0
                    end
                end
                data.totalTowersOwned += 1
            end

            data.inventory.consumables = state.consumables or {}
            data.inventory.crates = state.crates or {}
            data.inventory.flairs = state.flairs or {}
            data.inventory.stickers = state.stickers or {}

            if state.equippedFlair and state.equippedFlair ~= "" then
                data.progression.flair = state.equippedFlair
            end

            for totemName, totemInfo in pairs(state.totems or {}) do
                if totemInfo.Equipped then
                    data.inventory.equippedTotem = totemName
                    break
                end
            end

            for tagName, tagInfo in pairs(state.tags or {}) do
                if tagInfo.Equipped then
                    data.inventory.equippedTag = tagName
                    break
                end
            end
        end

        if state.SkillsEnabled ~= nil then
            data.skills.skillsEnabled = state.SkillsEnabled
        end

        if state.challenge and state.map and state.rewards then
            data.challenge = {
                name = state.challenge,
                map = state.map,
                completed = state.completed or false,
                expires = state.timeExpires
            }
        end

        if state.Rotations and state.Rotations.Missions and #data.availableMissions == 0 then
            for _, mission in ipairs(state.Rotations.Missions) do
                if not mission.tome then
                    continue
                end
                table.insert(data.availableMissions, {
                    id = mission.id,
                    name = mission.tome.name or mission.id,
                    price = mission.price or (mission.tome.cost and mission.tome.cost.amount) or 0,
                    currency = mission.currency or (mission.tome.cost and mission.tome.cost.currency) or "coins"
                })
            end
        end
    end

    local activeTreeController = nil
    for _, tableObject in ipairs(filtergc("table", { Keys = {"GetSkillDataForNode", "UpdateNodeState"} })) do
        activeTreeController = tableObject
        break
    end

    if activeTreeController and activeTreeController.Trees and activeTreeController.Trees[1] then
        for _, tile in pairs(activeTreeController.Trees[1].Tiles or {}) do
            local surfaceGui = tile._surfaceGui or (tile.Mesh and tile.Mesh:FindFirstChild("TileSurfaceGui"))
            if surfaceGui then
                local frame = surfaceGui:FindFirstChild("Frame")
                local skillNameLabel = frame and frame:FindFirstChild("SkillName")
                local skillLevelLabel = surfaceGui:FindFirstChild("SkillLevel", true)
                
                if skillNameLabel and skillLevelLabel then
                    local text = skillLevelLabel.Text
                    local currentLevel = tonumber(text:match("^(%d+)/"))
                    
                    if not currentLevel and text:find("MAX") then
                        currentLevel = tonumber(text:match("%[(%d+)%]"))
                    end

                    if currentLevel and currentLevel > 0 then
                        data.skills.unlockedSkills[skillNameLabel.Text] = currentLevel
                    end
                end
            end
        end
    end

    local baseTowers = {"Scout", "Minigunner", "Shotgunner", "Crook Boss"}
    local towerExpMemoryTable = nil
    local maxTowerExpSum = 0

    for _, baseName in ipairs(baseTowers) do
        local matchedTables = filtergc("table", { Keys = {baseName} })
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

    for _, progressionData in pairs(data.evolvedProgression) do
        local baseTowerName = progressionData.baseTower
        local currentExp = 0

        if towerExpMemoryTable and type(towerExpMemoryTable[baseTowerName]) == "number" then
            currentExp = towerExpMemoryTable[baseTowerName]
        end

        local currentLevel = 0
        local accumulatedXP = 0
        for lvl = 1, progressionData.maxLevel do
            local needed = math.floor(50 * (1.09 ^ (lvl - 1)))
            if currentExp >= accumulatedXP + needed then
                accumulatedXP += needed
                currentLevel = lvl
            else
                break
            end
        end

        progressionData.experience = currentExp
        progressionData.level = currentLevel

        if not progressionData.owned then
            progressionData.remainingExp = math.max(0, progressionData.requiredExp - currentExp)
        end
    end

    for _, tableObject in ipairs(filtergc("table", { Keys = {"rewards"} })) do
        if type(tableObject.rewards) == "table" and type(tableObject.rewards.props) == "table" then
            local rewardText = tableObject.rewards.props.text
            if type(rewardText) == "string" and rewardText:find("%d+:%d+") then
                data.playtimeRewardTimer = rewardText
                break
            end
        end
    end

    return data
end

function PlayerDataChecker.getLevel()
    local stats = PlayerDataChecker.getStats()
    return stats.progression.level
end

return PlayerDataChecker
