
local checkerUrl = "https://raw.githubusercontent.com/AmonguszzZ/ModdedAether/refs/heads/main/Func/PlayerData.lua"

local function loadChecker()
    local success, content = pcall(function()
        return game:HttpGet(checkerUrl)
    end)
    
    if success and content then
        local loadSuccess, func = pcall(loadstring, content)
        if loadSuccess and type(func) == "function" then
            local lib = func()
            if lib and type(lib.CheckData) == "function" then
                return lib.CheckData
            end
        end
    end
    return nil
end

local trialConfigs = {
    ["Speedy Enemies"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
    ["Glass"] = { Level = 175, Towers = {"Gatling Gun"}, Skills = {} },
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

local function GetAvailableTrials()
    local availableTrials = {}
    local CheckData = loadChecker() 

    if not CheckData then
        warn("[TrialRequirements] Failed to fetch or load CheckData function from URL")
        for trialName, _ in pairs(trialConfigs) do
            table.insert(availableTrials, trialName)
        end
        return availableTrials
    end

    for trialName, reqs in pairs(trialConfigs) do
        local success, result = pcall(function()
            return CheckData(reqs.Level, reqs.Towers, reqs.Skills)
        end)
        
        if success and result and result.Success then
            table.insert(availableTrials, trialName)
        else
            local reason = result and result.Desc or "Unknown reason"
            print(string.format("[TrialRequirements] Skipped '%s': %s", trialName, reason))
        end
    end

    return availableTrials
end

return {
    GetTrials = GetAvailableTrials
}
