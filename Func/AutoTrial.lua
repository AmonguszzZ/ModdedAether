
local replicatedStorage = game:GetService("ReplicatedStorage")

local TRIAL_PLACE_ID = 3260590327

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
    ["Broke"]               = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Broke.txt",
    ["Healthy Enemies"]     = "https://raw.githubusercontent.com/wutmen2/strats/refs/heads/main/Trials/Healthy.txt"
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

local function evaluateCurrentTrial()
    if game.PlaceId == TRIAL_PLACE_ID then
        print(string.format("[AutoTrials] Current PlaceId (%d) matches trial place ID. Triggering Multiplayer start...", game.PlaceId))
        
        local remoteFunction = replicatedStorage:FindFirstChild("RemoteFunction")
        if remoteFunction and remoteFunction:IsA("RemoteFunction") then
            local success, err = pcall(function()
                remoteFunction:InvokeServer(
                    "Multiplayer",
                    "v2:start",
                    {
                        count = 1,
                        mode = "Trials"
                    }
                )
            end)
            if success then
                print("[AutoTrials] Successfully invoked Multiplayer start for Trials.")
            else
                warn(string.format("[AutoTrials] Failed to invoke Multiplayer start: %s", tostring(err)))
            end
        else
            warn("[AutoTrials] RemoteFunction not found in ReplicatedStorage.")
        end
        return
    end

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
        print(string.format("[AutoTrials] Success: Player owns/qualifies for '%s'. Running script...", tostring(currentTrial)))
        executeTrialScript(matchedOriginalName)
    else
        print(string.format("[AutoTrials] Restricted: Player does not meet requirements for '%s'. Skipping...", tostring(currentTrial)))
    end
end

evaluateCurrentTrial()
