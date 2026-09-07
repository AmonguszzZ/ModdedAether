local TDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/auto-strat/refs/heads/main/Library.lua"))()

getgenv().AutoMedic = true
getgenv().AutoMercenary = true
getgenv().AutoDJ  = true
getgenv().AutoGatling = true

getgenv().AutoSkip = false
getgenv().AutoReady = false
getgenv().AutoRejoin = true
getgenv().AutoRestart = false
getgenv().Gatlify = false

TDS:Loadout("Trapper", "Medic", "Mercenary Base", "Gatling Gun", "Tesla")
TDS:Mode("Trial")

TDS:Place("Trapper", -15.369919776916504, 0.9999645352363586, -2.8799638748168945)
TDS:Ready()

-- [ Wave 1 ] --
TDS:Upgrade(1)

-- [ Wave 2 ] --
TDS:Place("Trapper", -16.613407135009766, 0.999962568283081, -0.02874922752380371)

-- [ Wave 3 ] --
TDS:Upgrade(2)

-- [ Wave 4 ] --
TDS:Place("Trapper", -17.152175903320312, 0.9999603629112244, 3.0836942195892334)
TDS:Upgrade(3)

-- [ Wave 5 ] --
TDS:Upgrade(1)
TDS:SetTarget(1, "Last")
TDS:SetTarget(1, "Strongest")
TDS:SetTarget(1, "Weakest")
TDS:SetTarget(1, "Closest")

-- [ Wave 6 ] --
TDS:SetOption(1, "Trap", "Landmine")

-- [ Wave 9 ] --
TDS:Place("Gatling Gun", 27.979957580566406, 3.5999791622161865, 11.008915901184082)

-- [ Wave 10 ] --
TDS:Upgrade(4)

-- [ Wave 12 ] --
TDS:Upgrade(4)

-- [ Wave 13 ] --
TDS:Place("Tesla", 7.445916175842285, 3.59997820854187, 16.476619720458984)
TDS:Place("Tesla", -1.9515929222106934, 3.6000001430511475, -1.9379723072052002)

-- [ Wave 14 ] --
TDS:Upgrade(5)
TDS:Upgrade(6)

-- [ Wave 16 ] --
TDS:Upgrade(4)

-- [ Wave 20 ] --
TDS:Upgrade(4)

-- [ Wave 23 ] --
TDS:Upgrade(4)

-- [ Wave 24 ] --
TDS:Upgrade(5)
TDS:Upgrade(6)

-- [ Wave 29 ] --
TDS:Upgrade(4)
TDS:Upgrade(5)

-- [ Wave 30 ] --
TDS:Upgrade(6)
TDS:Upgrade(5)

-- [ Wave 32 ] --
TDS:Upgrade(6)

-- [ Wave 33 ] --
TDS:Place("Medic", 26.000408172607422, 3.599979877471924, 7.731098175048828)
TDS:Place("Medic", 23.29420280456543, 3.599979877471924, 6.183294773101807)
TDS:Place("Medic", 29.309837341308594, 3.599998712539673, 7.181550979614258)
TDS:Place("Medic", 26.744077682495117, 3.599999189376831, 4.167050361633301)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:MedicSelect(7, 8)
TDS:Place("Trapper", 20.455360412597656, 0.9999529123306274, 13.75526237487793)
TDS:Place("Trapper", 17.327924728393555, 0.9999534487724304, 12.960105895996094)
TDS:Place("Trapper", 20.806608200073242, 0.999950647354126, 16.99703598022461)
TDS:Place("Trapper", 21.24427604675293, 0.9999568462371826, 8.069095611572266)

-- [ Wave 34 ] --
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:SetOption(14, "Trap", "Landmine")
TDS:Upgrade(14)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:SetOption(12, "Trap", "Bear Traps")
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:SetOption(11, "Trap", "Landmine")
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:SetOption(13, "Trap", "Bear Traps")
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:SetOption(3, "Trap", "Landmine")
TDS:Upgrade(2)
TDS:Upgrade(2)
TDS:Upgrade(2)
TDS:SetOption(2, "Trap", "Bear Traps")
TDS:Upgrade(1)
TDS:Upgrade(1)
TDS:SetOption(1, "Trap", "Bear Traps")

-- [ Wave 35 ] --
TDS:Place("Mercenary Base", 26.580718994140625, 0.9999522566795349, 14.660048484802246)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:SetOption(15, "Unit 1", "Riot Guard")
TDS:SetOption(15, "Unit 2", "Riot Guard")
TDS:SetOption(15, "Unit 3", "Riot Guard")

-- [ Wave 36 ] --
TDS:Place("Mercenary Base", -2.737555503845215, 0.9999898672103882, -39.18367004394531)
TDS:Place("Mercenary Base", 2.897974967956543, 0.9999866485595703, -34.473026275634766)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:SetOption(16, "Unit 1", "Grenadier")
TDS:SetOption(16, "Unit 2", "Grenadier")
TDS:SetOption(16, "Unit 3", "Grenadier")
TDS:SetTarget(16, "Last")
TDS:SetTarget(16, "Strongest")
TDS:SetTarget(16, "Strongest")
TDS:SetTarget(16, "Weakest")
TDS:SetTarget(16, "Weakest")
TDS:SetTarget(16, "Strongest")
TDS:SetTarget(16, "Closest")
TDS:SetTarget(16, "Weakest")

-- [ Wave 37 ] --
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(10)
TDS:Upgrade(10)

