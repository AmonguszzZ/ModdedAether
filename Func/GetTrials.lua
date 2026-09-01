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
["Speedy Enemies"] = { Level = 175, Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Trapper"}, Skills = {} },
["Glass"] = { Level = 175, Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Trapper"}, Skills = {} },
["Quarantine"] = { Level = 175, Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth"}, Skills = {} },
["Fog"] = { Level = 175, Towers = {"Trapper", "Hacker", "Gatling Gun", "Mercenary Base", "DJ Booth"}, Skills = {} },
["Limitation"] = { Level = 175, Towers = {"Trapper", "Hacker", "Gatling Guns", "Mercenary Base", "Placeholder"}, Skills = {} },
["Flying"] = { Level = 175, Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth"}, Skills = {} },
["Jailed"] = { Level = 175, Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Military Base"}, Skills = {} },
["Exploding"] = { Level = 175, Towers = {"Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth"}, Skills = {} },
["Inflation"] = { Level = 175, Towers = {"Placeholder"}, Skills = {} },
["Commited"] = { Level = 175, Towers = {"Placeholder"}, Skills = {} },
["Hidden"] = { Level = 175, Towers = {"Gatling Gun", "Hacker", "Mercenary Base", "Trapper", "DJ Booth"}, Skills = {} },
["Broke"] = { Level = 175, Towers = {"Gatling Gun", "Hacker", "Mercenary Base", "Trapper", "DJ Booth"}, Skills = {} },
["Healthy Enemies"] = { Level = 175, Towers = {"Placeholder"}, Skills = {} },
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

local function GetMissingTower()
    local missingData = {}
    local CheckData = loadChecker()

    if not CheckData then
        warn("[TrialRequirements] Failed to fetch or load CheckData function from URL")
        return missingData
    end

    for trialName, reqs in pairs(trialConfigs) do
        local success, result = pcall(function()
            return CheckData(reqs.Level, reqs.Towers, reqs.Skills)
        end)

        if not success or (result and not result.Success) then
            local missingTowers = result and result.MissingTowers or reqs.Towers
            local missingSkills = reqs.Skills or {}

            missingData[trialName] = {
                MissingTowers = missingTowers,
                MissingSkills = missingSkills,
                Reason = result and result.Desc or "Unknown reason"
            }
        end
    end

    return missingData
end

return {
    GetTrials = GetAvailableTrials,
    GetMissingTower = GetMissingTower
}
