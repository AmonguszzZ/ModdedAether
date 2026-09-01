
TDS:Loadout("Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth")
TDS:Mode("Trial")

TDS:Place("Militant", 18.596546173095703, 26.553707122802734, -156.36927795410156)

-- [ Wave 1 ] --
TDS:Upgrade(1)
TDS:Ready()

-- [ Wave 2 ] --
TDS:Place("Militant", 17.732990264892578, 27.267850875854492, -152.16738891601562)

-- [ Wave 3 ] --
TDS:Upgrade(2)

-- [ Wave 4 ] --
TDS:Place("Militant", 22.902198791503906, 27.214120864868164, -156.1202850341797)
TDS:Upgrade(3)

-- [ Wave 5 ] --
TDS:Place("Militant", 25.97623634338379, 27.382442474365234, -150.09397888183594)
TDS:Upgrade(4)

-- [ Wave 7 ] --
TDS:VoteSkip(7)

-- [ Wave 8 ] --
TDS:WaitForWave(8)
TDS:VoteSkip(8)
TDS:Sell(2)
TDS:Sell(3)
TDS:Sell(1)
TDS:Sell(4)

-- [ Wave 9 ] --
TDS:Place("Gatling Gun", 58.70062255859375, 31.89063262939453, -144.58897399902344)
TDS:Upgrade(5)

-- [ Wave 12 ] --
TDS:Upgrade(5)

-- [ Wave 15 ] --
TDS:Upgrade(5)
TDS:Place("DJ Booth", 53.41585922241211, 29.401355743408203, -147.61941528320312)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:SetOption(6, "Track", "Green")

-- [ Wave 16 ] --
TDS:Upgrade(6)

-- [ Wave 17 ] --
TDS:Place("Hacker", 4.5379180908203125, 28.295516967773438, -153.99826049804688)
TDS:Upgrade(7)
TDS:Upgrade(7)

-- [ Wave 19 ] --
TDS:Upgrade(5)

-- [ Wave 22 ] --
TDS:Upgrade(5)

-- [ Wave 26 ] --
TDS:Upgrade(5)
TDS:Place("Mercenary Base", 56.57052230834961, 29.26028060913086, -141.11080932617188)
TDS:Upgrade(8)
TDS:Upgrade(8)

-- [ Wave 27 ] --
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:SetOption(8, "Unit 1", "Riot Guard")
TDS:SetOption(8, "Unit 2", "Riot Guard")
TDS:SetOption(8, "Unit 3", "Riot Guard")

-- [ Wave 28 ] --
TDS:Upgrade(8)

-- [ Wave 29 ] --
TDS:Upgrade(8)
TDS:Upgrade(6)
TDS:SetOption(6, "Track", "Red")
TDS:Upgrade(6)

-- [ Wave 30 ] --
TDS:Place("Mercenary Base", 82.37223815917969, 28.348222732543945, -166.8600616455078)
TDS:Upgrade(9)
TDS:Upgrade(9)

-- [ Wave 31 ] --
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:SetOption(9, "Unit 1", "Riot Guard")
TDS:SetOption(9, "Unit 2", "Riot Guard")
TDS:SetOption(9, "Unit 3", "Riot Guard")
TDS:Upgrade(9)
TDS:Upgrade(9)

-- [ Wave 32 ] --
TDS:Place("Mercenary Base", 88.57913970947266, 28.331993103027344, -153.52879333496094)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:SetOption(10, "Unit 1", "Riot Guard")
TDS:SetOption(10, "Unit 2", "Riot Guard")
TDS:SetOption(10, "Unit 3", "Riot Guard")
TDS:Upgrade(10)
TDS:Upgrade(10)

-- [ Wave 33 ] --
TDS:Upgrade(7)
TDS:Upgrade(7)

-- [ Wave 34 ] --
TDS:Upgrade(7, 2)
TDS:Place("Hacker", 32.42845916748047, 28.520427703857422, -161.66073608398438)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)

-- [ Wave 35 ] --
TDS:Upgrade(11, 2)

-- [ Wave 37 ] --
TDS:Ability(7, "Hologram Tower", {towerPosition = Vector3.new(20.053861618041992, 31.19621467590332, -166.93580627441406), towerToClone = 5}, true)

-- [ Wave 40 ] --
