
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

local function getMyMedics()
    local myMedics = {}
    local towersFolder = Workspace:FindFirstChild("Towers")
    if not towersFolder then return myMedics end

    for _, tower in ipairs(towersFolder:GetChildren()) do
        local replicator = tower:FindFirstChild("TowerReplicator")
        if replicator then
            local ownerId = replicator:GetAttribute("OwnerId")
            local ownerName = replicator:GetAttribute("OwnerName")
            local towerName = replicator:GetAttribute("Name")

            local isOwner = (ownerId and ownerId == PlayerUserId) or (ownerName and ownerName == PlayerName)

            if isOwner and towerName and string.lower(towerName) == "medic" then
                table.insert(myMedics, tower)
            end
        end
    end

    return myMedics
end

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

local function activateUbercharge(medicTower)
    if not RemoteFunction then return end
    
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
    if not RemoteFunction or #targetTowers == 0 then return end
    
    for _, targetTower in ipairs(targetTowers) do
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

local function getTargetTowers(targetPlayer, towersToSelect)
    local targetId, targetName = resolveTargetPlayer(targetPlayer)
    local isUniversal = (targetId == "universal" or targetName == "universal")
    
    local targetTowerNames = {}
    for _, name in ipairs(towersToSelect or {}) do
        targetTowerNames[string.lower(name)] = true
    end

    local towersFolder = Workspace:FindFirstChild("Towers")
    local matchingTowers = {}

    if towersFolder then
        for _, tower in ipairs(towersFolder:GetChildren()) do
            local replicator = tower:FindFirstChild("TowerReplicator")
            if replicator then
                local ownerId = replicator:GetAttribute("OwnerId")
                local ownerName = replicator:GetAttribute("OwnerName")
                local towerName = replicator:GetAttribute("Name")

                local isTargetOwner = false
                
                -- Check if targeting universally or by player match
                if isUniversal then
                    isTargetOwner = true
                elseif targetId and ownerId and ownerId == targetId then
                    isTargetOwner = true
                elseif targetName and ownerName and string.lower(ownerName) == string.lower(targetName) then
                    isTargetOwner = true
                end

                if isTargetOwner and towerName and targetTowerNames[string.lower(towerName)] then
                    table.insert(matchingTowers, tower)
                end
            end
        end
    end

    return matchingTowers
end

function AutoMedic.Function(targetPlayer, towersToSelect, toggle, medicIndex)
    medicIndex = medicIndex or 1

    if activeLoops[medicIndex] then
        task.cancel(activeLoops[medicIndex])
        activeLoops[medicIndex] = nil
    end

    local myMedics = getMyMedics()
    local selectedMedic = myMedics[medicIndex]

    if not selectedMedic then
        warn(string.format("[AutoMedic]: Medic at index [%d] not found!", medicIndex))
        return false
    end

    local medicReplicator = selectedMedic:FindFirstChild("TowerReplicator")
    local towersCanSelect = medicReplicator and medicReplicator:GetAttribute("TowersCanSelect") or 0
    if towersCanSelect < #(towersToSelect or {}) then
        warn(string.format("Medic is low! (Capacity: %d, Requested: %d)", towersCanSelect, #(towersToSelect or {})))
        return false
    end

    local targetTowers = getTargetTowers(targetPlayer, towersToSelect)
    toggleMedicTargets(selectedMedic, targetTowers)

    if toggle then
        local thread = task.spawn(function()
            while true do
                activateUbercharge(selectedMedic)
                task.wait(1)
            end
        end)
        activeLoops[medicIndex] = thread
    else
        activateUbercharge(selectedMedic)
    end

    return true
end

function AutoMedic.Chain(targetPlayer, towersToSelect, toggle)
    if activeChainThread then
        task.cancel(activeChainThread)
        activeChainThread = nil
        print("[AutoMedic]: Stopped active chain loop.")
    end

    if toggle == false and toggle ~= nil then
        print("[AutoMedic]: Chain disabled.")
        return
    end

    local function runChainSequence()
        local myMedics = getMyMedics()

        if #myMedics == 0 then
            warn("[AutoMedic.Chain]: No Medics found to start chain!")
            return false
        end

        print(string.format("[AutoMedic.Chain]: Starting chain with %d Medic(s)...", #myMedics))

        for index, medicTower in ipairs(myMedics) do
            local medicReplicator = medicTower:FindFirstChild("TowerReplicator")
            local towersCanSelect = medicReplicator and medicReplicator:GetAttribute("TowersCanSelect") or 0
            
            if towersCanSelect < #(towersToSelect or {}) then
                warn(string.format("[Medic %d]: Medic is low! Skipping...", index))
                continue
            end

            local targetTowers = getTargetTowers(targetPlayer, towersToSelect)

            if #targetTowers == 0 then
                warn("[AutoMedic.Chain]: No target towers found!")
                return false
            end

            print(string.format("[AutoMedic.Chain]: Medic [%d] -> Attaching targets & activating Ubercharge...", index))
            
            toggleMedicTargets(medicTower, targetTowers)
            
            activateUbercharge(medicTower)

            task.wait(15)

            toggleMedicTargets(medicTower, targetTowers)
            print(string.format("[AutoMedic.Chain]: Medic [%d] -> Detached targets.", index))
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
