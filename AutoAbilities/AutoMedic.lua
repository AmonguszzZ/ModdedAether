local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerUserId = LocalPlayer.UserId
local PlayerName = LocalPlayer.Name

local RemoteFunction = ReplicatedStorage:FindFirstChild("RemoteFunction")

local AutoMedic = {}

local activeLoops = {}
local activeChainThread = nil

local CAPACITY_BY_LEVEL = {
    [0] = 1,
    [1] = 2,
    [2] = 3,
    [3] = 3,
    [4] = 4,
    [5] = 5
}

local UBERCHARGE_DURATION = {
    [3] = 7.5,
    [4] = 10,
    [5] = 10
}

local function resolveTargetPlayer(targetInput)
    if type(targetInput) == "number" then
        return targetInput, nil
    elseif type(targetInput) == "string" then
        if string.lower(targetInput) == "universal" or targetInput == "" then
            return "universal", "universal"
        end
        local numericId = tonumber(targetInput)
        if numericId then
            return numericId, nil
        end
        return nil, targetInput
    end
    return "universal", "universal"
end

function AutoMedic.GetAllTowers()
    local towersFolder = Workspace:FindFirstChild("Towers")
    local allTowers = {}

    if not towersFolder then return allTowers end

    for _, tower in ipairs(towersFolder:GetChildren()) do
        local replicator = tower:FindFirstChild("TowerReplicator")
        if replicator and tower.Parent then
            local ownerId = replicator:GetAttribute("OwnerId")
            local ownerName = replicator:GetAttribute("OwnerName")
            local towerName = replicator:GetAttribute("Name")
            local createdAt = replicator:GetAttribute("CreatedAt") or math.huge
            local upgrade = replicator:GetAttribute("Upgrade") or 0
            local towersCanSelect = replicator:GetAttribute("TowersCanSelect")

            table.insert(allTowers, {
                Tower = tower,
                Name = towerName,
                CreatedAt = createdAt,
                OwnerId = ownerId,
                OwnerName = ownerName,
                Upgrade = upgrade,
                TowersCanSelect = towersCanSelect
            })
        end
    end
    
    table.sort(allTowers, function(a, b)
        return a.CreatedAt < b.CreatedAt
    end)

    return allTowers
end

local function getMyMedics()
    local allTowers = AutoMedic.GetAllTowers()
    local myMedics = {}

    for _, data in ipairs(allTowers) do
        local isOwner = (data.OwnerId and data.OwnerId == PlayerUserId) or (data.OwnerName and data.OwnerName == PlayerName)
        if isOwner and data.Name and string.lower(data.Name) == "medic" then
            table.insert(myMedics, data.Tower)
        end
    end

    return myMedics
end

local function countReadyMedics(medicsList)
    local count = 0
    for _, medicTower in ipairs(medicsList) do
        if medicTower and medicTower.Parent then
            local replicator = medicTower:FindFirstChild("TowerReplicator")
            local upgrade = replicator and replicator:GetAttribute("Upgrade") or 0
            if upgrade >= 3 then
                count = count + 1
            end
        end
    end
    return count
end

local function activateUbercharge(medicTower)
    if not RemoteFunction or not medicTower or not medicTower.Parent then return end
    
    pcall(function()
        RemoteFunction:InvokeServer(
            "Troops",
            "Abilities",
            "Activate",
            {
                Troop = medicTower,
                Name = "Ubercharge",
                Data = {}
            }
        )
    end)
end

local function toggleMedicTargets(medicTower, targetTowers)
    if not RemoteFunction or not medicTower or not medicTower.Parent or not targetTowers or #targetTowers == 0 then return end
    
    for _, targetTower in ipairs(targetTowers) do
        if targetTower and targetTower.Parent then
            pcall(function()
                RemoteFunction:InvokeServer(
                    "Troops",
                    "TowerServerEvent",
                    "ToggleSelectedTower",
                    medicTower,
                    targetTower
                )
            end)
        end
    end
end

local function getMedicCapacity(medicTower)
    if not medicTower or not medicTower.Parent then return 0 end
    local medicReplicator = medicTower:FindFirstChild("TowerReplicator")
    if not medicReplicator then return 0 end

    local currentUpgrade = medicReplicator:GetAttribute("Upgrade") or 0
    local attributeCapacity = medicReplicator:GetAttribute("TowersCanSelect")
    
    return attributeCapacity or CAPACITY_BY_LEVEL[currentUpgrade] or 1
end

local function getUberchargeDuration(medicTower)
    if not medicTower or not medicTower.Parent then return 10 end
    local medicReplicator = medicTower:FindFirstChild("TowerReplicator")
    if not medicReplicator then return 10 end

    local currentUpgrade = medicReplicator:GetAttribute("Upgrade") or 3
    return UBERCHARGE_DURATION[currentUpgrade] or 10
end

local function getTargetTowersFromIndex(targetPlayer, towersToSelect, maxCapacity)
    local allTowers = AutoMedic.GetAllTowers()
    local targetId, targetName = resolveTargetPlayer(targetPlayer)
    local isUniversal = (targetId == "universal" or targetName == "universal")

    local nameFilterMap = {}
    for _, name in ipairs(towersToSelect or {}) do
        nameFilterMap[string.lower(name)] = true
    end

    local targetTowers = {}

    for _, data in ipairs(allTowers) do
        local towerNameLower = data.Name and string.lower(data.Name) or ""

        if towerNameLower == "medic" then
            continue
        end

        local isTargetOwner = false
        if isUniversal then
            isTargetOwner = true
        elseif targetId and data.OwnerId and data.OwnerId == targetId then
            isTargetOwner = true
        elseif targetName and data.OwnerName and string.lower(data.OwnerName) == string.lower(targetName) then
            isTargetOwner = true
        end

        local matchesName = nameFilterMap[towerNameLower] == true

        if isTargetOwner and matchesName then
            table.insert(targetTowers, data.Tower)
            if #targetTowers >= maxCapacity then
                break
            end
        end
    end

    return targetTowers
end

function AutoMedic.Function(targetPlayer, towersToSelect, toggle, medicIndex)
    medicIndex = medicIndex or 1

    if not activeLoops[medicIndex] then
        activeLoops[medicIndex] = {thread = nil, lastTargets = {}}
    end

    if activeLoops[medicIndex].thread then
        task.cancel(activeLoops[medicIndex].thread)
        activeLoops[medicIndex].thread = nil
    end

    local myMedics = getMyMedics()
    local selectedMedic = myMedics[medicIndex]

    if not selectedMedic then
        warn(string.format("[AutoMedic]: Medic at index [%d] not found!", medicIndex))
        return false
    end

    if toggle == false then
        if #activeLoops[medicIndex].lastTargets > 0 then
            toggleMedicTargets(selectedMedic, activeLoops[medicIndex].lastTargets)
            activeLoops[medicIndex].lastTargets = {}
            print(string.format("[AutoMedic]: Detached targets for Medic [%d].", medicIndex))
        end
        return true
    end

    local medicReplicator = selectedMedic:FindFirstChild("TowerReplicator")
    local currentUpgrade = medicReplicator and medicReplicator:GetAttribute("Upgrade") or 0
    if currentUpgrade < 3 then
        warn(string.format("[AutoMedic]: Medic [%d] level is too low! (Level %d/3 required)", medicIndex, currentUpgrade))
        return false
    end

    if toggle then
        local thread = task.spawn(function()
            while true do

                if not selectedMedic or not selectedMedic.Parent then
                    if #activeLoops[medicIndex].lastTargets > 0 then
                        activeLoops[medicIndex].lastTargets = {}
                    end
                    warn(string.format("[AutoMedic]: Medic [%d] was sold or removed. Ending thread.", medicIndex))
                    break
                end

                local capacity = getMedicCapacity(selectedMedic)
                local targetTowers = getTargetTowersFromIndex(targetPlayer, towersToSelect, capacity)

                if #targetTowers == 0 then
                    if #activeLoops[medicIndex].lastTargets > 0 then
                        toggleMedicTargets(selectedMedic, activeLoops[medicIndex].lastTargets)
                        activeLoops[medicIndex].lastTargets = {}
                    end
                    task.wait(1)
                    continue
                end

                if #activeLoops[medicIndex].lastTargets > 0 then
                    toggleMedicTargets(selectedMedic, activeLoops[medicIndex].lastTargets)
                    activeLoops[medicIndex].lastTargets = {}
                end

                toggleMedicTargets(selectedMedic, targetTowers)
                activeLoops[medicIndex].lastTargets = targetTowers
                activateUbercharge(selectedMedic)
                
                task.wait(1)
            end
        end)
        activeLoops[medicIndex].thread = thread
    else
        local capacity = getMedicCapacity(selectedMedic)
        local targetTowers = getTargetTowersFromIndex(targetPlayer, towersToSelect, capacity)
        if #targetTowers > 0 then
            toggleMedicTargets(selectedMedic, targetTowers)
            activateUbercharge(selectedMedic)
        end
    end

    return true
end

function AutoMedic.Chain(targetPlayer, towersToSelect, toggle)
    if activeChainThread then
        task.cancel(activeChainThread)
        activeChainThread = nil
        print("[AutoMedic]: Stopped active chain loop.")
    end

    if toggle == false then
        print("[AutoMedic]: Chain disabled.")
        return
    end

    local function runChainSequence()
        local myMedics = getMyMedics()
        local readyCount = countReadyMedics(myMedics)

        if readyCount < 4 then
            warn(string.format("[AutoMedic.Chain]: Insufficient Level 3+ Medics (%d/4). Waiting for new Medics...", readyCount))
            task.wait(1)
            return true
        end

        for index, medicTower in ipairs(myMedics) do
            local currentMedics = getMyMedics()
            if countReadyMedics(currentMedics) < 4 then
                warn("[AutoMedic.Chain]: A Medic was sold mid-chain! Resetting cycle...")
                return true
            end

            if not medicTower or not medicTower.Parent then
                continue
            end

            local medicReplicator = medicTower:FindFirstChild("TowerReplicator")
            local currentUpgrade = medicReplicator and medicReplicator:GetAttribute("Upgrade") or 0

            if currentUpgrade < 3 then
                continue
            end

            local capacity = getMedicCapacity(medicTower)
            local targetTowers = getTargetTowersFromIndex(targetPlayer, towersToSelect, capacity)

            while #targetTowers == 0 do
                task.wait(1)
                if countReadyMedics(getMyMedics()) < 4 then
                    return true
                end
                targetTowers = getTargetTowersFromIndex(targetPlayer, towersToSelect, capacity)
            end

            local duration = getUberchargeDuration(medicTower)

            print(string.format("[AutoMedic.Chain]: Medic [%d] (Level %d) -> Attaching %d target(s) & activating Ubercharge (Duration: %.1fs)...", index, currentUpgrade, #targetTowers, duration))
            
            local attachedTargets = table.clone(targetTowers)

            toggleMedicTargets(medicTower, attachedTargets)

            activateUbercharge(medicTower)

            task.wait(duration)

            if medicTower and medicTower.Parent then
                toggleMedicTargets(medicTower, attachedTargets)
                print(string.format("[AutoMedic.Chain]: Medic [%d] -> Detached targets.", index))
            end
        end

        return true
    end

    if toggle then
        activeChainThread = task.spawn(function()
            while true do
                local success = runChainSequence()
                if not success then break end
            end
        end)
    else
        task.spawn(runChainSequence)
    end
end

return AutoMedic
