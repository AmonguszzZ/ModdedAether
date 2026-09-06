local TDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/auto-strat/refs/heads/main/Library.lua"))()

getgenv().AutoMedic = true
getgenv().AutoMercenary = true
getgenv().AutoDJ  = true
getgenv().AutoGatling = true

getgenv().AutoSkip = false
getgenv().AutoReady = false
getgenv().AutoRejoin = false
getgenv().AutoRestart = false

TDS:Loadout("Trapper", "Gatling Gun", "DJ Booth", "Medic", "Mercenary Base")
TDS:Mode("Trial")

TDS:Place("Trapper", 399.0681457519531, 53.212581634521484, -105.72612762451172)
TDS:Ready()

-- [ Wave 2 ] --
TDS:Upgrade(1)
TDS:Place("Trapper", 395.99755859375, 54.27972412109375, -105.93933868408203)

-- [ Wave 3 ] --
TDS:Upgrade(2)

-- [ Wave 4 ] --
TDS:Place("Trapper", 398.5420837402344, 52.9765510559082, -109.05805969238281)
TDS:Upgrade(3)

-- [ Wave 5 ] --
TDS:VoteSkip(5)

-- [ Wave 6 ] --
TDS:Upgrade(1)
TDS:SetOption(1, "Trap", "Landmine")
TDS:SetTarget(1, "Last")
TDS:SetTarget(1, "Strongest")
TDS:SetTarget(1, "Weakest")
TDS:SetTarget(1, "Closest")

-- [ Wave 8 ] --
TDS:VoteSkip(8)

-- [ Wave 9 ] --
TDS:VoteSkip(9)
TDS:Place("Gatling Gun", 402.9840393066406, 52.512123107910156, -97.82518005371094)

-- [ Wave 10 ] --
TDS:Place("DJ Booth", 410.8616943359375, 52.66823959350586, -105.30552673339844)
TDS:SetOption(5, "Track", "Green")

-- [ Wave 11 ] --
TDS:Upgrade(4)
TDS:Upgrade(5)
TDS:Upgrade(5)

-- [ Wave 12 ] --
TDS:Place("Trapper", 399.1327819824219, 53.23805236816406, -97.7054443359375)
TDS:SetTarget(6, "Last")
TDS:SetTarget(6, "Strongest")
TDS:SetTarget(6, "Weakest")
TDS:SetTarget(6, "Closest")
TDS:Place("Trapper", 400.2441711425781, 52.72551345825195, -111.69371795654297)
TDS:SetTarget(7, "Last")
TDS:SetTarget(7, "Strongest")
TDS:SetTarget(7, "Weakest")
TDS:SetTarget(7, "Closest")
TDS:Place("Trapper", 405.9400329589844, 52.49399185180664, -105.00845336914062)
TDS:Place("Trapper", 406.0118713378906, 52.49646759033203, -108.01580810546875)
TDS:SetTarget(8, "Last")
TDS:SetTarget(8, "Strongest")
TDS:SetTarget(8, "Strongest")
TDS:SetTarget(8, "Weakest")

-- [ Wave 13 ] --
TDS:SetTarget(8, "Closest")
TDS:SetTarget(9, "Last")
TDS:SetTarget(9, "Strongest")
TDS:SetTarget(9, "Weakest")
TDS:SetTarget(9, "Weakest")
TDS:SetTarget(9, "Closest")
TDS:Upgrade(5)
TDS:VoteSkip(13)

-- [ Wave 14 ] --
TDS:Upgrade(4)
TDS:Place("Medic", 405.8658142089844, 52.49156188964844, -102.00809478759766)

-- [ Wave 15 ] --
TDS:Place("Medic", 405.7956848144531, 52.49126052856445, -111.12198638916016)
TDS:Place("Medic", 409.162109375, 52.5147819519043, -109.23603057861328)
TDS:Place("Medic", 408.9694519042969, 53.2069091796875, -100.5417709350586)
TDS:Upgrade(5)

-- [ Wave 17 ] --
TDS:Upgrade(4)

-- [ Wave 19 ] --
TDS:Upgrade(5)

-- [ Wave 20 ] --
TDS:Place("Mercenary Base", 408.9383239746094, 54.154727935791016, -96.5660400390625)
TDS:Place("Mercenary Base", 422.4386291503906, 49.44834518432617, -116.23675537109375)
TDS:Place("Mercenary Base", 425.63525390625, 49.61660385131836, -113.01142883300781)

-- [ Wave 21 ] --
TDS:Upgrade(14)
TDS:Upgrade(15)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:SetOption(16, "Unit 2", "Grenadier")
TDS:SetOption(16, "Unit 1", "Grenadier")
TDS:SetTarget(16, "Last")
TDS:SetTarget(16, "Strongest")
TDS:SetTarget(16, "Strongest")
TDS:SetTarget(16, "Weakest")
TDS:SetTarget(16, "Weakest")
TDS:SetTarget(16, "Closest")

-- [ Wave 22 ] --
TDS:SetTarget(16, "Strongest")
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:SetOption(15, "Unit 1", "Grenadier")
TDS:SetOption(15, "Unit 2", "Grenadier")
TDS:SetOption(15, "Unit 1", "Rifleman")
TDS:SetOption(15, "Unit 2", "Rifleman")
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:SetOption(14, "Unit 1", "Riot Guard")
TDS:SetOption(14, "Unit 2", "Riot Guard")
TDS:SetOption(14, "Unit 3", "Riot Guard")

-- [ Wave 23 ] --
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
--
--
--
--
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
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

-- [ Wave 24 ] --
--
--
--
--
--
--
TDS:Upgrade(4)

-- [ Wave 25 ] --
--

-- [ Wave 26 ] --
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

-- [ Wave 27 ] --
--
--
--
--
--
--
TDS:Upgrade(4)

-- [ Wave 28 ] --
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

-- [ Wave 29 ] --
TDS:Upgrade(4)
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

-- [ Wave 30 ] --
TDS:Upgrade(14)
--
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:SetOption(16, "Unit 3", "Grenadier")
TDS:Upgrade(15)

-- [ Wave 31 ] --
--
TDS:Upgrade(14)
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

-- [ Wave 32 ] --
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

-- [ Wave 33 ] --
--
TDS:Upgrade(16)
TDS:Upgrade(16)
--
--
--
--
--
--
TDS:Upgrade(15)
--
TDS:Upgrade(15)
--
--
TDS:Upgrade(10)
--
TDS:Upgrade(10)
--
--
--
--
--
--
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(11)
TDS:Upgrade(11)
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
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:SetOption(6, "Trap", "Landmine")
TDS:Upgrade(1)
TDS:Upgrade(1)
TDS:SetOption(1, "Trap", "Bear Traps")
TDS:Upgrade(2)
TDS:Upgrade(2)
--
TDS:Upgrade(2)
TDS:SetOption(2, "Trap", "Landmine")
TDS:Upgrade(3)
TDS:Upgrade(3)
--
TDS:Upgrade(3)
--
TDS:SetOption(3, "Trap", "Bear Traps")
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:SetOption(7, "Trap", "Landmine")
TDS:Upgrade(7)

-- [ Wave 35 ] --
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
--(11, 3)
--(11, 6)
--
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:SetOption(9, "Trap", "Landmine")
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:SetOption(8, "Trap", "Landmine")
--
--
--
--(11, 3)
--(11, 6)
--
--
--
--
--
--
TDS:Upgrade(8)
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
TDS:VoteSkip(35)
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
--

-- [ Wave 37 ] --
--
--
--
--
--
--
--
--
--(11, 3)
--(11, 6)
--
TDS:SetOption(5, "Track", "Red")
--
--
--
--(11, 3)
--(11, 6)
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

-- [ Wave 38 ] --
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

-- [ Wave 39 ] --
--
--
--
--
--
--
--
--
--(11, 3)
--(11, 6)
--
--
--
--
--
--
--(11, 3)
--(11, 6)
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
