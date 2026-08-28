-- AutoTrials.lua
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Function to load TrialRequirements dynamically using loadstring from GitHub
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

-- Function to normalize string formats (e.g., "Exploading Enemies" <-> "ExploadingEnemies")
local function normalizeString(str)
    if not str then return "" end
    return string.lower(string.gsub(str, "%s+", ""))
end

-- Function to check the current active trial against available trials
local function evaluateCurrentTrial()
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

    for _, trialName in ipairs(availableTrials) do
        if normalizeString(trialName) == normalizedCurrent then
            canPlay = true
            break
        end
    end

    if canPlay then
        print(string.format("[AutoTrials] Success: Player owns/qualifies for '%s'. Ready to play!", tostring(currentTrial)))
        -- Insert your automated play logic here
    else
        print(string.format("[AutoTrials] Restricted: Player does not meet requirements for '%s'. Skipping...", tostring(currentTrial)))
    end
end

evaluateCurrentTrial()
