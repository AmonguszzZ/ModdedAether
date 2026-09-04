local TDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/auto-strat/refs/heads/main/Library.lua"))()

getgenv().AutoMedic = true
getgenv().AutoMercenary = true
getgenv().AutoDJ  = true
getgenv().AutoGatling = true

getgenv().AutoSkip = false
getgenv().AutoReady = false
getgenv().AutoRejoin = false
getgenv().AutoRestart = false

TDS:Loadout("Militant", "DJ Booth", "Gatling Gun", "Medic", "Trapper")
TDS:Mode("Trial")

TDS:Place("Militant", 9.337227821350098, 1.000009536743164, 4.332147598266602)
TDS:Ready()

-- [ Wave 1 ] --
TDS:Upgrade(1)

-- [ Wave 3 ] --
TDS:Place("Militant", 6.2282280921936035, 1.000009536743164, 4.234487533569336)
TDS:Upgrade(2)

-- [ Wave 4 ] --
TDS:Place("Militant", 9.205511093139648, 1.000009536743164, 7.442915439605713)

-- [ Wave 5 ] --
TDS:Upgrade(1)
TDS:Upgrade(3)

-- [ Wave 8 ] --
TDS:VoteSkip(8)

-- [ Wave 9 ] --
TDS:Place("Gatling Gun", -0.2704801559448242, 5.376312255859375, -24.296743392944336)

-- [ Wave 10 ] --
TDS:Place("DJ Booth", -0.41582489013671875, 1.000009536743164, -12.759340286254883)
TDS:SetOption(5, "Track", "Green")
TDS:Upgrade(5)
TDS:Upgrade(5)

-- [ Wave 11 ] --
TDS:Upgrade(4)

-- [ Wave 12 ] --
TDS:SetOption(5, "Track", "Red")

-- [ Wave 13 ] --
TDS:Upgrade(5)
TDS:SetOption(5, "Track", "Green")

-- [ Wave 15 ] --
TDS:Upgrade(4)
TDS:Place("Militant", 6.713847637176514, 1.000009536743164, -1.0294981002807617)
TDS:Place("Militant", 3.6561059951782227, 1.000009536743164, -1.233595371246338)
TDS:Place("Militant", 0.48620128631591797, 1.000009536743164, -1.330385684967041)
TDS:Place("Militant", -2.6557393074035645, 1.000009536743164, -1.3877630233764648)
TDS:Place("Militant", -4.282905578613281, 1.000009536743164, -4.1876220703125)
TDS:Place("Militant", -7.3592705726623535, 1.000009536743164, -5.9393205642700195)

-- [ Wave 16 ] --
TDS:Place("Medic", -4.881012916564941, 1.000009536743164, -12.713661193847656)
TDS:Place("Medic", -3.6863112449645996, 1.000009536743164, -15.51504898071289)
TDS:Place("Medic", -0.8111900091171265, 1.000009536743164, -17.113849639892578)
TDS:Place("Medic", 2.668048858642578, 1.000009536743164, -16.123775482177734)
TDS:Place("Militant", 1.7538909912109375, 1.000009536743164, -6.70198917388916)
TDS:Place("Militant", 4.818761825561523, 1.000009536743164, -6.596046447753906)
TDS:Place("Militant", 2.9604990482330322, 1.000009536743164, -9.700000762939453)
TDS:Place("Militant", 7.820394515991211, 1.000009536743164, -6.561542510986328)

-- [ Wave 18 ] --
TDS:Upgrade(5)
TDS:Place("Militant", 9.97445297241211, 1.000009536743164, -0.9107160568237305)
TDS:Place("Militant", 11.10140609741211, 1.000009536743164, -6.713143348693848)
TDS:Place("Militant", 9.187820434570312, 1.000009536743164, -9.349020004272461)

-- [ Wave 19 ] --
TDS:Upgrade(4)

-- [ Wave 26 ] --
TDS:Upgrade(5)
TDS:Upgrade(4)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
--
--
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
--
--
--
--
--
--
--
--
--

-- [ Wave 27 ] --
--
--

-- [ Wave 28 ] --
--
--
--
--
--
--
--

-- [ Wave 29 ] --
TDS:Upgrade(4)
--
--
--
--
--

-- [ Wave 30 ] --
--
--
--
--
--
--
--
--

-- [ Wave 31 ] --
--
--
--
--
--
--
--
--
TDS:Upgrade(4)

-- [ Wave 32 ] --
--
--
--
--
--
--
TDS:Upgrade(12)
TDS:Upgrade(13)
TDS:Upgrade(14)
TDS:Upgrade(15)
--
--
TDS:Upgrade(12)
TDS:Upgrade(13)

-- [ Wave 33 ] --
TDS:Upgrade(14)
TDS:Upgrade(15)
TDS:Place("Trapper", 4.693347930908203, 1.000009536743164, 1.6076574325561523)
TDS:Place("Trapper", 1.6703972816467285, 1.000009536743164, 1.6444110870361328)
TDS:Place("Trapper", -1.3573179244995117, 1.000009536743164, 1.493767261505127)
TDS:Place("Trapper", 10.383810997009277, 1.000009536743164, -12.378347396850586)
TDS:Place("Trapper", 12.418246269226074, 1.000009536743164, -9.790693283081055)
TDS:Place("Trapper", 14.096821784973145, 1.000009536743164, -7.169693946838379)
TDS:Place("Trapper", 15.168758392333984, 1.000009536743164, -11.471729278564453)
TDS:Upgrade(26)
--
--
--
--
--
TDS:Upgrade(26)
--
TDS:Upgrade(27)
TDS:Upgrade(27)
TDS:SetOption(26, "Trap", "Landmine")
--
TDS:Upgrade(28)
TDS:Upgrade(28)
TDS:SetOption(28, "Trap", "Landmine")
TDS:SetOption(27, "Trap", "Landmine")
TDS:Upgrade(29)
TDS:Upgrade(29)
TDS:SetOption(29, "Trap", "Landmine")
TDS:Upgrade(23)
TDS:Upgrade(23)
TDS:SetOption(23, "Trap", "Landmine")
--
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(24)
TDS:Upgrade(24)
TDS:SetOption(24, "Trap", "Landmine")
TDS:Upgrade(25)
TDS:Upgrade(25)
TDS:SetOption(25, "Trap", "Landmine")

-- [ Wave 34 ] --
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(23)
TDS:Upgrade(23)
TDS:Upgrade(24)
TDS:Upgrade(24)
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(25)
TDS:Upgrade(25)

-- [ Wave 35 ] --
--
TDS:Upgrade(26)
TDS:Upgrade(26)
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(27)
--
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(27)
TDS:Upgrade(29)
--
--
--
--
--
--
--
--
--
--

-- [ Wave 36 ] --
--
--
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(29)

-- [ Wave 37 ] --
--
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(28)
TDS:Upgrade(28)
TDS:SetOption(23, "Trap", "Bear Traps")
--
--
--
--
--
--
--
--
TDS:SetOption(25, "Trap", "Bear Traps")
--
--
--
TDS:SetOption(26, "Trap", "Bear Traps")
TDS:SetOption(28, "Trap", "Bear Traps")
--
--
--
--
--
--
--
--
--
--
--
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:VoteSkip(37)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(8)

-- [ Wave 38 ] --
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
--
--
--
--
--
TDS:Upgrade(10)
--
TDS:Upgrade(10)
--
TDS:Upgrade(10)
--
TDS:Upgrade(10)
--
--
--
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(1)
TDS:Upgrade(1)
TDS:Upgrade(2)
TDS:Upgrade(2)
TDS:Upgrade(2)
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(19)
TDS:Upgrade(19)
--
TDS:Upgrade(19)
--
TDS:Upgrade(19)
--
--
--
TDS:Upgrade(21)
--
TDS:Upgrade(21)
--
--
--
--
--
TDS:Upgrade(21)
TDS:Upgrade(21)
TDS:Place("Militant", 5.544588088989258, 1.000009536743164, 33.54861831665039)

-- [ Wave 39 ] --
TDS:Place("Militant", 0.33773231506347656, 1.000009536743164, 24.329776763916016)
--
--
--
--
--
--
TDS:Place("Militant", 6.117162704467773, 1.000009536743164, 17.77600860595703)
--
--
--
--
TDS:Place("Militant", 12.030877113342285, 1.000009536743164, 15.47692584991455)
--
TDS:Place("Militant", 13.231023788452148, 1.000009536743164, 8.908162117004395)
TDS:Place("Militant", 23.765161514282227, 1.000009536743164, 9.751443862915039)
TDS:Place("Militant", 17.878520965576172, 1.000009536743164, 2.5339183807373047)
TDS:Place("Militant", 24.109521865844727, 1.000009536743164, -2.4400901794433594)
TDS:Place("Militant", 17.351490020751953, 1.000009536743164, -7.614353179931641)
TDS:Upgrade(22)
TDS:Upgrade(22)
TDS:Upgrade(22)
TDS:Upgrade(22)
--
--
--
--
--
--
--
TDS:Upgrade(18)
TDS:Upgrade(18)
--
TDS:Upgrade(18)
TDS:Upgrade(18)
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
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
