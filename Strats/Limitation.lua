
TDS:Loadout("Trapper", "Hacker", "Gatling Gun", "Mercenary Base", "DJ Booth")
TDS:Mode("Trial")

TDS:Place("Trapper", 398.384033203125, 53.52994155883789, -105.24848937988281)
TDS:Ready()
-- [ Wave 2 ] --
TDS:Upgrade(1)

-- [ Wave 5 ] --
TDS:VoteSkip(5)

-- [ Wave 6 ] --
TDS:VoteSkip(6)

-- [ Wave 7 ] --
TDS:VoteSkip(7)
TDS:Place("Gatling Gun", 408.8110656738281, 54.88662338256836, -133.1854248046875)

-- [ Wave 9 ] --
TDS:Upgrade(2)

-- [ Wave 11 ] --
TDS:Upgrade(2)

-- [ Wave 12 ] --
TDS:Place("DJ Booth", 417.2267150878906, 53.431827545166016, -139.40145874023438)
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:SetOption(3, "Track", "Green")

-- [ Wave 13 ] --
TDS:Upgrade(3)

-- [ Wave 15 ] --
TDS:Upgrade(2)

-- [ Wave 16 ] --
TDS:Place("Hacker", 363.0458068847656, 54.565120697021484, -103.17298889160156)
TDS:Upgrade(4)
TDS:Upgrade(4)

-- [ Wave 17 ] --
TDS:Upgrade(3)

-- [ Wave 20 ] --
TDS:Upgrade(3)

-- [ Wave 21 ] --
TDS:Upgrade(2)

-- [ Wave 23 ] --
TDS:Upgrade(2)

-- [ Wave 27 ] --
TDS:Upgrade(2)
TDS:Place("Mercenary Base", 407.5960693359375, 52.48505783081055, -136.7519073486328)
TDS:Upgrade(5)
TDS:Upgrade(5)
TDS:Upgrade(5)

-- [ Wave 28 ] --
TDS:Upgrade(5)
TDS:SetOption(5, "Unit 1", "Riot Guard")
TDS:SetOption(5, "Unit 2", "Riot Guard")
TDS:SetOption(5, "Unit 3", "Riot Guard")
TDS:Upgrade(5)

-- [ Wave 29 ] --
TDS:Upgrade(5)
TDS:Place("Mercenary Base", 429.6331481933594, 49.46369934082031, -147.0326690673828)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)

-- [ Wave 30 ] --
TDS:Upgrade(6)
TDS:SetOption(6, "Unit 1", "Riot Guard")
TDS:SetOption(6, "Unit 2", "Riot Guard")
TDS:SetOption(6, "Unit 3", "Riot Guard")
TDS:Upgrade(6)


-- [ Wave 31 ] --
TDS:Upgrade(6)
TDS:Place("Mercenary Base", 429.7021484375, 49.46095657348633, -142.3992462158203)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:SetOption(7, "Unit 3", "Riot Guard")
TDS:SetOption(7, "Unit 2", "Riot Guard")
TDS:SetOption(7, "Unit 1", "Riot Guard")
TDS:Upgrade(7)

-- [ Wave 32 ] --
TDS:Upgrade(7)
TDS:SetOption(3, "Track", "Red")
TDS:Upgrade(4)

-- [ Wave 33 ] --
TDS:Upgrade(4)
TDS:Upgrade(4, 2)
TDS:Sell(1)

-- [ Wave 34 ] --

-- [ Wave 35 ] --
TDS:Ability(4, "Hologram Tower", {towerPosition = Vector3.new(411.38140869140625, 55.308231353759766, -137.35321044921875), towerToClone = 2}, true)
