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

TDS:Loadout("Assassin", "Scout", "Paintballer", "DJ Booth", "Gatling Gun")
TDS:Mode("Trial")

TDS:Place("Scout", 135.47198486328125, 2.0749998092651367, -47.1058349609375)
TDS:Place("Paintballer", 137.87881469726562, 2.0749998092651367, -55.15132522583008)
TDS:Place("Assassin", 138.0117950439453, 2.0749998092651367, -57.47431182861328)

TDS:Loadout("Militant", "Crook Boss", "Mercenary Base", "DJ Booth", "Gatling Gun")
TDS:Ready()

-- [ Wave 1 ] --
TDS:SetTarget(2, "Last")
TDS:SetTarget(2, "Strongest")
TDS:SetTarget(2, "Strongest")
TDS:SetTarget(2, "Weakest")
TDS:SetTarget(2, "Closest")

-- [ Wave 2 ] --
TDS:Upgrade(1)
TDS:VoteSkip(2)
TDS:Place("Militant", 130.10536193847656, 2.0749998092651367, -47.082157135009766)

-- [ Wave 3 ] --
TDS:Upgrade(4)
TDS:VoteSkip(3)
TDS:Upgrade(4)

-- [ Wave 4 ] --
TDS:VoteSkip(4)

-- [ Wave 5 ] --
TDS:Place("Militant", 132.67767333984375, 2.0749998092651367, -45.1131706237793)
TDS:Upgrade(5)
TDS:Upgrade(5)

-- [ Wave 8 ] --
TDS:VoteSkip(8)

-- [ Wave 9 ] --
TDS:Place("Gatling Gun", 159.82249450683594, 2.0749998092651367, -13.229134559631348)
TDS:Place("DJ Booth", 147.63356018066406, 1.5, -19.433448791503906)
TDS:Upgrade(7)
TDS:SetOption(7, "Track", "Green")

-- [ Wave 10 ] --
TDS:Upgrade(7)

-- [ Wave 11 ] --
TDS:Upgrade(7)
TDS:Upgrade(6)

-- [ Wave 13 ] --
TDS:Upgrade(6)

-- [ Wave 15 ] --
TDS:Upgrade(7)
TDS:Place("Militant", 154.09707641601562, 2.0749998092651367, -10.596772193908691)
TDS:Place("Militant", 150.74783325195312, 2.0749998092651367, -10.459571838378906)
TDS:Place("Militant", 147.34539794921875, 2.0749998092651367, -10.341268539428711)
TDS:Place("Militant", 144.34335327148438, 2.0749998092651367, -10.445358276367188)
TDS:Place("Militant", 141.30348205566406, 2.0749998092651367, -10.416648864746094)
TDS:Place("Militant", 151.578125, 1.5, -17.945812225341797)
TDS:Place("Militant", 143.66546630859375, 1.5, -17.807775497436523)

-- [ Wave 16 ] --
TDS:Place("Militant", 140.22650146484375, 1.5, -18.030811309814453)
TDS:Place("Militant", 137.91624450683594, 2.0749998092651367, -10.539555549621582)
TDS:Place("Militant", 135.430908203125, 2.0850000381469727, -17.782207489013672)
TDS:Place("Militant", 154.81939697265625, 2.0850000381469727, -17.76276206970215)

-- [ Wave 17 ] --
TDS:Upgrade(6)

-- [ Wave 28 ] --
TDS:Upgrade(6)
TDS:Upgrade(7)
TDS:Upgrade(6)
TDS:Upgrade(6)

-- [ Wave 29 ] --
TDS:Place("Crook Boss", 141.79408264160156, 2.0749998092651367, -28.541423797607422)
TDS:Place("Crook Boss", 144.8720245361328, 2.0749998092651367, -28.598346710205078)
TDS:Place("Crook Boss", 148.00411987304688, 2.0749998092651367, -28.565515518188477)
TDS:Place("Crook Boss", 151.36227416992188, 2.0749998092651367, -28.744909286499023)
TDS:Place("Crook Boss", 146.44412231445312, 2.0749998092651367, -31.433551788330078)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(21)
TDS:Upgrade(21)
TDS:Upgrade(22)
TDS:Upgrade(22)
TDS:Upgrade(23)
TDS:Upgrade(23)
TDS:Place("Mercenary Base", 110.25289916992188, 2, 35.08991241455078)
TDS:Place("Mercenary Base", 105.63225555419922, 2, 34.9456672668457)
TDS:Place("Mercenary Base", 101.100341796875, 2, 35.20123291015625)
TDS:Upgrade(26)
TDS:Upgrade(26)
TDS:Upgrade(25)
TDS:Upgrade(25)
TDS:Upgrade(24)
TDS:Upgrade(24)

-- [ Wave 30 ] --
TDS:Upgrade(24)
TDS:Upgrade(25)
TDS:Upgrade(26)

-- [ Wave 33 ] --
TDS:Upgrade(26)
TDS:Upgrade(25)
TDS:Upgrade(24)
TDS:SetOption(26, "Unit 2", "Grenadier")
TDS:SetOption(26, "Unit 3", "Riot Guard")
TDS:SetOption(25, "Unit 2", "Grenadier")
TDS:SetOption(25, "Unit 3", "Riot Guard")
TDS:SetOption(24, "Unit 2", "Grenadier")
TDS:SetOption(24, "Unit 3", "Riot Guard")
TDS:Upgrade(26)
--
TDS:Upgrade(26)
TDS:Upgrade(25)
TDS:Upgrade(25)
--
TDS:Upgrade(24)
--
TDS:Upgrade(24)
TDS:Place("Militant", 149.64683532714844, 2.0749998092651367, -31.490697860717773)
TDS:Place("Militant", 148.3284454345703, 2.0749998092651367, -34.488067626953125)
TDS:Place("Militant", 145.20420837402344, 2.0749998092651367, -34.28598403930664)
TDS:Place("Militant", 143.4153289794922, 2.0749998092651367, -31.345468521118164)
TDS:Place("Militant", 138.6619873046875, 2.0749998092651367, -28.74456214904785)
TDS:Place("Militant", 140.35174560546875, 2.0749998092651367, -31.755720138549805)
TDS:Place("Militant", 142.10073852539062, 2.0749998092651367, -34.55897521972656)
TDS:Place("Militant", 135.4048309326172, 2.0749998092651367, -28.778528213500977)
TDS:Place("Militant", 136.78514099121094, 2.0749998092651367, -31.54364013671875)
TDS:Place("Militant", 138.28887939453125, 2.0749998092651367, -34.40104675292969)

-- [ Wave 34 ] --
TDS:Place("Militant", 131.9982147216797, 2.0749998092651367, -28.78345489501953)
TDS:Place("Militant", 134.66697692871094, 2.0749998092651367, -34.28220748901367)
TDS:Place("Militant", 132.87208557128906, 2.0749998092651367, -31.869579315185547)
TDS:Upgrade(19)
TDS:Upgrade(20)
TDS:Upgrade(21)
TDS:Upgrade(22)
TDS:Upgrade(23)

-- [ Wave 35 ] --
--
--
--
--
--
--

-- [ Wave 36 ] --
TDS:Upgrade(19)
TDS:Upgrade(20)
TDS:Upgrade(21)
TDS:Upgrade(22)

-- [ Wave 37 ] --
--
--
--
TDS:Upgrade(23)

-- [ Wave 39 ] --
--
--
--

-- [ Wave 40 ] --
--
--
--
--
--
--
--
--
--
