-- AutoTrials.lua
local replicatedStorage = game:GetService("ReplicatedStorage")

local function getAvailableTrialsWithConfigs()
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

    print(string.format("[AutoTrials] Current active trial: %s", tostring(currentTrial)))

    local availableTrials = getAvailableTrialsWithConfigs()
    local canPlay = false

    for _, trialName in ipairs(availableTrials) do
        if trialName == currentTrial then
            canPlay = true
            break
        end
    end

    if canPlay then
        print(string.format("[AutoTrials] Success: Player owns/qualifies for '%s'. Ready to play.", currentTrial))
    else
        -- Fallback inspection to show requirements for the unowned trial
        local trialConfigs = {
            ["Speedy Enemies"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Glass"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = { ["1"] = 10 } },
            ["Quarantine"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Fog"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Limitation"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Flying Enemies"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Jailed Towers"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Exploding Enemies"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Inflation"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Committed"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Hidden Enemies"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Broke"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
            ["Healthy Enemies"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} }
        }

        local reqs = trialConfigs[currentTrial]
        if reqs then
            local towersStr = table.concat(reqs.Towers, ", ")
            print(string.format("[AutoTrials] Restricted: Player does not meet requirements for '%s'. Required Level: %d | Towers: [%s]", currentTrial, reqs.Level, towersStr))
        else
            print(string.format("[AutoTrials] Restricted: Player does not meet requirements for '%s' (No config found).", currentTrial))
        end
    end
end

evaluateCurrentTrial()
