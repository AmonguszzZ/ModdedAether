local TDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/auto-strat/refs/heads/main/Library.lua"))()

getgenv().AutoMedic = true
getgenv().AutoMercenary = true
getgenv().AutoDJ  = true
getgenv().AutoGatling = true

getgenv().AutoSkip = false
getgenv().AutoReady = false
getgenv().AutoRejoin = false
getgenv().AutoRestart = false

TDS:Loadout("DJ Booth", "Gatling Gun", "Militant", "Mercenary Base", "Medic")
TDS:Mode("Trial")

TDS:Place("Militant", -16.196304321289062, 0.6511633396148682, 1.5852184295654297)
TDS:Ready()

-- [ Wave 1 ] --
TDS:VoteSkip(1)
TDS:Upgrade(1)

-- [ Wave 2 ] --
TDS:Place("Militant", -22.14517593383789, 1.3860831260681152, 0.2201681137084961)

-- [ Wave 3 ] --
TDS:Upgrade(2)

-- [ Wave 4 ] --
TDS:Place("Militant", -16.679758071899414, 0.5955659747123718, -1.4315614700317383)
TDS:Upgrade(3)

-- [ Wave 6 ] --
TDS:Upgrade(1)
TDS:Upgrade(3)
TDS:VoteSkip(6)
TDS:Upgrade(2)

-- [ Wave 7 ] --
TDS:VoteSkip(7)

-- [ Wave 8 ] --
TDS:VoteSkip(8)

-- [ Wave 9 ] --
TDS:VoteSkip(9)

-- [ Wave 10 ] --
TDS:WaitForWave(10)
TDS:Sell(2)
TDS:Place("Gatling Gun", -3.8105545043945312, 1.3700664043426514, -7.77010440826416)
TDS:Place("DJ Booth", -16.69303321838379, 0.5284262895584106, -5.753522872924805)
TDS:Upgrade(5)
TDS:SetOption(5, "Track", "Green")
TDS:Upgrade(5)

-- [ Wave 12 ] --
TDS:Upgrade(4)
TDS:Place("Militant", -13.342079162597656, 0.3624768853187561, 2.5549135208129883)
TDS:Place("Militant", -22.161588668823242, 1.4488210678100586, -0.4254932403564453)
TDS:Place("Militant", -22.010841369628906, 1.1506661176681519, 2.606931686401367)
TDS:VoteSkip(12)
TDS:Upgrade(5)

-- [ Wave 13 ] --
TDS:VoteSkip(13)

-- [ Wave 14 ] --
TDS:Upgrade(4)
TDS:Place("Militant", -22.374635696411133, 1.5832172632217407, -3.510587215423584)
TDS:Place("Militant", -20.234485626220703, 0.8279872536659241, 5.681711196899414)
TDS:Place("Militant", -17.89271354675293, 0.6120879054069519, 7.638136863708496)
TDS:Place("Militant", -14.767660140991211, 0.40321141481399536, 8.197816848754883)

-- [ Wave 16 ] --
TDS:Upgrade(5)
TDS:Place("Militant", -11.419958114624023, 0.17462563514709473, 8.738801956176758)
TDS:Place("Militant", -10.3313570022583, 0.3537454605102539, 2.8173351287841797)
TDS:Place("Medic", -8.212831497192383, 0.572066068649292, 0.3011798858642578)
TDS:Place("Medic", -7.6226806640625, 0.9731134176254272, -2.9659156799316406)
TDS:Place("Medic", -7.258275985717773, 1.2296971082687378, -6.100778579711914)
TDS:Place("Medic", -6.143064498901367, 1.4535504579544067, -10.571264266967773)

-- [ Wave 20 ] --
TDS:Upgrade(5)
TDS:Upgrade(4)

-- [ Wave 22 ] --
TDS:Upgrade(4)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(18)
TDS:Upgrade(18)
TDS:Upgrade(18)

-- [ Wave 23 ] --
--(15, 4)
--
--(15, 4)
--(16, 4)
--

-- [ Wave 24 ] --
--(16, 4)
--(17, 4)
--
--(17, 4)
--(18, 4)
--
--(18, 4)
--(15, 4)

-- [ Wave 25 ] --
TDS:Upgrade(4)

-- [ Wave 26 ] --
--
--(15, 4)
--(16, 4)
--
--(16, 4)
--(17, 4)
--
--(17, 4)
--(18, 4)
--

-- [ Wave 27 ] --
--(18, 4)
--(15, 4)
TDS:Upgrade(4)

-- [ Wave 28 ] --
--

-- [ Wave 29 ] --
--(15, 4)
--(16, 4)
--
--(16, 4)
--(17, 4)
--
--(17, 4)
--(18, 4)
--

-- [ Wave 30 ] --
--(18, 4)
--(15, 4)

-- [ Wave 31 ] --
--
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(18)
--(15, 4)
TDS:Upgrade(18)
--(16, 4)
--
TDS:Place("Mercenary Base", -2.106975555419922, 0.18996375799179077, 3.2811965942382812)
TDS:Place("Mercenary Base", -1.0903911590576172, 0.5436539053916931, -1.7742481231689453)
--(16, 4)
--(17, 4)
--
TDS:Place("Mercenary Base", 2.1996707916259766, 0.8083216547966003, -5.378485679626465)
TDS:Upgrade(21)

-- [ Wave 32 ] --
TDS:Upgrade(21)
TDS:Upgrade(21)
TDS:Upgrade(21)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(20)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(19)
--(17, 4)
--(18, 4)
--
TDS:SetOption(19, "Unit 3", "Riot Guard")
TDS:SetOption(19, "Unit 2", "Riot Guard")
TDS:SetOption(20, "Unit 2", "Grenadier")
TDS:SetOption(20, "Unit 3", "Riot Guard")
TDS:SetOption(21, "Unit 2", "Grenadier")
TDS:SetOption(21, "Unit 3", "Riot Guard")
--(18, 4)
--(15, 4)
TDS:Upgrade(21)
--
TDS:Upgrade(21)
TDS:Upgrade(20)
--

-- [ Wave 33 ] --
TDS:Upgrade(20)
TDS:Upgrade(19)
--
--
--(15, 4)
--(16, 4)
--
TDS:Upgrade(19)
--(16, 4)
--(17, 4)
--
--(18, 17)
--(18, 4)
--(18, 4)

-- [ Wave 34 ] --
--(17, 4)
--(18, 4)
--
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
--
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(6)
--
TDS:Upgrade(1)
--(18, 4)
--(15, 4)
TDS:Upgrade(1)
--
--
TDS:Upgrade(3)
TDS:Upgrade(3)

-- [ Wave 35 ] --
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
--(15, 4)
TDS:Upgrade(8)
--(16, 4)
--
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
--(16, 4)
--(17, 4)
--
TDS:Upgrade(12)
TDS:Upgrade(13)
--
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
--(17, 4)
--
--(18, 4)
--
--(18, 4)
--(15, 4)
--

-- [ Wave 36 ] --
--

-- [ Wave 37 ] --
--(15, 4)
--(16, 4)
--
--
--(16, 4)
--(17, 4)
--
--
--(17, 4)
--(18, 4)
--
--
--(18, 4)
--(15, 4)

-- [ Wave 38 ] --
--
--(15, 4)
--
--(16, 4)
--
--

-- [ Wave 39 ] --
--(16, 4)
--(17, 4)
--
--
--(17, 4)
--(18, 4)
--

-- [ Wave 40 ] --
--(18, 4)
--(15, 4)
--
--
--
--(15, 4)
--(16, 4)
--
--
--(16, 4)
--(17, 4)
--
--(17, 4)
--(18, 4)
--
--(18, 4)
--(15, 4)
--
--
--
--
--(15, 4)
--(16, 4)
--
--(16, 4)
--(17, 4)
--
--(17, 4)
--(18, 4)
--
--(18, 4)
--(15, 4)
