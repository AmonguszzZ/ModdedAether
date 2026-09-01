TDS:Loadout("Hacker", "Gatling Gun", "Militant", "Mercenary Base", "Trapper")
TDS:Mode("Trial")

TDS:Place("Militant", 10.119881629943848, 3.599987745285034, 16.501535415649414)

-- [ Wave 1 ] --
TDS:Upgrade(1)
TDS:Ready()
-- [ Wave 2 ] --
TDS:Place("Militant", 11.500614166259766, 3.5999789237976074, 19.186674118041992)

-- [ Wave 3 ] --
TDS:Upgrade(2)

-- [ Wave 4 ] --
TDS:Place("Militant", 14.48906421661377, 3.59997820854187, 18.411235809326172)
TDS:Upgrade(3)
TDS:Place("Militant", 14.472807884216309, 3.599980354309082, 15.360921859741211)

-- [ Wave 5 ] --
TDS:Upgrade(4)
TDS:Place("Militant", 11.641512870788574, 3.599989652633667, 13.906137466430664)
TDS:Upgrade(5)

-- [ Wave 7 ] --
TDS:VoteSkip(7)

-- [ Wave 8 ] --
TDS:WaitForWave(8)
TDS:VoteSkip(8)
TDS:Sell(5)
TDS:Sell(1)
TDS:Sell(4)

-- [ Wave 9 ] --
TDS:Sell(3)
TDS:Place("Gatling Gun", -4.321114540100098, 0.9999881982803345, -36.78215408325195)
TDS:Sell(2)

-- [ Wave 10 ] --
TDS:Upgrade(6)

-- [ Wave 12 ] --
TDS:Upgrade(6)
TDS:Place("Trapper", 8.089369773864746, 0.9999422430992126, 28.97307586669922)
TDS:Upgrade(7)
TDS:Upgrade(7)

-- [ Wave 13 ] --
TDS:SetOption(7, "Trap", "Landmine")

-- [ Wave 14 ] --
TDS:Upgrade(7)

-- [ Wave 16 ] --
TDS:Upgrade(7)
TDS:SetOption(7, "Trap", "Bear Traps")

-- [ Wave 18 ] --
TDS:Upgrade(6)

-- [ Wave 19 ] --
TDS:Place("Mercenary Base", -2.5370631217956543, 0.9999910593032837, -40.826210021972656)
TDS:Upgrade(8)
TDS:Upgrade(8)

-- [ Wave 20 ] --
TDS:Upgrade(8)
TDS:Place("Trapper", 18.09970474243164, 0.9999504685401917, 17.241073608398438)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:SetOption(9, "Trap", "Landmine")
TDS:Upgrade(9)

-- [ Wave 21 ] --
TDS:Upgrade(9)
TDS:SetOption(9, "Trap", "Bear Traps")

-- [ Wave 23 ] --
TDS:Upgrade(6)

-- [ Wave 25 ] --
TDS:Upgrade(6)

-- [ Wave 27 ] --
TDS:Upgrade(8)
TDS:SetOption(8, "Unit 2", "Riot Guard")
TDS:SetOption(8, "Unit 1", "Riot Guard")
TDS:SetOption(8, "Unit 3", "Riot Guard")

-- [ Wave 29 ] --
TDS:Upgrade(6)
TDS:Place("Hacker", 0.09961795806884766, 0.999941349029541, 30.211772918701172)
TDS:Upgrade(10)
TDS:Upgrade(10)

-- [ Wave 30 ] --
TDS:Place("Hacker", 11.618265151977539, 0.9999482035636902, 20.447988510131836)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(8)

-- [ Wave 31 ] --
TDS:Upgrade(8)
TDS:Place("Trapper", 22.377696990966797, 0.9999449253082275, 25.12336540222168)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:SetOption(12, "Trap", "Bear Traps")
TDS:Upgrade(10)

-- [ Wave 32 ] --
TDS:Upgrade(10)
TDS:Upgrade(10, 2)
TDS:Upgrade(11)

-- [ Wave 33 ] --
TDS:Upgrade(11)
TDS:Upgrade(11, 2)

-- [ Wave 34 ] --
TDS:Place("Mercenary Base", -0.44461488723754883, 0.9999866485595703, -34.47880172729492)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:SetOption(13, "Unit 1", "Riot Guard")
TDS:SetOption(13, "Unit 2", "Riot Guard")
TDS:SetOption(13, "Unit 3", "Riot Guard")
TDS:Upgrade(13)

-- [ Wave 35 ] --
TDS:Upgrade(13)
TDS:Place("Mercenary Base", 3.3399558067321777, 0.999991774559021, -41.80641174316406)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:SetOption(14, "Unit 1", "Riot Guard")
TDS:SetOption(14, "Unit 2", "Riot Guard")
TDS:SetOption(14, "Unit 3", "Riot Guard")
TDS:Upgrade(14)

-- [ Wave 36 ] --
TDS:Upgrade(14)

-- [ Wave 37 ] --
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(-2.478036880493164, 6.36240816116333, -25.37445068359375), towerToClone = 6})

-- [ Wave 38 ] --

-- [ Wave 39 ] --

-- [ Wave 40 ] --
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(-2.565211296081543, 6.362436294555664, -25.959753036499023), towerToClone = 6})
