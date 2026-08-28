
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

local Function = {}

local skillTreeTable = {
    ["1"]  = { Name = "Enchanced Optics", MaxLevel = 20 },
    ["2"]  = { Name = "Resourcefulness", MaxLevel = 25 },
    ["3"]  = { Name = "Fortify", MaxLevel = 40 },
    ["4"]  = { Name = "Over-Heal", MaxLevel = 25 },
    ["5"]  = { Name = "Fight Dirty", MaxLevel = 25 },
    ["6"]  = { Name = "Extreme Conditioning", MaxLevel = 25 },
    ["7"]  = { Name = "Stonks", MaxLevel = 20 },
    ["8"]  = { Name = "Expanded Barracks", MaxLevel = 20 },
    ["9"]  = { Name = "Improved Gunpoweder", MaxLevel = 20 },
    ["10"] = { Name = "Beefed Up Minions", MaxLevel = 25 },
    ["11"] = { Name = "Precision", MaxLevel = 15 },
    ["12"] = { Name = "Scavenger", MaxLevel = 20 },
    ["13"] = { Name = "Accelerator", MaxLevel = 25 },
    ["14"] = { Name = "Re-inforcements", MaxLevel = 10 },
    ["15"] = { Name = "Bigger Budget", MaxLevel = 25 },
    ["16"] = { Name = "Bandages", MaxLevel = 25 },
    ["17"] = { Name = "Scholar", MaxLevel = 20 },
}

function Function.CheckData(requiredLevel, requiredTowers, requiredSkillTree)
    requiredLevel = requiredLevel or 1
    requiredTowers = requiredTowers or {}
    requiredSkillTree = requiredSkillTree or {}

    local playerLevel = 1
    pcall(function()
        if player:FindFirstChild("Level") and typeof(player.Level.Value) == "number" then
            playerLevel = player.Level.Value
        elseif player:GetAttribute("Level") then
            playerLevel = player:GetAttribute("Level")
        elseif player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") then
            playerLevel = player.leaderstats.Level.Value
        else
            local clientDataModule = replicatedStorage.Packages.Net:FindFirstChild("ClientData") 
                or (replicatedStorage:FindFirstChild("Modules") and replicatedStorage.Modules:FindFirstChild("ClientData"))
                
            if clientDataModule then
                local clientData = require(clientDataModule)
                if clientData and clientData.Get then
                    local levelVal = clientData.Get("Level")
                    if levelVal then
                        playerLevel = levelVal
                    end
                end
            end
        end
    end)

    if playerLevel < requiredLevel then
        return {
            Success = false,
            Title = "Low Level!",
            Desc = string.format("Required level %d, but you are level %d!", requiredLevel, playerLevel),
            StopAutoTrials = true
        }
    end

    local verifiedOwnedTowers = {}
    local categoryOrder = {"1scrolling", "2scrolling", "3scrolling", "4scrolling", "5scrolling", "6scrolling", "7scrolling"}

    pcall(function()
        if playerGui then
            local inventoryView = playerGui:FindFirstChild("ReactUniversalInventoryView")
            if inventoryView then
                local container = inventoryView.Holder.windowFrame.towersInventoryFrame:FindFirstChild("towerContainer")
                
                if container then
                    for _, scrollerName in ipairs(categoryOrder) do
                        local scroller = container:FindFirstChild(scrollerName)
                        if scroller then
                            for _, towerFrame in ipairs(scroller:GetChildren()) do
            
                                table.insert(verifiedOwnedTowers, towerFrame.Name)
                                
    
                                for _, child in ipairs(towerFrame:GetDescendants()) do
                                    if child:IsA("TextLabel") and child.Text ~= "" and not child.Text:match("^%d+$") then
                                        table.insert(verifiedOwnedTowers, child.Text)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    local missingTowers = {}
    for _, reqTower in ipairs(requiredTowers) do
        local found = false
        local reqLower = string.lower(reqTower):gsub("%s+", "")
        
        for _, ownedTower in ipairs(verifiedOwnedTowers) do
            local ownedLower = string.lower(tostring(ownedTower)):gsub("%s+", "")
            if ownedLower:find(reqLower) or reqLower:find(ownedLower) then
                found = true
                break
            end
        end
        
        if not found then
            table.insert(missingTowers, reqTower)
        end
    end

    if #missingTowers > 0 then
        local missingStr = table.concat(missingTowers, ", ")
        return {
            Success = false,
            Title = "Missing Towers!",
            Desc = "Missing required tower(s): " .. missingStr,
            StopAutoTrials = true,
            MissingTowers = missingTowers,
            Towers = verifiedOwnedTowers
        }
    end

    local scannedSkillTree = {}
    local totalCurrentLevels = 0
    local totalMaxLevels = 0

    pcall(function()
        for id, info in pairs(skillTreeTable) do
            local nodeObj = workspace:FindFirstChild(id)
            local rawLevelText = "0"
            
            if nodeObj then
                local surfaceGui = nodeObj:FindFirstChild("TileSurfaceGui")
                if surfaceGui then
                    local frame = surfaceGui:FindFirstChild("Frame")
                    if frame then
                        local skillLevelLabel = frame:FindFirstChild("SkillLevel")
                        if skillLevelLabel and skillLevelLabel:IsA("TextLabel") then
                            rawLevelText = skillLevelLabel.Text
                        end
                    end
                end
            end

            local currentLevelNum = 0
            local maxLevelNum = tonumber(info.MaxLevel) or 0

            if string.upper(rawLevelText):find("MAX") then
                currentLevelNum = maxLevelNum
            else
                currentLevelNum = tonumber(rawLevelText) or 0
            end

            scannedSkillTree[id] = {
                Name = info.Name,
                MaxLevel = tostring(maxLevelNum),
                CurrentLevel = tostring(currentLevelNum)
            }

            totalCurrentLevels = totalCurrentLevels + currentLevelNum
            totalMaxLevels = totalMaxLevels + maxLevelNum
        end
    end)

    for nodeID, requiredSkillLevel in pairs(requiredSkillTree) do
        local stringID = tostring(nodeID)
        local nodeData = scannedSkillTree[stringID]
        local currentLevel = nodeData and tonumber(nodeData.CurrentLevel) or 0

        if currentLevel < requiredSkillLevel then
            local skillName = nodeData and nodeData.Name or stringID
            return {
                Success = false,
                Title = "Skill Level Too Low!",
                Desc = string.format("Skill '%s' (Node %s) is level %d, but requires %d!", skillName, stringID, currentLevel, requiredSkillLevel),
                StopAutoTrials = true
            }
        end
    end

    return {
        Success = true,
        Title = "Requirements Met!",
        Desc = "Owned towers: " .. #verifiedOwnedTowers .. " | Total skill tree: " .. totalCurrentLevels .. "/" .. totalMaxLevels,
        Level = playerLevel,
        Towers = verifiedOwnedTowers,
        TowerCount = #verifiedOwnedTowers,
        SkillTree = scannedSkillTree,
        TotalSkillLevel = totalCurrentLevels,
        TotalMaxSkillLevel = totalMaxLevels
    }
end

return Function
