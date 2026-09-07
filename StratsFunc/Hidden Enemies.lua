local TDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/auto-strat/refs/heads/main/Library.lua"))()

getgenv().AutoMedic = true
getgenv().AutoMercenary = true
getgenv().AutoDJ  = true
getgenv().AutoGatling = true

getgenv().AutoSkip = false
getgenv().AutoReady = false
getgenv().AutoRejoin = false
getgenv().AutoRestart = false

TDS:Loadout("Militant", "Mercenary Base", "DJ Booth", "Medic", "Gatling Gun")
TDS:Mode("Trial")

TDS:Place("Militant", -26.024681091308594, 1.0249866247177124, -18.323253631591797)
TDS:Ready()

-- [ Wave 2 ] --
TDS:Upgrade(1)
TDS:Place("Militant", -28.698577880859375, 1.0249983072280884, -16.635093688964844)

-- [ Wave 3 ] --
TDS:Upgrade(2)

-- [ Wave 5 ] --
TDS:Place("Militant", -26.687320709228516, 1.0249885320663452, -21.825031280517578)
TDS:Upgrade(3)

-- [ Wave 6 ] --
TDS:Upgrade(1)

-- [ Wave 7 ] --
TDS:Upgrade(2)

-- [ Wave 8 ] --
TDS:VoteSkip(8)

-- [ Wave 9 ] --
TDS:Place("Gatling Gun", 13.95383358001709, 1.0249983072280884, -3.201427459716797)
TDS:Place("DJ Booth", 4.151457786560059, 1.0249898433685303, -2.5088634490966797)
TDS:SetOption(5, "Track", "Green")
TDS:Upgrade(5)

-- [ Wave 10 ] --
TDS:Upgrade(5)

-- [ Wave 11 ] --
TDS:Upgrade(4)

-- [ Wave 12 ] --
TDS:Upgrade(5)

-- [ Wave 13 ] --
TDS:Place("Medic", 13.841072082519531, 1.0249888896942139, 0.32943296432495117)
TDS:Place("Medic", 10.417244911193848, 1.0249947309494019, -2.575251579284668)
TDS:Place("Medic", 11.315581321716309, 1.0249855518341064, 2.467991590499878)
TDS:Place("Medic", 7.4610443115234375, 1.0249876976013184, -0.2093672752380371)
TDS:Upgrade(4)


-- [ Wave 14 ] --


-- [ Wave 15 ] --
TDS:Upgrade(5)

-- [ Wave 17 ] --
TDS:Upgrade(4)
TDS:Place("Militant", 0.20116710662841797, 1.0249916315078735, 0.7473878860473633)
TDS:Place("Militant", -3.0163769721984863, 1.0249922275543213, 2.1781482696533203)
TDS:Place("Militant", -4.202177047729492, 1.0249788761138916, 5.74641227722168)

-- [ Wave 18 ] --
TDS:Place("Militant", -6.279012680053711, 1.0249912738800049, 2.7331056594848633)
TDS:Place("Militant", -4.845836639404297, 1.024991750717163, -0.6274895668029785)

-- [ Wave 19 ] --
TDS:Place("Militant", -1.7281951904296875, 1.0249912738800049, -2.177159309387207)
TDS:Place("Militant", -8.164923667907715, 1.024986982345581, -1.4484214782714844)
TDS:Place("Militant", -9.217976570129395, 1.0249836444854736, 2.073732376098633)
TDS:Upgrade(5)

-- [ Wave 20 ] --
TDS:Place("Mercenary Base", 20.072059631347656, 1.0249956846237183, -3.257134437561035)
TDS:Place("Mercenary Base", 20.068439483642578, 1.024985671043396, 1.5627102851867676)
TDS:Place("Mercenary Base", 13.956260681152344, 1.0249866247177124, 5.294579982757568)

-- [ Wave 22 ] --
TDS:Upgrade(4)
TDS:Place("Militant", 7.5341057777404785, 1.0249947309494019, 2.9056577682495117)
TDS:Place("Militant", 5.512523651123047, 1.024986743927002, 7.536896228790283)
TDS:Place("Militant", 1.5242643356323242, 1.024989128112793, 8.541702270507812)
TDS:Place("Militant", -1.9159698486328125, 1.0249879360198975, 8.922757148742676)

-- [ Wave 24 ] --
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(4)

-- [ Wave 28 ] --
TDS:Upgrade(4)
TDS:Upgrade(18)
TDS:Upgrade(18)
TDS:Upgrade(18)
TDS:Upgrade(18)
TDS:SetOption(18, "Unit 1", "Riot Guard")

-- [ Wave 29 ] --
TDS:SetOption(18, "Unit 2", "Riot Guard")
TDS:SetOption(18, "Unit 3", "Riot Guard")
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:SetOption(19, "Unit 1", "Riot Guard")
TDS:SetOption(19, "Unit 2", "Riot Guard")
TDS:SetOption(19, "Unit 3", "Riot Guard")
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:SetOption(20, "Unit 1", "Riot Guard")
TDS:SetOption(20, "Unit 2", "Riot Guard")
TDS:SetOption(20, "Unit 3", "Riot Guard")

-- [ Wave 31 ] --
TDS:Upgrade(7)
TDS:Upgrade(7)

-- [ Wave 32 ] --
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:MedicSelect(9, 19)
TDS:MedicSelect(9, 19)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(20)
TDS:Upgrade(8)
TDS:Upgrade(19)
TDS:Upgrade(18)

-- [ Wave 33 ] --
TDS:Upgrade(8)
TDS:Upgrade(20)
TDS:Upgrade(19)
TDS:Upgrade(18)
TDS:Ability(19, "Air-Drop", {directionCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), dist = 115, pathName = 1})
TDS:Ability(18, "Air-Drop", {directionCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), dist = 115, pathName = 1})
TDS:Ability(20, "Air-Drop", {directionCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), dist = 115, pathName = 1})

-- [ Wave 34 ] --
TDS:SetOption(5, "Track", "Red")
