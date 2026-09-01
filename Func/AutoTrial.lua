-- AutoTrials.lua
local replicatedStorage = game:GetService("ReplicatedStorage")

local TRIAL_PLACE_ID = 3260590327
local CONFIG_FOLDER = "GlobalConfigs"
local TRIAL_STATE_FILE = CONFIG_FOLDER .. "/trialscript.txt"

local trialScripts = {
    ["Speedy Enemies"]      = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Speedy.txt",
    ["Glass"]               = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Glass.txt",
    ["Quarantine"]          = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Quarantine.txt",
    ["Fog"]                 = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Fog.txt",
    ["Limitation"]          = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Limitation.txt",
    ["Flying Enemies"]      = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Flying.txt",
    ["Jailed Towers"]       = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Jailed.txt",
    ["Exploding Enemies"]   = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Exploding.txt",
    ["Inflation"]           = "Placeholder",
    ["Committed"]           = "Placeholder",
    ["Hidden Enemies"]      = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Hidden.txt",
    ["Broke"]               = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Strats/Brokes.lua",
    ["Healthy Enemies"]     = "Placeholder"
}

local function getAvailableTrials()
    local url = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/main/Func/GetTrials.lua"
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if success and result and type(result.GetTrials) == "function" then
        return result.GetTrials()
    else
        warn("[AutoTrials] Failed to load trial requirements via loadstring.")
        return {}
    end
end

local function normalizeString(str)
    if not str then return "" end
    return string.lower(string.gsub(str, "%s+", ""))
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
        return
    end

    local scriptUrl = trialScripts[targetKey]
    print(string.format("[AutoTrials] Loading execution script for '%s' from: %s", targetKey, scriptUrl))

    local success, err = pcall(function()
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
    else
        warn(string.format("[AutoTrials] Error executing script for '%s': %s", targetKey, tostring(err)))
    end
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

local function evaluateCurrentTrial()
    if game.PlaceId == TRIAL_PLACE_ID then
        print("[AutoTrials] In lobby. Evaluating available trials...")
        
        local stateReplicators = replicatedStorage:FindFirstChild("StateReplicators")
        local trialsReplicator = stateReplicators and stateReplicators:FindFirstChild("TrialsStateReplicator")

        if not trialsReplicator then
            print("[AutoTrials] TrialsStateReplicator not found.")
            return
        end

        local currentTrial = trialsReplicator:GetAttribute("GlobalTrial")
        if not currentTrial then
            print("[AutoTrials] No active GlobalTrial found.")
            return
        end

        print(string.format("[AutoTrials] Current active trial (Replicator): %s", tostring(currentTrial)))

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
        else
            print(string.format("[AutoTrials] Restricted: Player does not meet requirements for '%s'. Skipping...", tostring(currentTrial)))
        end
        return
    end

    print(string.format("[AutoTrials] Inside trial place (%d). Reading %s...", game.PlaceId, TRIAL_STATE_FILE))
    
    local savedTrial = readTrialState()
    if savedTrial then
        print(string.format("[AutoTrials] Found saved trial state: '%s'. Executing corresponding script...", savedTrial))
        executeTrialScript(savedTrial)
    else
        warn("[AutoTrials] No trial state found in trialscript.txt to execute!")
    end
end

evaluateCurrentTrial()
