local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

local function findChildPath(rootInstance, ...)
    local currentInstance = rootInstance
    for index = 1, select("#", ...) do
        if not currentInstance then
            return nil
        end
        currentInstance = currentInstance:FindFirstChild((select(index, ...)))
    end
    return currentInstance
end

local function toLowerCamelCase(sourceString)
    if #sourceString == 0 then
        return sourceString
    end
    return sourceString:sub(1, 1):lower() .. sourceString:sub(2)
end

local function decodeJson(rawString)
    if type(rawString) ~= "string" then
        return rawString
    end
    local success, result = pcall(HttpService.JSONDecode, HttpService, rawString:gsub("^\x01", ""))
    if success then
        return result
    end
    return rawString
end

local function calculateNextLevelExperience(level)
    return math.min(1150, (level + 1) * 25)
end

local function parseRewards(rawRewards)
    local rewardsList = {}
    if type(rawRewards) ~= "table" then
        return rewardsList
    end
    for _, rewardItem in ipairs(rawRewards) do
        if type(rewardItem) == "table" then
            local rewardType = rewardItem.type or "item"
            if rewardType == "xp" then
                table.insert(rewardsList, {
                    type = "xp",
                    amount = rewardItem.amount or 0
                })
            elseif rewardType == "tower" then
                table.insert(rewardsList, {
                    type = "skin",
                    tower = rewardItem.tower or "Unknown",
                    skin = rewardItem.skin or "Default"
                })
            elseif rewardType == "crate" or rewardType == "crates" then
                table.insert(rewardsList, {
                    type = "crate",
                    crate = rewardItem.crate or rewardItem.id or "Crate",
                    amount = rewardItem.amount or 1
                })
            elseif rewardType == "currency" or rewardType == "coins" or rewardType == "gems" then
                table.insert(rewardsList, {
                    type = rewardItem.currency or rewardType,
                    amount = rewardItem.amount or 0
                })
            else
                table.insert(rewardsList, rewardItem)
            end
        end
    end
    return rewardsList
end

local function createDataStructure()
    return {
        player = {
            name = localPlayer.Name,
            displayName = localPlayer.DisplayName,
            userId = localPlayer.UserId,
            accountAge = localPlayer.AccountAge
        },
        membership = {
            vip = false,
            vipPlus = false,
            legacyVip = false
        },
        spinWheel = {
            canSpin = false
        },
        dailyLogin = {
            loginStreak = 0,
            currentDay = 1,
            claimedDay = 0,
            canClaimDaily = false,
            schedule = {}
        },
        gameModes = {},
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
            requiredExp = 25,
            remainingExp = 25,
            triumphs = 0,
            wins = 0,
            loses = 0,
            totalMatches = 0,
            winRatio = 0,
            rank = -1,
            tutorial = 0,
            medals = {
                normal = 0,
                easy = 0,
                insane = 0
            }
        },
        skills = {
            skillTreeUnlocked = false,
            skillsEnabled = true,
            note = "Skill tree node allocations are available only in Lobby",
            unlockedSkills = {}
        },
        evolvedProgression = {},
        pvpAndMatch = {
            unlocked = false,
            minLevel = 25,
            levelsNeeded = 25,
            pvpWins = 0,
            pvpLosses = 0,
            mapsCleared = 0,
            streak = 0,
            cash = 0,
            econ = 0,
            luck = 0,
            equippedPvpTowers = {},
            equippedPvpConsumables = {},
            equippedTowerPets = {}
        },
        trials = {
            unlocked = false,
            minLevel = 40,
            levelsNeeded = 40,
            current = {
                id = "None",
                modifier = "None",
                title = "None",
                map = "Unknown",
                description = "",
                timeRemaining = "00:00:00"
            },
            upcoming = {
                id = "None",
                modifier = "None",
                title = "None",
                map = "Unknown",
                description = ""
            },
            rotationIntervalHours = 3,
            modifiers = {}
        },
        loadout = {
            equippedTowers = {},
            equippedConsumables = {},
            pets = {}
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
            equippedTag = "Default",
            equippedFlair = "Default"
        },
        challenge = nil,
        quests = {
            daily = {},
            weekly = {},
            missions = {}
        },
        logbook = {
            enemiesFound = 0,
            enemiesTotal = 179,
            note = "Logbook discovery list is available only in Lobby",
            unlockedEnemies = {}
        },
        achievements = {},
        freePlaytimeRewards = {
            canClaimAny = false,
            readyToClaimCount = 0,
            nextRewardTimer = nil,
            note = "Playtime reward claim countdowns and gifts are available only in Lobby",
            gifts = {},
            giftAds = {
                canClaimAny = false,
                readyToClaimCount = 0,
                resetTimer = nil,
                offers = {}
            }
        },
        leaderboards = {
            monthlyTriumphs = {
                onLeaderboard = false,
                rank = nil,
                currentScore = 0,
                minimumToEnter = 0,
                difference = 0
            },
            monthlyExperience = {
                onLeaderboard = false,
                rank = nil,
                currentScore = 0,
                minimumToEnter = 0,
                difference = 0
            }
        },
        maxAccount = {
            isMaxed = false,
            allTowersOwned = false,
            missingTowers = {},
            maxSkillTree = false
        }
    }
end

local function collectMemoryTables(filterPredicates)
    local resolvedTowerTable = nil
    if not filterPredicates or filterPredicates.includePurchases or filterPredicates.includeEvolution then
        for _, candidate in ipairs(filtergc("table", { Keys = {"Scout", "Minigunner", "Commander"} }) or {}) do
            if type(candidate.Minigunner) == "table" and candidate.Minigunner.Properties then
                resolvedTowerTable = candidate
                break
            end
        end
    end

    local resolvedGameModes = nil
    local resolvedMatchmakingController = nil
    if not filterPredicates or filterPredicates.includeGameModes then
        for _, candidate in ipairs(filtergc("table", { Keys = {"Voidcore", "PollutedWasteland", "Badlands"} }) or {}) do
            if type(candidate.Voidcore) == "table" and candidate.Voidcore.EstimatedTime then
                resolvedGameModes = candidate
                break
            end
        end
        if not resolvedGameModes then
            for _, candidate in ipairs(filtergc("table", { Keys = {"Voidcore", "Hardcore"} }) or {}) do
                if type(candidate.Voidcore) == "table" and candidate.Voidcore.EstimatedTime then
                    resolvedGameModes = candidate
                    break
                end
            end
        end

        resolvedMatchmakingController = filtergc("table", { Keys = {"MODE_GROUPS"} }, true)
    end

    local resolvedTrialDefinitions = nil
    if not filterPredicates or filterPredicates.includeTrials then
        resolvedTrialDefinitions = filtergc("table", { Keys = {"HiddenEnemies", "Glass", "Jailed"} }, true)
    end

    local resolvedStoreInstances = {}
    if not filterPredicates or filterPredicates.includeStore then
        resolvedStoreInstances = filtergc("table", { Keys = {"getState"} }) or {}
    end

    local resolvedTreeController = nil
    if not filterPredicates or filterPredicates.includeSkills then
        resolvedTreeController = filtergc("table", { Keys = {"GetSkillDataForNode", "UpdateNodeState"} }, true)
    end

    local resolvedLeaderboardTable = nil
    if not filterPredicates or filterPredicates.includeLeaderboards then
        resolvedLeaderboardTable = filtergc("table", { Keys = {"Triumphs", "Experience"} }, true)
    end

    return {
        towerTable = resolvedTowerTable,
        trialDefinitions = resolvedTrialDefinitions,
        storeInstances = resolvedStoreInstances,
        dynamicGameModes = resolvedGameModes,
        matchmakingController = resolvedMatchmakingController,
        questTables = (not filterPredicates or filterPredicates.includeQuests)
            and (filtergc("table", { Keys = {"category", "objectives", "rewards"} }) or {}) or {},
        treeController = resolvedTreeController,
        candidateExperienceTables = (not filterPredicates or filterPredicates.includeEvolution)
            and (filtergc("table", { Keys = {"Scout", "Minigunner"} }) or {}) or {},
        playtimeRewardTables = (not filterPredicates or filterPredicates.includePlaytime)
            and (filtergc("table", { Keys = {"rewards"} }) or {}) or {},
        leaderboardTable = resolvedLeaderboardTable
    }
end

local function extractEvolutionMetadata(data, towerTable)
    local baseTowers = {}
    if not towerTable then
        return baseTowers
    end

    for towerName, towerDefinition in pairs(towerTable) do
        local hasProperties = type(towerDefinition) == "table" and towerDefinition.Properties
        if hasProperties and towerDefinition.Properties.EvolvedTo and towerDefinition.Properties.Progression then
            local properties = towerDefinition.Properties
            local evolvedName = properties.EvolvedTo:gsub("^Evolved%s*", "")
            local maxLevel = properties.Progression.MaxLevel or 20
            local baseExperience = properties.Progression.BaseExp or 50
            local growthRate = properties.Progression.GrowthRate or 1.09
            local totalRequiredExperience = 0

            for levelIndex = 1, maxLevel do
                local levelExperience = math.floor(baseExperience * (growthRate ^ (levelIndex - 1)))
                totalRequiredExperience = totalRequiredExperience + levelExperience
            end

            data.evolvedProgression[evolvedName] = {
                baseTower = towerName,
                level = 0,
                experience = 0,
                requiredExp = totalRequiredExperience,
                remainingExp = totalRequiredExperience,
                maxLevel = maxLevel,
                baseExp = baseExperience,
                growthRate = growthRate,
                owned = false
            }
            table.insert(baseTowers, towerName)
        end
    end
    return baseTowers
end

local function extractReplicatedState(data, passedTrialDefinitions)
    local hasVoidcoreAccess = false
    local trialDefinitions = passedTrialDefinitions or {}

    local sortedTrialNames = {}
    for trialName in pairs(trialDefinitions) do
        table.insert(sortedTrialNames, trialName)
    end
    table.sort(sortedTrialNames)

    local stateReplicators = ReplicatedStorage:FindFirstChild("StateReplicators")
    if not stateReplicators then
        return hasVoidcoreAccess
    end

    local playerReplicator = nil
    for _, child in ipairs(stateReplicators:GetChildren()) do
        if child.Name == "PlayerReplicator" then
            local targetUserId = child:GetAttribute("UserId")
            local targetName = child:GetAttribute("Name")
            local isLocalPlayerUserId = (targetUserId == localPlayer.UserId)
                or (tostring(targetUserId) == tostring(localPlayer.UserId))
            if isLocalPlayerUserId or targetName == localPlayer.Name then
                playerReplicator = child
                break
            elseif not playerReplicator then
                playerReplicator = child
            end
        end
    end

    if playerReplicator then
        local directMapping = {
            EquippedTowers = function(value)
                data.loadout.equippedTowers = value
            end,
            EquippedPVPTowers = function(value)
                data.pvpAndMatch.equippedPvpTowers = value
            end,
            EquippedConsumables = function(value)
                data.loadout.equippedConsumables = value
            end,
            EquippedPVPConsumables = function(value)
                data.pvpAndMatch.equippedPvpConsumables = value
            end,
            Pets = function(value)
                data.loadout.pets = value
                data.pvpAndMatch.equippedTowerPets = value
            end,
            Medals = function(value)
                data.progression.medals = value
            end,
            LoginStreak = function(value)
                data.dailyLogin.loginStreak = tonumber(value) or 0
            end,
            VIP = function(value)
                if value == true then
                    data.membership.vip = true
                end
            end,
            VIPPlus = function(value)
                data.membership.vipPlus = (value == true)
                if value == true then
                    data.membership.vip = true
                end
            end,
            LegacyVIP = function(value)
                data.membership.legacyVip = (value == true)
                if value == true then
                    data.membership.vip = true
                end
            end,
            PVPWins = function(value)
                data.pvpAndMatch.pvpWins = tonumber(value) or 0
            end,
            PvpWins = function(value)
                data.pvpAndMatch.pvpWins = tonumber(value) or 0
            end,
            PVPLosses = function(value)
                data.pvpAndMatch.pvpLosses = tonumber(value) or 0
            end,
            PvpLosses = function(value)
                data.pvpAndMatch.pvpLosses = tonumber(value) or 0
            end,
            HasVoidcoreAccess = function(value)
                hasVoidcoreAccess = (value == true)
            end,
            VoidcoreAccess = function(value)
                hasVoidcoreAccess = (value == true)
            end
        }
        for attributeKey, rawAttributeValue in pairs(playerReplicator:GetAttributes()) do
            local decodedAttributeValue = decodeJson(rawAttributeValue)
            local mappingFunction = directMapping[attributeKey]
            if mappingFunction then
                mappingFunction(decodedAttributeValue)
            else
                local lowerCamelKey = toLowerCamelCase(attributeKey)
                if data.pvpAndMatch[lowerCamelKey] ~= nil then
                    data.pvpAndMatch[lowerCamelKey] = decodedAttributeValue
                end
            end
        end
    end

    local trialsReplicator = stateReplicators:FindFirstChild("TrialsStateReplicator")
        or stateReplicators:FindFirstChild("TrialsStateReplicators")
    local gameStateReplicator = stateReplicators:FindFirstChild("GameStateReplicator")
    local globalTrialId = (trialsReplicator and trialsReplicator:GetAttribute("GlobalTrial"))
        or (gameStateReplicator and gameStateReplicator:GetAttribute("GlobalTrial"))

    local currentTime = os.time()
    local rotationInterval = 10800
    local endsAt = (math.floor(currentTime / rotationInterval) + 1) * rotationInterval
    local secondsRemaining = math.max(0, endsAt - currentTime)

    if (not globalTrialId or globalTrialId == "") and #sortedTrialNames > 0 then
        local currentRotationIndex = (math.floor(currentTime / rotationInterval) % #sortedTrialNames) + 1
        globalTrialId = sortedTrialNames[currentRotationIndex]
    end

    if globalTrialId and globalTrialId ~= "" then
        data.trials.current.id = globalTrialId
        local currentDefinition = trialDefinitions[globalTrialId] or {}
        local currentTitle = currentDefinition.title or globalTrialId
        data.trials.current.modifier = currentTitle
        data.trials.current.title = currentTitle
        data.trials.current.map = currentDefinition.trialMap or "Unknown"
        data.trials.current.description = currentDefinition.description or ""
        local remainingHours = math.floor(secondsRemaining / 3600)
        local remainingMinutes = math.floor((secondsRemaining % 3600) / 60)
        local remainingSeconds = secondsRemaining % 60
        data.trials.current.timeRemaining = string.format(
            "%02d:%02d:%02d",
            remainingHours,
            remainingMinutes,
            remainingSeconds
        )

        local currentIndex = table.find(sortedTrialNames, globalTrialId) or 1
        if #sortedTrialNames > 0 then
            local nextIndex = (currentIndex % #sortedTrialNames) + 1
            local nextTrialId = sortedTrialNames[nextIndex]
            local nextDefinition = trialDefinitions[nextTrialId] or {}
            local nextTitle = nextDefinition.title or nextTrialId
            data.trials.upcoming.id = nextTrialId
            data.trials.upcoming.modifier = nextTitle
            data.trials.upcoming.title = nextTitle
            data.trials.upcoming.map = nextDefinition.trialMap or "Unknown"
            data.trials.upcoming.description = nextDefinition.description or ""
        end
    end

    if trialsReplicator then
        for attributeKey, rawAttributeValue in pairs(trialsReplicator:GetAttributes()) do
            if attributeKey ~= "GlobalTrial" then
                data.trials.modifiers[attributeKey] = decodeJson(rawAttributeValue)
            end
        end
    elseif gameStateReplicator then
        for attributeKey, rawAttributeValue in pairs(gameStateReplicator:GetAttributes()) do
            local isGlobalModifier = (attributeKey == "GlobalModifiersEnabled")
            local isClientModifier = (attributeKey == "ClientModifiers")
            local isShrineModifier = (attributeKey == "ShrineModifiers")
            if isGlobalModifier or isClientModifier or isShrineModifier then
                local decodedModifiers = decodeJson(rawAttributeValue)
                if type(decodedModifiers) == "table" then
                    for modifierIndex, modifierValue in pairs(decodedModifiers) do
                        data.trials.modifiers[tostring(modifierIndex)] = modifierValue
                    end
                end
            end
        end
    end

    return hasVoidcoreAccess
end

local function extractGameStateStore(data, preloadedStores)
    local storeInstances = preloadedStores or filtergc("table", { Keys = {"getState"} }) or {}
    for _, storeInstance in ipairs(storeInstances) do
        local success, stateData = pcall(storeInstance.getState, storeInstance)
        if success and type(stateData) == "table" then
            if stateData.coins ~= nil then
                data.currencies.coins = stateData.coins
                data.currencies.gems = stateData.gems
                data.currencies.timescaleTickets = stateData.timescaletickets
                data.currencies.reviveTickets = stateData.revivetickets
                data.currencies.spinTickets = stateData.spintickets
                data.spinWheel.canSpin = (stateData.spintickets or 0) > 0
                data.progression.level = stateData.level
                data.progression.experience = stateData.experience
                data.progression.triumphs = stateData.triumphs or 0
                data.progression.wins = stateData.wins or 0
                data.progression.loses = stateData.loses or 0
                data.progression.totalMatches = (data.progression.triumphs or 0) + (data.progression.loses or 0)
                local calculatedRatio = (data.progression.triumphs or 0) / math.max(1, data.progression.loses or 0)
                data.progression.winRatio = math.floor(calculatedRatio * 100 + 0.5) / 100
                data.progression.tutorial = stateData.tutorial
                if stateData.rank ~= nil then
                    data.progression.rank = stateData.rank
                elseif stateData.Rank ~= nil then
                    data.progression.rank = stateData.Rank
                end
                data.skills.skillTreeUnlocked = (stateData.level or 0) >= 15

                local pvpMinLevel = data.pvpAndMatch.minLevel or 25
                data.pvpAndMatch.unlocked = (stateData.level or 0) >= pvpMinLevel
                data.pvpAndMatch.levelsNeeded = math.max(0, pvpMinLevel - (stateData.level or 0))

                local trialMinLevel = data.trials.minLevel or 40
                data.trials.unlocked = (stateData.level or 0) >= trialMinLevel
                data.trials.levelsNeeded = math.max(0, trialMinLevel - (stateData.level or 0))

                local requiredExperience = calculateNextLevelExperience(stateData.level or 0)
                data.progression.requiredExp = requiredExperience
                data.progression.remainingExp = math.max(0, requiredExperience - (stateData.experience or 0))
            end

            if stateData.inventory and data.totalTowersOwned == 0 then
                for _, inventoryItem in ipairs(stateData.inventory) do
                    if inventoryItem.type == "tower" and inventoryItem.name then
                        local isGoldenTower = inventoryItem.golden == true
                        local isEvolvedTower = (inventoryItem.evolved == true)
                            or (inventoryItem.name:find("Evolved") ~= nil)
                        data.ownedTowers[inventoryItem.name] = {
                            skin = inventoryItem.skin or "Default",
                            golden = isGoldenTower,
                            evolved = isEvolvedTower,
                            equipped = table.find(data.loadout.equippedTowers, inventoryItem.name) ~= nil
                        }
                        if isGoldenTower then
                            table.insert(data.goldenTowersOwned, inventoryItem.name)
                        end
                        if isEvolvedTower then
                            table.insert(data.evolvedTowersOwned, inventoryItem.name)
                            local baseEvolvedTowerName = inventoryItem.name:gsub("^Evolved%s*", "")
                            if data.evolvedProgression[baseEvolvedTowerName] then
                                data.evolvedProgression[baseEvolvedTowerName].owned = true
                                data.evolvedProgression[baseEvolvedTowerName].remainingExp = 0
                            end
                        end
                        data.totalTowersOwned = data.totalTowersOwned + 1
                    end
                end

                local inventoryController = filtergc("table", { Keys = {"ownsGolden", "getSkins"} }, true)

                local goldenTowerNames = {"Minigunner", "Soldier", "Cowboy", "Scout", "Pyromancer", "Crook Boss"}
                for _, towerName in ipairs(goldenTowerNames) do
                    local isTowerOwned = false
                    if data.ownedTowers[towerName] then
                        if inventoryController then
                            local checkSuccess, isGoldenVariantOwned = pcall(function()
                                return inventoryController:ownsGolden({ type = "tower", name = towerName })
                            end)
                            if checkSuccess and isGoldenVariantOwned == true then
                                isTowerOwned = true
                            end
                        end
                        if not isTowerOwned and stateData.skins and stateData.skins[towerName] then
                            for _, skinName in ipairs(stateData.skins[towerName]) do
                                if skinName == "Golden" then
                                    isTowerOwned = true
                                    break
                                end
                            end
                        end
                        if not isTowerOwned and data.ownedTowers[towerName].golden == true then
                            isTowerOwned = true
                        end
                    end
                    if isTowerOwned then
                        if not table.find(data.goldenTowersOwned, towerName) then
                            table.insert(data.goldenTowersOwned, towerName)
                        end
                        if data.ownedTowers[towerName] then
                            data.ownedTowers[towerName].golden = true
                        end
                    end
                end
            end

            if stateData.consumables and type(stateData.consumables) == "table" then
                if next(stateData.consumables) ~= nil or next(data.inventory.consumables) == nil then
                    data.inventory.consumables = table.clone(stateData.consumables)
                end
            end

            if stateData.crates and type(stateData.crates) == "table" then
                if next(stateData.crates) ~= nil or next(data.inventory.crates) == nil then
                    data.inventory.crates = table.clone(stateData.crates)
                end
            end

            if stateData.flairs and type(stateData.flairs) == "table" then
                if #stateData.flairs > 0 or #data.inventory.flairs == 0 then
                    data.inventory.flairs = table.clone(stateData.flairs)
                end
            end

            if stateData.stickers and type(stateData.stickers) == "table" then
                if next(stateData.stickers) ~= nil or next(data.inventory.stickers) == nil then
                    local clonedStickers = {}
                    for stickerName, stickerData in pairs(stateData.stickers) do
                        local stickerValue = type(stickerData) == "table" and table.clone(stickerData)
                            or stickerData
                        clonedStickers[stickerName] = stickerValue
                    end
                    data.inventory.stickers = clonedStickers
                end
            end

            if stateData.equippedFlair and stateData.equippedFlair ~= "" then
                data.inventory.equippedFlair = stateData.equippedFlair
            end

            if stateData.totems and type(stateData.totems) == "table" then
                for totemName, totemInfo in pairs(stateData.totems) do
                    if type(totemInfo) == "table" and totemInfo.Equipped then
                        data.inventory.equippedTotem = totemName
                        break
                    end
                end
            end

            if stateData.tags and type(stateData.tags) == "table" then
                for tagName, tagInfo in pairs(stateData.tags) do
                    if type(tagInfo) == "table" and tagInfo.Equipped then
                        data.inventory.equippedTag = tagName
                        break
                    end
                end
            end

            if stateData.SkillsEnabled ~= nil then
                data.skills.skillsEnabled = stateData.SkillsEnabled
            end

            if stateData.challenge and stateData.map and stateData.rewards then
                data.challenge = {
                    name = stateData.challenge,
                    map = stateData.map,
                    completed = stateData.completed or false,
                    expires = stateData.timeExpires
                }
            end

            if stateData.Rotations and stateData.Rotations.Missions and #data.quests.missions == 0 then
                for _, missionItem in ipairs(stateData.Rotations.Missions) do
                    if type(missionItem) == "table" then
                        local tomeData = type(missionItem.tome) == "table" and missionItem.tome or {}
                        local missionName = tomeData.name or missionItem.id or "Unknown"
                        local fallbackDescription = type(tomeData.objectives) == "table"
                            and tomeData.objectives[1]
                            and tomeData.objectives[1].description
                        local missionDescription = tomeData.description or fallbackDescription or "No description"
                        local fallbackCost = type(tomeData.cost) == "table" and tonumber(tomeData.cost.amount)
                        local costAmount = tonumber(missionItem.price) or fallbackCost or 0
                        local fallbackCurrency = type(tomeData.cost) == "table" and tomeData.cost.currency
                        local costCurrency = tostring(missionItem.currency or fallbackCurrency or "coins")

                        table.insert(data.quests.missions, {
                            id = tostring(missionItem.id or "Unknown"),
                            name = tostring(missionName),
                            description = tostring(missionDescription),
                            price = costAmount,
                            currency = costCurrency,
                            rewards = parseRewards(tomeData.rewards)
                        })
                    end
                end
            end
        end
    end
end

local function extractGameModes(data, hasVoidcoreAccess, preloadedGameModes, preloadedMatchmakingController)
    local dynamicGameModes = preloadedGameModes
    if not dynamicGameModes then
        for _, candidate in ipairs(filtergc("table", { Keys = {"Voidcore", "PollutedWasteland", "Badlands"} }) or {}) do
            if type(candidate.Voidcore) == "table" and candidate.Voidcore.EstimatedTime then
                dynamicGameModes = candidate
                break
            end
        end
        if not dynamicGameModes then
            for _, candidate in ipairs(filtergc("table", { Keys = {"Voidcore", "Hardcore"} }) or {}) do
                if type(candidate.Voidcore) == "table" and candidate.Voidcore.EstimatedTime then
                    dynamicGameModes = candidate
                    break
                end
            end
        end
    end

    local matchmakingController = preloadedMatchmakingController
        or filtergc("table", { Keys = {"MODE_GROUPS"} }, true)

    local function findMetadata(modeId, modeName)
        if not dynamicGameModes then
            return nil
        end
        local lowerModeId = modeId:lower()
        local lowerName = modeName and tostring(modeName):lower() or ""
        for rawKey, rawVal in pairs(dynamicGameModes) do
            if type(rawVal) == "table" then
                local cleanKey = tostring(rawKey):lower():gsub("%s+", "")
                if cleanKey == lowerModeId or (lowerName ~= "" and cleanKey == lowerName) then
                    return rawVal
                end
            end
        end
        return nil
    end

    local playerLevel = data.progression.level or 0
    local dummyContext = {
        playerLevel = 0,
        hasVoidcoreAccess = false,
        hasSandboxAdmin = false,
        sandboxEnabled = true,
        pvpEnabled = true,
        isPartyLeader = true,
        partySize = 1
    }

    if matchmakingController and type(matchmakingController.MODE_GROUPS) == "table" then
        for groupName, modes in pairs(matchmakingController.MODE_GROUPS) do
            if groupName ~= "PVP" and groupName ~= "Story" and type(modes) == "table" then
                for _, modeEntry in ipairs(modes) do
                    if type(modeEntry) == "table" then
                        local queueData = type(modeEntry.queue) == "table" and modeEntry.queue or {}
                        local reqData = type(queueData.requirements) == "table" and queueData.requirements
                            or (type(modeEntry.requirements) == "table" and modeEntry.requirements)
                            or {}
                        local isSandbox = (groupName == "Sandbox")
                        local rawTitle = tostring(modeEntry.title or "")
                        local cleanTitle = rawTitle:gsub("%s*II$", ""):gsub("%s+", "")
                        local modeKey = isSandbox and "sandbox" or toLowerCamelCase(cleanTitle)
                        local displayName = isSandbox and "Sandbox" or cleanTitle

                        if modeKey ~= "" and not data.gameModes[modeKey] then
                            local resolvedMinLevel = reqData.minLevel or 0
                            local hasSpecial = reqData.requiresVoidcoreAccess
                                or reqData.levelBypassEntitlement
                                or reqData.requiredEntitlement
                                or reqData.unavailableReason
                                or reqData.specialRequirement
                            local resolvedSpecialRequirement = nil
                            if hasSpecial and matchmakingController
                                and type(matchmakingController.getQueueAvailability) == "function" then
                                local avail = matchmakingController.getQueueAvailability(modeEntry, dummyContext)
                                if avail and avail.locked and avail.lockReason then
                                    resolvedSpecialRequirement = avail.lockReason
                                end
                            end

                            local hasRequiredLevel = playerLevel >= resolvedMinLevel
                            local hasSpecialReq = true
                            if (reqData.requiresVoidcoreAccess or modeKey == "voidcore") and not hasVoidcoreAccess then
                                hasSpecialReq = false
                            end

                            local modeMetadata = findMetadata(modeKey, displayName)
                            local resolvedWaves = modeMetadata and (modeMetadata.Waves or modeMetadata.MaxWaves)
                                or (modeKey == "sandbox" and 50 or nil)
                            local resolvedBoss = modeMetadata and modeMetadata.Boss
                                or (modeKey == "sandbox" and "Custom" or nil)
                            local resolvedEstimatedTime = modeMetadata and modeMetadata.EstimatedTime or nil

                            data.gameModes[modeKey] = {
                                name = displayName,
                                unlocked = hasRequiredLevel and hasSpecialReq,
                                minLevel = resolvedMinLevel,
                                levelsNeeded = math.max(0, resolvedMinLevel - playerLevel),
                                waves = resolvedWaves,
                                boss = resolvedBoss,
                                estimatedTime = resolvedEstimatedTime,
                                specialRequirement = resolvedSpecialRequirement
                            }
                        end
                    end
                end
            end
        end
    end

    if dynamicGameModes then
        for rawModeName, rawModeData in pairs(dynamicGameModes) do
            if type(rawModeData) == "table" then
                local candidateKey = toLowerCamelCase(tostring(rawModeName))
                if candidateKey ~= "" and not data.gameModes[candidateKey] then
                    local displayName = tostring(rawModeName):gsub("%s+", "")
                    local resolvedWaves = rawModeData.Waves or rawModeData.MaxWaves
                    local resolvedBoss = rawModeData.Boss
                    local resolvedEstimatedTime = rawModeData.EstimatedTime
                    data.gameModes[candidateKey] = {
                        name = displayName,
                        unlocked = true,
                        minLevel = 0,
                        levelsNeeded = 0,
                        waves = resolvedWaves,
                        boss = resolvedBoss,
                        estimatedTime = resolvedEstimatedTime,
                        specialRequirement = nil
                    }
                end
            end
        end
    end
end

local function extractQuests(data, preloadedQuests)
    local registeredQuestIds = {}
    local quests = preloadedQuests or filtergc("table", { Keys = {"category", "objectives", "rewards"} }) or {}
    for _, questTable in ipairs(quests) do
        local hasCategory = rawget(questTable, "category") and type(questTable.category) == "string"
        local hasObjectives = rawget(questTable, "objectives") and type(questTable.objectives) == "table"
        if hasCategory and hasObjectives then
            local categoryName = questTable.category:lower()
            local isTargetCategory = (categoryName == "daily" or categoryName == "weekly")
            if isTargetCategory and data.quests[categoryName] and #data.quests[categoryName] < 20 then
                local questIdentifier = tostring(questTable.id or questTable.name or "Unknown")
                if not registeredQuestIds[questIdentifier] then
                    registeredQuestIds[questIdentifier] = true
                    local objectiveDescription = type(questTable.objectives[1]) == "table"
                        and questTable.objectives[1].description
                    local questDescription = questTable.description or objectiveDescription or "No description"
                    table.insert(data.quests[categoryName], {
                        id = questIdentifier,
                        name = tostring(questTable.name or questTable.id or "Unknown"),
                        description = tostring(questDescription),
                        objectiveMode = tostring(questTable.objectiveMode or "SEQUENTIAL"),
                        rewards = parseRewards(questTable.rewards)
                    })
                end
            end
        end
    end
end

local function extractSkillTree(data, preloadedTreeController)
    local skillTreeController = preloadedTreeController
        or filtergc("table", { Keys = {"GetSkillDataForNode", "UpdateNodeState"} }, true)
    if not skillTreeController or not skillTreeController.Trees or not skillTreeController.Trees[1] then
        return skillTreeController
    end

    for _, skillNode in pairs(skillTreeController.Trees[1].Tiles or {}) do
        data.skills.note = nil
        local skillName = skillNode.SkillData and skillNode.SkillData.displayName
        if skillName and skillNode.Atoms and skillNode.Atoms.Level then
            local levelCallSuccess, nodeLevel = pcall(skillNode.Atoms.Level)
            if levelCallSuccess and type(nodeLevel) == "number" and nodeLevel > 0 then
                data.skills.unlockedSkills[skillName] = nodeLevel
            end
        end
    end
    return skillTreeController
end

local function extractEvolutionExperience(data, baseTowers, preloadedExperienceTables)
    if not baseTowers or #baseTowers == 0 then
        return
    end

    local bestMemoryTable = nil
    local maximumAccumulatedExperience = -1

    local experienceTables = preloadedExperienceTables or filtergc("table", { Keys = baseTowers }) or {}
    for _, candidateTable in ipairs(experienceTables) do
        local isValidExperienceTable = false
        local accumulatedTowerExperience = 0
        local hasInvalidExperienceValue = false

        for _, towerName in ipairs(baseTowers) do
            local towerExperienceValue = candidateTable[towerName]
            if towerExperienceValue ~= nil then
                local isNumericExperience = type(towerExperienceValue) == "number"
                local isValidExperienceRange = isNumericExperience
                    and towerExperienceValue >= 0
                    and towerExperienceValue <= 100000
                if isValidExperienceRange then
                    isValidExperienceTable = true
                    accumulatedTowerExperience = accumulatedTowerExperience + towerExperienceValue
                else
                    hasInvalidExperienceValue = true
                    break
                end
            end
        end

        local isBestCandidate = isValidExperienceTable and not hasInvalidExperienceValue
        if isBestCandidate and accumulatedTowerExperience >= maximumAccumulatedExperience then
            bestMemoryTable = candidateTable
            maximumAccumulatedExperience = accumulatedTowerExperience
        end
    end

    for _, progressionEntry in pairs(data.evolvedProgression) do
        local targetBaseTower = progressionEntry.baseTower
        local totalExperience = 0
        if bestMemoryTable and type(bestMemoryTable[targetBaseTower]) == "number" then
            totalExperience = bestMemoryTable[targetBaseTower]
        end

        local calculatedLevel = 0
        local accumulatedExperience = 0
        for currentLevelIndex = 1, progressionEntry.maxLevel do
            local experienceGrowthMultiplier = progressionEntry.growthRate ^ (currentLevelIndex - 1)
            local experienceRequired = math.floor(progressionEntry.baseExp * experienceGrowthMultiplier)
            if totalExperience >= accumulatedExperience + experienceRequired then
                accumulatedExperience = accumulatedExperience + experienceRequired
                calculatedLevel = currentLevelIndex
            else
                break
            end
        end

        progressionEntry.experience = totalExperience
        progressionEntry.level = calculatedLevel
        if not progressionEntry.owned then
            progressionEntry.remainingExp = math.max(0, progressionEntry.requiredExp - totalExperience)
        end
    end
end

local function extractPlaytimeRewards(data, preloadedRewards)
    local playtimeRewardTables = preloadedRewards or filtergc("table", { Keys = {"rewards"} }) or {}
    for _, tableInstance in ipairs(playtimeRewardTables) do
        if type(tableInstance.rewards) == "table" and type(tableInstance.rewards.props) == "table" then
            local rewardText = tableInstance.rewards.props.text
            if type(rewardText) == "string" and rewardText:find("%d+:%d+") then
                data.freePlaytimeRewards.nextRewardTimer = rewardText
                break
            end
        end
    end

    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return
    end

    local topbarGui = playerGui:FindFirstChild("ReactOverridesTopBar")
    if topbarGui then
        for _, descendant in ipairs(topbarGui:GetDescendants()) do
            if descendant:IsA("TextLabel") and descendant.Parent and descendant.Parent.Name == "notification" then
                local claimCount = tonumber(descendant.Text)
                if claimCount and claimCount > 0 then
                    data.freePlaytimeRewards.canClaimAny = true
                    data.freePlaytimeRewards.readyToClaimCount = claimCount
                    break
                end
            end
        end
    end

    local playtimeGui = playerGui:FindFirstChild("ReactLobbyPlaytime")
    if not playtimeGui then
        return
    end

    data.freePlaytimeRewards.note = nil

    local giftItemsFolder = playtimeGui:FindFirstChild("Items", true)
    if giftItemsFolder then
        local claimableGiftsCount = 0
        for _, buttonInstance in ipairs(giftItemsFolder:GetChildren()) do
            if buttonInstance.Name:find("RewardButton") then
                local giftIndex = tonumber(buttonInstance.Name:match("%d+")) or 0
                local claimButton = buttonInstance:FindFirstChild("ClaimButton", true)
                local statusLabel = claimButton and claimButton:FindFirstChildWhichIsA("TextLabel", true)
                local labelText = statusLabel and statusLabel.Text or "Unknown"

                local isGiftClaimable = (labelText:upper() == "CLAIM" or labelText:upper() == "READY")
                local isGiftClaimed = (labelText:upper() == "CLAIMED")
                local timeRemaining = (not isGiftClaimable and not isGiftClaimed) and labelText or nil

                local quantityLabel = buttonInstance:FindFirstChild("QuantityLabel", true)
                local quantityText = quantityLabel and quantityLabel.Text or "x1"

                if isGiftClaimable then
                    claimableGiftsCount = claimableGiftsCount + 1
                end

                table.insert(data.freePlaytimeRewards.gifts, {
                    index = giftIndex,
                    canClaim = isGiftClaimable,
                    claimed = isGiftClaimed,
                    timeRemaining = timeRemaining,
                    quantity = quantityText
                })
            end
        end
        data.freePlaytimeRewards.readyToClaimCount = claimableGiftsCount
        data.freePlaytimeRewards.canClaimAny = (claimableGiftsCount > 0)
        table.sort(data.freePlaytimeRewards.gifts, function(firstItem, secondItem)
            return firstItem.index < secondItem.index
        end)
        if not data.freePlaytimeRewards.nextRewardTimer then
            for _, giftItem in ipairs(data.freePlaytimeRewards.gifts) do
                if giftItem.timeRemaining then
                    data.freePlaytimeRewards.nextRewardTimer = giftItem.timeRemaining
                    break
                end
            end
        end
    end

    local additionalRewards = playtimeGui:FindFirstChild("AdditionalRewards", true)
    if not additionalRewards then
        return
    end

    local timerLabel = additionalRewards:FindFirstChild("Timer", true)
    if timerLabel and timerLabel:IsA("TextLabel") then
        data.freePlaytimeRewards.giftAds.resetTimer = timerLabel.Text
    end

    local videoHolder = additionalRewards:FindFirstChild("videoHolder", true)
    if not videoHolder then
        return
    end

    for _, videoButton in ipairs(videoHolder:GetChildren()) do
        if videoButton.Name:find("VideoButton") then
            local offerIndex = tonumber(videoButton.Name:match("%d+")) or 0
            local claimLabel = videoButton:FindFirstChild("TextLabel", true)
            local statusText = claimLabel and claimLabel.Text or "LOCKED"
            local isAdClaimable = (statusText:upper() == "CLAIM" or statusText:upper() == "READY")
            local isAdClaimed = (statusText:upper() == "CLAIMED")

            if isAdClaimable then
                data.freePlaytimeRewards.giftAds.canClaimAny = true
                local readyAdsCount = data.freePlaytimeRewards.giftAds.readyToClaimCount
                data.freePlaytimeRewards.giftAds.readyToClaimCount = readyAdsCount + 1
            end

            table.insert(data.freePlaytimeRewards.giftAds.offers, {
                offer = offerIndex,
                canClaim = isAdClaimable,
                claimed = isAdClaimed,
                status = statusText
            })
        end
    end
    table.sort(data.freePlaytimeRewards.giftAds.offers, function(firstOffer, secondOffer)
        return firstOffer.offer < secondOffer.offer
    end)
end

local function extractTowerPurchases(data, passedTowerTable)
    local towerTable = passedTowerTable
    if not towerTable then
        for _, candidate in ipairs(filtergc("table", { Keys = {"Scout", "Minigunner", "Commander"} }) or {}) do
            if type(candidate.Minigunner) == "table" and type(candidate.Commander) == "table" then
                towerTable = candidate
                break
            end
        end
    end

    if not towerTable then
        return
    end

    local playerCoins = data.currencies.coins or 0
    local playerGems = data.currencies.gems or 0
    local playerLevel = data.progression.level or 0

    for towerName, towerEntry in pairs(towerTable) do
        if type(towerEntry) == "table" and towerEntry.Properties and towerEntry.Properties.Price then
            local properties = towerEntry.Properties
            local isEvolvedTower = properties.EvolvedTo == nil and towerName:find("^Evolved") ~= nil
            local towerPriceData = properties.Price
            local priceType = tostring(towerPriceData.Type or "None")
            local towerPriceValue = tonumber(towerPriceData.Value) or 0

            local hasConfiguredPrice = (priceType == "2" or priceType == "3") and towerPriceValue > 0
            local hasPreviewText = towerPriceData.PreviewText ~= nil and towerPriceData.PreviewText ~= ""
            local isLevelReward = (priceType == "1") and hasPreviewText

            if not isEvolvedTower and towerPriceValue < 1000000 and (hasConfiguredPrice or isLevelReward) then
                local currencyName = "Coins"
                if priceType == "3" then
                    currencyName = "Gems"
                elseif priceType == "1" then
                    currencyName = "Free"
                end

                local previewText = towerPriceData.PreviewText or ""
                local mapLocked = towerPriceData.MapLocked or ""
                local fallbackRequirement = (mapLocked ~= "" and mapLocked) or nil
                local specialRequirementText = (previewText ~= "" and previewText) or fallbackRequirement
                local minimumLevel = 0
                if previewText ~= "" then
                    local levelMatch = previewText:match("LEVEL%s+(%d+)")
                    if levelMatch then
                        minimumLevel = tonumber(levelMatch)
                    end
                end

                local isEngineEligible = true
                if type(towerPriceData.IsEligible) == "table" and towerPriceData.IsEligible.get then
                    local eligibleCallSuccess, isEligible = pcall(towerPriceData.IsEligible.get)
                    if eligibleCallSuccess and type(isEligible) == "boolean" then
                        isEngineEligible = isEligible
                    end
                elseif type(towerPriceData.IsEligible) == "function" then
                    local eligibleCallSuccess, isEligible = pcall(towerPriceData.IsEligible)
                    if eligibleCallSuccess and type(isEligible) == "boolean" then
                        isEngineEligible = isEligible
                    end
                end

                local isTowerOwned = data.ownedTowers[towerName] ~= nil
                local hasRequiredLevel = (playerLevel >= minimumLevel) and isEngineEligible
                local levelsRequired = math.max(0, minimumLevel - playerLevel)
                local hasRequiredCurrency = false
                local currencyRequired = 0

                if currencyName == "Coins" then
                    hasRequiredCurrency = playerCoins >= towerPriceValue
                    currencyRequired = math.max(0, towerPriceValue - playerCoins)
                elseif currencyName == "Gems" then
                    hasRequiredCurrency = playerGems >= towerPriceValue
                    currencyRequired = math.max(0, towerPriceValue - playerGems)
                elseif currencyName == "Free" then
                    hasRequiredCurrency = true
                    currencyRequired = 0
                end

                local canPurchase = (not isTowerOwned) and hasRequiredLevel and hasRequiredCurrency
                local identifierKey = toLowerCamelCase(towerName:gsub("%s+", ""))

                data.towerPurchases[identifierKey] = {
                    name = towerName,
                    owned = isTowerOwned,
                    canPurchase = canPurchase,
                    price = towerPriceValue,
                    currency = currencyName,
                    minLevel = minimumLevel,
                    levelsNeeded = levelsRequired,
                    currencyNeeded = currencyRequired,
                    specialRequirement = specialRequirementText
                }
            end
        end
    end
end

local function extractLogbook(data)
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    local logbookInterface = playerGui and playerGui:FindFirstChild("ReactLobbyLogBook")
    if not logbookInterface then
        return
    end

    data.logbook.note = nil

    local countLabel = logbookInterface:FindFirstChild("count", true)
    if countLabel and countLabel:IsA("TextLabel") then
        local foundCount, totalCount = countLabel.Text:match("(%d+)%s*[/]%s*(%d+)")
        if foundCount and totalCount then
            data.logbook.enemiesFound = tonumber(foundCount) or 0
            data.logbook.enemiesTotal = tonumber(totalCount) or 179
        end
    end

    for _, descendant in ipairs(logbookInterface:GetDescendants()) do
        if descendant.Name:find("^LogBookItem:Enemies:") then
            local isEnemyLocked = descendant:FindFirstChild("locked", true) ~= nil
            local enemyName = descendant.Name:gsub("^LogBookItem:Enemies:", "")
            if not isEnemyLocked and not table.find(data.logbook.unlockedEnemies, enemyName) then
                table.insert(data.logbook.unlockedEnemies, enemyName)
            end
        end
    end
    table.sort(data.logbook.unlockedEnemies)
end

local function extractAchievements(data)
    local achievementContentFolder = findChildPath(ReplicatedStorage, "Content", "Achievement")
    if not achievementContentFolder then
        return
    end

    for _, categoryFolder in ipairs(achievementContentFolder:GetChildren()) do
        if categoryFolder:IsA("Folder") then
            local categoryName = categoryFolder.Name
            data.achievements[categoryName] = {}

            for _, achievementModule in ipairs(categoryFolder:GetChildren()) do
                if achievementModule:IsA("ModuleScript") then
                    local requireSuccess, achievementData = pcall(require, achievementModule)
                    if requireSuccess and type(achievementData) == "table" then
                        local identifierKey = toLowerCamelCase(achievementModule.Name:gsub("%s+", ""))

                        local rewardsList = {}
                        for _, rawReward in ipairs(achievementData.rewards or {}) do
                            table.insert(rewardsList, {
                                type = rawReward.type or rawReward.stat or "item",
                                amount = rawReward.amount or 1,
                                name = rawReward.name or rawReward.skin or rawReward.crate or rawReward.stat
                            })
                        end

                        data.achievements[categoryName][identifierKey] = {
                            id = achievementModule.Name,
                            title = achievementData.title or achievementModule.Name,
                            description = achievementData.description or "",
                            hidden = achievementData.hidden == true,
                            flair = achievementData.flair,
                            lockedBehind = achievementData.lockedBehind,
                            objective = achievementData.objective,
                            rewards = rewardsList
                        }
                    end
                end
            end
        end
    end
end

local function extractLoginRewards(data, preloadedStores)
    local storeInstances = preloadedStores or filtergc("table", { Keys = {"getState"} }) or {}
    for _, storeInstance in ipairs(storeInstances) do
        local stateCallSuccess, loginState = pcall(storeInstance.getState, storeInstance)
        if stateCallSuccess and type(loginState) == "table" and loginState.claimed ~= nil and loginState.day ~= nil then
            data.dailyLogin.currentDay = tonumber(loginState.day) or data.dailyLogin.currentDay
            data.dailyLogin.claimedDay = tonumber(loginState.claimed) or data.dailyLogin.claimedDay
            data.dailyLogin.canClaimDaily = (data.dailyLogin.currentDay > data.dailyLogin.claimedDay)
            break
        end
    end

    local sharedDailyRewards = filtergc("table", { Keys = {"DailyRewards"} }, true)
        or filtergc("table", { Keys = {"GetDailyRewards"} }, true)
    local dailyRewardsSchedule = nil
    if sharedDailyRewards and type(sharedDailyRewards) == "table" then
        if type(sharedDailyRewards.GetDailyRewards) == "function" then
            local rewardsCallSuccess, dailyRewardsList = pcall(sharedDailyRewards.GetDailyRewards)
            if rewardsCallSuccess and type(dailyRewardsList) == "table" then
                dailyRewardsSchedule = dailyRewardsList
            end
        end
        if not dailyRewardsSchedule and type(sharedDailyRewards.DailyRewards) == "table" then
            dailyRewardsSchedule = sharedDailyRewards.DailyRewards
        end
    end

    if dailyRewardsSchedule then
        for dayIndex, rewardEntry in ipairs(dailyRewardsSchedule) do
            local itemType = rewardEntry.type or "Currency"
            local rewardPayload = rewardEntry.value or {}
            local rewardName = rewardPayload[1] or "Unknown"
            local rewardAmount = tonumber(rewardPayload[2]) or 1

            table.insert(data.dailyLogin.schedule, {
                day = dayIndex,
                type = itemType,
                name = rewardName,
                amount = rewardAmount,
                claimed = (dayIndex <= data.dailyLogin.claimedDay),
                canClaim = (dayIndex == data.dailyLogin.currentDay and data.dailyLogin.canClaimDaily)
            })
        end
    end
end

local function extractLeaderboards(data, preloadedLeaderboard)
    local leaderboardData = preloadedLeaderboard
    if not leaderboardData then
        for _, tableCandidate in ipairs(filtergc("table", { Keys = {"Triumphs", "Experience"} }) or {}) do
            local hasTriumphs = type(tableCandidate.Triumphs) == "table" and #tableCandidate.Triumphs > 0
            local hasExperience = type(tableCandidate.Experience) == "table"
            if hasTriumphs and hasExperience then
                leaderboardData = tableCandidate
                break
            end
        end
    end

    if not leaderboardData then
        return
    end

    local playerUserId = tostring(localPlayer.UserId)
    local playerTriumphs = data.progression.triumphs or 0
    local playerExperience = data.progression.experience or 0

    local function populateLeaderboard(boardList, targetEntry, currentScore)
        if type(boardList) ~= "table" or #boardList == 0 then
            return
        end
        local minimumToEnter = tonumber(boardList[#boardList].sortKey) or 0
        targetEntry.minimumToEnter = minimumToEnter
        targetEntry.currentScore = currentScore
        targetEntry.difference = math.max(0, minimumToEnter - currentScore)

        for rankIndex, entry in ipairs(boardList) do
            if tostring(entry.key) == playerUserId then
                targetEntry.onLeaderboard = true
                targetEntry.rank = rankIndex
                targetEntry.currentScore = tonumber(entry.sortKey) or currentScore
                targetEntry.difference = 0
                break
            end
        end
    end

    populateLeaderboard(leaderboardData.Triumphs, data.leaderboards.monthlyTriumphs, playerTriumphs)
    populateLeaderboard(leaderboardData.Experience, data.leaderboards.monthlyExperience, playerExperience)
end

local function extractMaxAccount(data, providedTreeController)
    local missingTowerNames = {}

    for _, towerData in pairs(data.towerPurchases) do
        if (towerData.currency == "Coins" or towerData.currency == "Gems") and not towerData.specialRequirement then
            local isTowerOwned = towerData.owned or (data.ownedTowers[towerData.name] ~= nil)
            if not isTowerOwned then
                table.insert(missingTowerNames, towerData.name)
            end
        end
    end
    table.sort(missingTowerNames)

    data.maxAccount.missingTowers = missingTowerNames
    data.maxAccount.allTowersOwned = (#missingTowerNames == 0)

    local skillTreeController = providedTreeController
    if not skillTreeController then
        skillTreeController = filtergc("table", { Keys = {"GetSkillDataForNode", "UpdateNodeState"} }, true)
    end
    if skillTreeController and skillTreeController.Trees and skillTreeController.Trees[1] then
        local totalNodesCount = 0
        local maxedNodesCount = 0

        for _, skillNode in pairs(skillTreeController.Trees[1].Tiles or {}) do
            totalNodesCount = totalNodesCount + 1
            local maxLevel = skillNode.SkillData and skillNode.SkillData.maxLevel or 1
            local currentLevel = 0
            if skillNode.Atoms and skillNode.Atoms.Level then
                local levelCallSuccess, nodeLevel = pcall(skillNode.Atoms.Level)
                if levelCallSuccess and type(nodeLevel) == "number" then
                    currentLevel = nodeLevel
                end
            end
            if currentLevel >= maxLevel then
                maxedNodesCount = maxedNodesCount + 1
            end
        end

        data.maxAccount.maxSkillTree = (totalNodesCount > 0 and maxedNodesCount == totalNodesCount)
    end

    data.maxAccount.isMaxed = (data.maxAccount.allTowersOwned and data.maxAccount.maxSkillTree)
end

local function getStats(targetCategory)
    local data = createDataStructure()

    local requestedFilter = nil
    if type(targetCategory) == "string" then
        requestedFilter = { [targetCategory:lower()] = true }
    elseif type(targetCategory) == "table" then
        requestedFilter = {}
        for _, categoryName in ipairs(targetCategory) do
            if type(categoryName) == "string" then
                requestedFilter[categoryName:lower()] = true
            end
        end
    end

    local function isCategoryRequested(categoryName)
        if not requestedFilter then
            return true
        end
        return requestedFilter[categoryName:lower()] == true
    end

    local storeDependentCategories = {
        "currencies",
        "progression",
        "inventory",
        "ownedTowers",
        "totalTowersOwned",
        "goldenTowersOwned",
        "evolvedTowersOwned",
        "spinWheel",
        "pvpAndMatch",
        "maxAccount",
        "skills",
        "quests",
        "towerPurchases",
        "dailyLogin",
        "trials",
        "gameModes",
        "evolvedProgression",
        "challenge",
        "leaderboards",
        "membership",
        "loadout",
        "towers",
        "evolution"
    }

    local includeStore = false
    for _, categoryName in ipairs(storeDependentCategories) do
        if isCategoryRequested(categoryName) then
            includeStore = true
            break
        end
    end

    local includeEvolution = isCategoryRequested("evolvedProgression")
        or isCategoryRequested("evolution")
        or isCategoryRequested("towers")
    local includeTrials = isCategoryRequested("trials") or isCategoryRequested("gameModes")
    local includeGameModes = isCategoryRequested("gameModes")
    local includeQuests = isCategoryRequested("quests")
    local includeSkills = isCategoryRequested("skills") or isCategoryRequested("maxAccount")
    local includePlaytime = isCategoryRequested("freePlaytimeRewards")
    local includeLoginRewards = isCategoryRequested("dailyLogin") or isCategoryRequested("freeLoginRewards")
    local includePurchases = isCategoryRequested("towerPurchases")
        or isCategoryRequested("towers")
        or isCategoryRequested("maxAccount")
    local includeLogbook = isCategoryRequested("logbook")
    local includeAchievements = isCategoryRequested("achievements")
    local includeLeaderboards = isCategoryRequested("leaderboards")
    local includeMaxAccount = isCategoryRequested("maxAccount")

    local memoryTables = nil
    if requestedFilter then
        memoryTables = collectMemoryTables({
            includeStore = includeStore,
            includeEvolution = includeEvolution,
            includeTrials = includeTrials,
            includeGameModes = includeGameModes,
            includeQuests = includeQuests,
            includeSkills = includeSkills,
            includePlaytime = includePlaytime,
            includePurchases = includePurchases,
            includeLeaderboards = includeLeaderboards
        })
    else
        memoryTables = collectMemoryTables()
    end

    local baseTowers = {}
    if includeEvolution or includePurchases then
        baseTowers = extractEvolutionMetadata(data, memoryTables.towerTable)
    end

    local hasVoidcoreAccess = extractReplicatedState(data, memoryTables.trialDefinitions)

    if includeStore then
        extractGameStateStore(data, memoryTables.storeInstances)
    end
    if includeGameModes then
        extractGameModes(
            data,
            hasVoidcoreAccess,
            memoryTables.dynamicGameModes,
            memoryTables.matchmakingController
        )
    end
    if includeQuests then
        extractQuests(data, memoryTables.questTables)
    end

    local skillTreeController = nil
    if includeSkills then
        skillTreeController = extractSkillTree(data, memoryTables.treeController)
    end
    if includeEvolution then
        extractEvolutionExperience(data, baseTowers, memoryTables.candidateExperienceTables)
    end
    if includePlaytime then
        extractPlaytimeRewards(data, memoryTables.playtimeRewardTables)
    end
    if includeLoginRewards then
        extractLoginRewards(data, memoryTables.storeInstances)
    end
    if includePurchases then
        extractTowerPurchases(data, memoryTables.towerTable)
    end
    if includeLogbook then
        extractLogbook(data)
    end
    if includeAchievements then
        extractAchievements(data)
    end
    if includeLeaderboards then
        extractLeaderboards(data, memoryTables.leaderboardTable)
    end
    if includeMaxAccount then
        extractMaxAccount(data, skillTreeController)
    end

    if type(targetCategory) == "string" then
        if data[targetCategory] ~= nil then
            return data[targetCategory]
        end
        local normalizedTargetCategory = targetCategory:lower()
        if normalizedTargetCategory == "challenge" then
            return data.challenge
        end
        for categoryKey, categoryData in pairs(data) do
            if categoryKey:lower() == normalizedTargetCategory then
                return categoryData
            end
        end
    end

    return data
end

local statsProxy = {}

statsProxy.getStats = getStats

setmetatable(statsProxy, {
    __index = function(_, categoryName)
        if categoryName == "getStats" then
            return getStats
        end
        return getStats(categoryName)
    end,
    __call = function(_, targetCategory)
        if not targetCategory then
            return getStats()
        end
        return getStats(targetCategory)
    end
})

return statsProxy
