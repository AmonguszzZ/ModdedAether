local replicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local TRIAL_PLACE_ID = 3260590327
local CONFIG_FOLDER = "GlobalConfigs"
local TRIAL_STATE_FILE = CONFIG_FOLDER .. "/trialscript.txt"
local SAVED_OWNED_FILE = CONFIG_FOLDER .. "/trialsavedowned.txt"

local trialScripts = {
    ["Speedy Enemies"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Speedy.lua",
    ["Glass"]                 = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Glass.lua",
    ["Quarantine"]            = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Quarantine.lua",
    ["Fog"]                   = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Fog.lua",
    ["Limitation"]            = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Limitation.lua",
    ["Flying Enemies"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Flying.lua",
    ["Jailed Towers"]         = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Jailed.lua",
    ["Exploding Enemies"]     = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Exploading.lua",
    ["Inflation"]             = "Placeholder",
    ["Committed"]             = "Placeholder",
    ["Hidden Enemies"]        = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Hidden.lua",
    ["Broke"]                 = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Brokes.lua",
    ["Healthy Enemies"]       = "Placeholder"
}

local function getTrialModule()
    local url = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/main/Func/GetTrials.lua"
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if success and result and type(result) == "table" then
        return result
    else
        warn("[AutoTrials] Failed to load trial module via loadstring.")
        return nil
    end
end

local function getAvailableTrials()
    local module = getTrialModule()
    if module and type(module.GetTrials) == "function" then
        return module.GetTrials()
    end
    return {}
end

local function GetMissingTower()
    local module = getTrialModule()
    if module and type(module.GetMissingTower) == "function" then
        return module.GetMissingTower()
    end
    return {}
end

local function normalizeString(str)
    if not str then return "" end
    return string.lower(string.gsub(str, "%s+", ""))
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
        print(string.format("[AutoTrials] Saved active trial '%s' to %s", trialName, TRIAL_STATE_FILE))
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

local function isTrialAlreadyCompleted(trialName)
    ensureConfigFolder()
    local normalizedTrialKey = normalizeString(trialName)

    if isfile and isfile(SAVED_OWNED_FILE) then
        local success, content = pcall(readfile, SAVED_OWNED_FILE)
        if success and content then
            for line in content:gmatch("[^\r\n]+") do
                if normalizeString(line) == normalizedTrialKey then
                    return true
                end
            end
        end
    end

    local stateReplicators = replicatedStorage:FindFirstChild("StateReplicators")
    local modifierReplicator = stateReplicators and stateReplicators:FindFirstChild("ModifierReplicator")
    
    if modifierReplicator then
        local availableAttr = modifierReplicator:GetAttribute("Available")
        if type(availableAttr) == "string" then
            local success, parsedJson = pcall(function()
                return HttpService:JSONDecode(availableAttr)
            end)

            if success and type(parsedJson) == "table" then
                for key, val in pairs(parsedJson) do
                    if normalizeString(key) == normalizedTrialKey then
                        if val == true then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

local function saveCompletedTrial(trialName)
    ensureConfigFolder()
    if writefile and isfile and isfile(SAVED_OWNED_FILE) then
        local success, content = pcall(readfile, SAVED_OWNED_FILE)
        local alreadyExists = false
        if success and content then
            for line in content:gmatch("[^\r\n]+") do
                if normalizeString(line) == normalizeString(trialName) then
                    alreadyExists = true
                    break
                end
            end
        end
        if not alreadyExists then
            local newContent = (content and content ~= "") and (content .. "\n" .. trialName) or trialName
            pcall(writefile, SAVED_OWNED_FILE, newContent)
        end
    elseif writefile then
        pcall(writefile, SAVED_OWNED_FILE, trialName)
    end
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

    if not targetKey or not trialScripts[targetKey] then
        warn(string.format("[AutoTrials] No loadstring URL mapped for trial: '%s'", tostring(matchedTrialName)))
        return false
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
                print(string.format("[AutoTrials] Retrying in 1 second..."))
                task.wait(1)
            end
        end
    end

    warn(string.format("[AutoTrials] Failed to execute script for '%s' after %d attempts.", targetKey, maxRetries))
    return false
end

local function RunAutoTrial()
    if game.PlaceId == TRIAL_PLACE_ID then
        print("[AutoTrials] In lobby. Evaluating available trials...")
        
        local stateReplicators = replicatedStorage:FindFirstChild("StateReplicators")
        local trialsReplicator = stateReplicators and stateReplicators:FindFirstChild("TrialsStateReplicator")

        if not trialsReplicator then
            print("[AutoTrials] TrialsStateReplicator not found.")
            return false
        end

        local currentTrial = trialsReplicator:GetAttribute("GlobalTrial")
        if not currentTrial then
            print("[AutoTrials] No active GlobalTrial found.")
            return false
        end

        print(string.format("[AutoTrials] Current active trial (Replicator): %s", tostring(currentTrial)))

        if isTrialAlreadyCompleted(currentTrial) then
            print(string.format("[AutoTrials] Already owned/completed: '%s'. Skipping trial and queue start.", tostring(currentTrial)))
            saveCompletedTrial(currentTrial)
            return false
        end

        local availableTrials = getAvailableTrials()
        local canPlay = false
        local normalizedCurrent = normalizeString(currentTrial)
        local matchedOriginalName = nil

        for _, trialName in ipairs(availableTrials) do
            if normalizeString(trialName) == normalizedCurrent then
                canPlay = true
                matchedOriginalName = trialName
                break
            end
        end

        if canPlay then
            print(string.format("[AutoTrials] Success: Player owns/qualifies for '%s'. Saving state and starting queue...", tostring(currentTrial)))
            saveTrialState(matchedOriginalName)

            local remoteFunction = replicatedStorage:FindFirstChild("RemoteFunction")
            if remoteFunction and remoteFunction:IsA("RemoteFunction") then
                pcall(function()
                    remoteFunction:InvokeServer(
                        "Multiplayer",
                        "v2:start",
                        {
                            count = 1,
                            mode = "Trials"
                        }
                    )
                end)
            end
            return true
        else
            print(string.format("[AutoTrials] Restricted: Player does not meet requirements for '%s'. Skipping...", tostring(currentTrial)))
            return false
        end
    end

    print(string.format("[AutoTrials] Inside trial place (%d). Reading %s...", game.PlaceId, TRIAL_STATE_FILE))
    
    local savedTrial = readTrialState()
    if savedTrial then
        if isTrialAlreadyCompleted(savedTrial) then
            print(string.format("[AutoTrials] Trial '%s' is already marked as owned/completed. Skipping script execution.", savedTrial))
            saveCompletedTrial(savedTrial)
            return false
        end

        print(string.format("[AutoTrials] Found saved trial state: '%s'. Executing corresponding script...", savedTrial))
        local executionSuccess = executeTrialScript(savedTrial)
        if executionSuccess then
            saveCompletedTrial(savedTrial)
        end
        return executionSuccess
    else
        warn("[AutoTrials] No trial state found in trialscript.txt to execute!")
        return false
    end
end

return {
    RunAutoTrial = RunAutoTrial,
    GetMissingTower = GetMissingTower
}
