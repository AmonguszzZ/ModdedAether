local Players = game:GetService("Players")
local ReplicatedStorage = ReplicatedStorage or game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/NewFunc/PlayerDataHandler.lua"))()
end)

if not success then
    warn("Failed to load scripts: " .. tostring(result))
end

local PlayerDataChecker = success and result or {
    getStats = function()
        return {
            progression = { level = 0 },
            ownedTowers = {},
            evolvedProgression = {},
            towers = {},
            goldenTowersOwned = {},
            skills = { unlockedSkills = {} }
        }
    end
}

if not success then
    warn("[AutoTrials] Failed to load DataChecker.lua: " .. tostring(result))
    warn("[AutoTrials] Using fallback data — requirement checks may be inaccurate.")
end

local TRIAL_PLACE_ID = 3260590327
local CONFIG_FOLDER = "GlobalConfigs"
local TRIAL_STATE_FILE = CONFIG_FOLDER .. "/trialscript.txt"

local trialScripts = {
    ["Speedy Enemies"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Speedy.lua",
    ["Glass"]                 = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Glass.lua",
    ["Quarantine"]            = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Quarantine.lua",
    ["Fog"]                   = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Fog.lua",
    ["Limitation"]            = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Limitation.lua",
    ["Flying"]                = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Flying.lua",
    ["Jailed"]                = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Jailed.lua",
    ["Exploding Enemies"]     = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Exploading.lua",
    ["Inflation"]             = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Inflation.lua", -- no skill tree, no gold, no hardcore towers
    ["Committed"]             = "String",
    ["Hidden Enemies"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Hidden.lua",
    ["Hidden"]                = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Hidden.lua",
    ["Broke"]                 = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/StratsFunc/Broke.lua", -- no skill tree, no gold, no hardcore towers
    ["Healthy Enemies"]       = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Healthy.lua" -- no gold, no hardcore towers
}

local trialConfigs = {
    ["Speedy Enemies"] = { 
        Level = 175, 
        Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Trapper"},
        Golden = {},
        SkillTree = {} 
    },
    ["Glass"] = { 
        Level = 175, 
        Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Trapper"},
        Golden = {},
        SkillTree = {} 
    },
    ["Quarantine"] = { 
        Level = 175, 
        Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth"},
        Golden = {},
        SkillTree = {} 
    },
    ["Fog"] = { 
        Level = 175, 
        Towers = {"Trapper", "Hacker", "Gatling Gun", "Mercenary Base", "DJ Booth"},
        Golden = {},
        SkillTree = {} 
    },
    ["Limitation"] = { 
        Level = 175, 
        Towers = {"Trapper", "Hacker", "Gatling Gun", "Mercenary Base", "DJ Booth"},
        Golden = {},
        SkillTree = {} 
    },
    ["Flying"] = { 
        Level = 175, 
        Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth"},
        Golden = {},
        SkillTree = {} 
    },
    ["Jailed"] = { 
        Level = 175, 
        Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Military Base"},
        Golden = {},
        SkillTree = {} 
    },
    ["Exploding Enemies"] = { 
        Level = 175, 
        Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth"},
        Golden = {},
        SkillTree = {} 
    },
    ["Inflation"] = { 
        Level = 175, 
        Towers = {"Ace Pilot", "Trapper", "Gatling Gun", "DJ Booth", "Medic"}, -- Done
        Golden = {},
        SkillTree = {} 
    },
    ["Committed"] = { 
        Level = 175, 
        Towers = {"Placeholder"},
        Golden = {},
        SkillTree = {} 
    },
    ["Hidden"] = { 
        Level = 175, 
        Towers = {"Gatling Gun", "Hacker", "Mercenary Base", "Trapper", "DJ Booth"},
        Golden = {},
        SkillTree = {} 
    },
    ["Broke"] = { 
        Level = 175, 
        Towers = {"Gatling Gun", "Militant", "Medic", "Trapper", "DJ Booth"},
        Golden = {},
        SkillTree = {} 
    },
    ["Healthy Enemies"] = { 
        Level = 175, 
        Towers = {"Ace Pilot", "Mercenary Base", "DJ Booth", "Gatling Gun", "Medic"}, -- Done
        Golden = {},
        SkillTree = {
		["Bigger Budget"] = 10,
        ["Fortify"] = 10,
        ["Stonks"] = 10,
		["Over-Heal"] = 10,
		["Bandages"] = 10,
		["Accelerator"] = 10,
		["Enhanced Optics"] = 10,
		["Resourcefulness"] = 10,
		} 
    }
}

local function normalizeString(str)
    if not str then return "" end
    return string.lower(string.gsub(str, "%s+", ""))
end

local function getCurrentTrialName()
    local stateReplicators = ReplicatedStorage:FindFirstChild("StateReplicators")
    local trialsReplicator = stateReplicators and stateReplicators:FindFirstChild("TrialsStateReplicator")
    if trialsReplicator then
        return trialsReplicator:GetAttribute("GlobalTrial")
    end
    return nil
end

local function verifyTrialRequirements(trialName)
    local normalizedTarget = normalizeString(trialName)
    local matchedKey = nil

    for configName, _ in pairs(trialConfigs) do
        if normalizeString(configName) == normalizedTarget then
            matchedKey = configName
            break
        end
    end

    if not matchedKey then
        return true, {}
    end

    local config = trialConfigs[matchedKey]
    local stats = PlayerDataChecker.getStats()
    local playerLevel = stats.progression.level
    local missingRequirements = {}

    -- Check if script URL is a placeholder
    local scriptUrl = trialScripts[matchedKey]
    if not scriptUrl or string.lower(tostring(scriptUrl)) == "placeholder" then
        table.insert(missingRequirements, "Script configuration is a Placeholder")
    end

    if playerLevel < config.Level then
        table.insert(missingRequirements, string.format("Level (Required: %d, Current: %d)", config.Level, playerLevel))
    end

    if config.Towers then
        for _, towerName in ipairs(config.Towers) do
            local isOwned = false
            
            if string.lower(tostring(towerName)) == "placeholder" then
                table.insert(missingRequirements, "Tower configuration contains a Placeholder")
            else
                if stats.ownedTowers then
                    if stats.ownedTowers[towerName] == true then
                        isOwned = true
                    elseif type(stats.ownedTowers[towerName]) == "table" then
                        isOwned = true
                    elseif table.find(stats.ownedTowers, towerName) then
                        isOwned = true
                    end
                end

                if not isOwned and stats.evolvedProgression then
                    if stats.evolvedProgression[towerName] and stats.evolvedProgression[towerName].owned then
                        isOwned = true
                    end
                end

                if not isOwned and stats.towers then
                    if stats.towers[towerName] or table.find(stats.towers, towerName) then
                        isOwned = true
                    end
                end

                if not isOwned then
                    table.insert(missingRequirements, towerName)
                end
            end
        end
    end

    if config.Golden then
        for _, goldenName in ipairs(config.Golden) do
            local isGoldenOwned = false
            if stats.ownedTowers and stats.ownedTowers[goldenName] and (stats.ownedTowers[goldenName].golden == true or stats.ownedTowers[goldenName].IsGolden == true) then
                isGoldenOwned = true
            elseif stats.goldenTowersOwned and table.find(stats.goldenTowersOwned, goldenName) ~= nil then
                isGoldenOwned = true
            end
            if not isGoldenOwned then
                table.insert(missingRequirements, "Golden " .. goldenName)
            end
        end
    end

    if config.SkillTree then
        for skillName, requiredLevel in pairs(config.SkillTree) do
            local currentSkillLevel = 0
            if stats.skills and stats.skills.unlockedSkills then
                currentSkillLevel = stats.skills.unlockedSkills[skillName] or 0
            end
            if currentSkillLevel < requiredLevel then
                table.insert(missingRequirements, string.format("Skill Tree: %s (Required Level: %d, Current: %d)", skillName, requiredLevel, currentSkillLevel))
            end
        end
    end

    return #missingRequirements == 0, missingRequirements
end

local function executeTrialScript(matchedTrialName)
    local targetKey = nil
    local normalizedTarget = normalizeString(matchedTrialName)

    for configName, _ in pairs(trialScripts) do
        if normalizeString(configName) == normalizedTarget then
            targetKey = configName
            break
        end
    end

    if not targetKey or not trialScripts[targetKey] or string.lower(tostring(trialScripts[targetKey])) == "placeholder" then
        error(string.format("[AutoTrials] Trial '%s' contains a Placeholder script URL and cannot be executed.", tostring(matchedTrialName)))
    end

    local scriptUrl = trialScripts[targetKey]
    local maxRetries = 3
    local success, err

    for attempt = 1, maxRetries do
        print(string.format("[AutoTrials] Loading execution script for '%s' (Attempt %d/%d) from: %s", targetKey, attempt, maxRetries, scriptUrl))
        success, err = pcall(function()
            local chunk = game:HttpGet(scriptUrl)
            local fn = loadstring(chunk)
            if fn then
                fn()
            else
                error("Failed to compile loadstring chunk")
            end
        end)

        if success then
            print(string.format("[AutoTrials] Successfully executed script for '%s'!", targetKey))
            return true
        else
            warn(string.format("[AutoTrials] Error executing script for '%s' on attempt %d/%d: %s", targetKey, attempt, maxRetries, tostring(err)))
            if attempt < maxRetries then
                task.wait(1)
            end
        end
    end
    return false
end

local function ensureConfigFolder()
    if makefolder and not isfolder(CONFIG_FOLDER) then
        pcall(makefolder, CONFIG_FOLDER)
    end
end

local function saveTrialState(trialName)
    ensureConfigFolder()
    if writefile then
        pcall(writefile, TRIAL_STATE_FILE, trialName)
    end
end

local function readTrialState()
    if isfile and isfile(TRIAL_STATE_FILE) then
        local success, content = pcall(readfile, TRIAL_STATE_FILE)
        if success and content then
            content = content:gsub("^%s*(.-)%s*$", "%1")
            if content ~= "" then
                return content
            end
        end
    end
    return nil
end

local AutoTrials = {}

function AutoTrials.GetInfo()
    local currentTrial = getCurrentTrialName()
    if not currentTrial then
        return "No Active Trial", "None required", true, {}
    end

    local normalizedCurrent = normalizeString(currentTrial)
    local matchedKey = nil
    for configName, _ in pairs(trialConfigs) do
        if normalizeString(configName) == normalizedCurrent then
            matchedKey = configName
            break
        end
    end

    if not matchedKey or not trialConfigs[matchedKey] then
        return currentTrial, "No configuration found", true, {}
    end

    local config = trialConfigs[matchedKey]
    local towersList = {}
    if config.Towers then
        for _, t in ipairs(config.Towers) do table.insert(towersList, t) end
    end
    if config.Golden then
        for _, g in ipairs(config.Golden) do table.insert(towersList, "Golden " .. g) end
    end

    local desc = (#towersList > 0) and table.concat(towersList, ", ") or "None"
    local isPassed, missing = verifyTrialRequirements(matchedKey)
    return matchedKey, desc, isPassed, missing
end

function AutoTrials.Run()
    if game.PlaceId == TRIAL_PLACE_ID then
        print("[AutoTrials] In lobby. Evaluating active trial requirements...")
        
        local currentTrial = getCurrentTrialName()
        if not currentTrial then
            print("[AutoTrials] No active GlobalTrial found.")
            error("No active GlobalTrial found.")
        end

        local normalizedCurrent = normalizeString(currentTrial)
        local matchedOriginalName = nil

        for configName, _ in pairs(trialConfigs) do
            if normalizeString(configName) == normalizedCurrent then
                matchedOriginalName = configName
                break
            end
        end

        if not matchedOriginalName then
            local errStr = string.format("Trial '%s' has no configuration mapped.", tostring(currentTrial))
            print("[AutoTrials] Restricted: " .. errStr)
            error(errStr)
        end

        local isPassed, missing = verifyTrialRequirements(matchedOriginalName)
        if not isPassed then
            print(string.format("[AutoTrials] Failed to run trial '%s' - Missing requirements:", matchedOriginalName))
            for _, req in ipairs(missing) do
                print(" - " .. req)
            end
            local missingText = table.concat(missing, ", ")
            error("Missing requirements: " .. missingText)
        end

        print(string.format("[AutoTrials] Success: All requirements verified for '%s'. Saving state and starting queue...", matchedOriginalName))
        saveTrialState(matchedOriginalName)

        local remoteFunction = ReplicatedStorage:FindFirstChild("RemoteFunction")
        if remoteFunction and remoteFunction:IsA("RemoteFunction") then
            remoteFunction:InvokeServer(
                "Multiplayer",
                "v2:start",
                {
                    count = 1,
                    mode = "Trials"
                }
            )
        end
        return
    end

    print(string.format("[AutoTrials] Inside trial place (%d). Reading %s...", game.PlaceId, TRIAL_STATE_FILE))
    local savedTrial = readTrialState()
    if savedTrial then
        print(string.format("[AutoTrials] Found saved trial state: '%s'. Executing corresponding script...", savedTrial))
        local success = executeTrialScript(savedTrial)
        if not success then
            error("Failed to execute saved trial script")
        end
    else
        warn("[AutoTrials] No trial state found in trialscript.txt to execute!")
        error("No trial state found in trialscript.txt")
    end
end

return AutoTrials
