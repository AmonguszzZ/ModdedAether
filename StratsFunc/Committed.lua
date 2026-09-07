local TDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/auto-strat/refs/heads/main/Library.lua"))()

getgenv().AutoMedic = true
getgenv().AutoMercenary = true
getgenv().AutoDJ  = true
getgenv().AutoGatling = true

getgenv().AutoSkip = false
getgenv().AutoReady = false
getgenv().AutoRejoin = true
getgenv().AutoRestart = false

TDS:Loadout("Hacker", "Demoman", "Gatling Gun", "Scout", "Medic")
TDS:Mode("Trial")

TDS:Place("Scout", -60.45513153076172, 30.365568161010742, -50.352481842041016)
TDS:Place("Scout", -66.44859313964844, 30.86126708984375, -26.16475486755371)
TDS:Place("Scout", -60.73588562011719, 30.36585807800293, -53.430694580078125)
TDS:Ready()

-- [ Wave 1 ] --
TDS:Place("Scout", -64.09095764160156, 30.86126708984375, -24.255138397216797)

-- [ Wave 2 ] --
TDS:Place("Scout", -67.10609436035156, 30.861265182495117, -23.04651641845703)
TDS:Place("Scout", -63.3083381652832, 30.3743953704834, -51.60470962524414)
TDS:Upgrade(5)

-- [ Wave 3 ] --
TDS:Upgrade(1)

-- [ Wave 4 ] --
TDS:Upgrade(3)
TDS:Upgrade(6)
TDS:Upgrade(4)
TDS:Upgrade(2)

-- [ Wave 5 ] --
TDS:Place("Demoman", -63.62447738647461, 30.37480354309082, -54.65185546875)
TDS:Upgrade(7)
TDS:Place("Demoman", -61.06065368652344, 30.86126708984375, -24.840248107910156)
TDS:Upgrade(8)
TDS:SetTarget(8, "Last")
TDS:SetTarget(8, "Strongest")
TDS:SetTarget(8, "Weakest")
TDS:SetTarget(8, "Closest")
TDS:SetTarget(7, "Last")
TDS:SetTarget(7, "Strongest")
TDS:SetTarget(7, "Strongest")
TDS:SetTarget(7, "Weakest")

-- [ Wave 6 ] --
TDS:SetTarget(7, "Weakest")
TDS:SetTarget(7, "Closest")
TDS:SetTarget(7, "Closest")
TDS:Upgrade(2)
TDS:Upgrade(1)

-- [ Wave 7 ] --
TDS:Upgrade(6)
TDS:Upgrade(4)

-- [ Wave 9 ] --
TDS:Place("Gatling Gun", -12.217018127441406, 30.361268997192383, -40.15315628051758)
TDS:Upgrade(9)

-- [ Wave 11 ] --
TDS:Upgrade(9)

-- [ Wave 13 ] --
TDS:Place("Hacker", -63.360801696777344, 30.880165100097656, -1.6265745162963867)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Place("Hacker", -57.653839111328125, 30.36127281188965, -70.3486557006836)
TDS:Upgrade(11)
TDS:Upgrade(11)

-- [ Wave 14 ] --
TDS:Upgrade(9)

-- [ Wave 17 ] --
TDS:Upgrade(9)

-- [ Wave 18 ] --
TDS:Place("Medic", -15.898829460144043, 30.361268997192383, -39.446495056152344)
TDS:Place("Medic", -18.991344451904297, 30.36126708984375, -38.99420928955078)

-- [ Wave 19 ] --
TDS:Place("Medic", -24.289274215698242, 30.38188934326172, -44.53237533569336)
TDS:Place("Medic", -27.489103317260742, 30.36641502380371, -44.95125961303711)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
--(12, 9)
--

-- [ Wave 20 ] --
--(12, 9)
--(13, 9)
--
TDS:Upgrade(4)
TDS:Upgrade(4)
TDS:Upgrade(2)
TDS:Upgrade(2)
TDS:Upgrade(5)
TDS:Upgrade(5)
TDS:Upgrade(5)
--(13, 9)
--(14, 9)
--
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:Upgrade(6)
TDS:Upgrade(6)
--(14, 9)
--(15, 9)
--
TDS:Upgrade(1)
TDS:Upgrade(1)
--(15, 9)
--(12, 9)

-- [ Wave 21 ] --
--
--(12, 9)
--(13, 9)
--
TDS:Upgrade(11)

-- [ Wave 22 ] --
--(13, 9)
--(14, 9)
TDS:Upgrade(10)
--
--(14, 9)
--(15, 9)
--
TDS:Upgrade(11)
--(15, 9)
--(12, 9)
TDS:Upgrade(10)
--(14, 15)

-- [ Wave 23 ] --
--
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(-13.144805908203125, 30.361268997192383, -45.428131103515625), towerToClone = 9}, true)
--(12, 9)
--(13, 9)
--
--(13, 9)
--(14, 9)
--

-- [ Wave 24 ] --
--(14, 9)
--(15, 9)
--
--(15, 9)
--(12, 9)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(7)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Ability(10, "Hologram Tower", {towerPosition = Vector3.new(-12.953612327575684, 30.361268997192383, -45.12579345703125), towerToClone = 9}, true)

-- [ Wave 25 ] --
--(12, 9)
--(13, 9)
--

-- [ Wave 26 ] --
--(13, 9)
--(14, 9)
--
--(14, 9)
--(15, 9)
--
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(-13.359004974365234, 30.361268997192383, -45.659507751464844), towerToClone = 9})
--(15, 9)
--(12, 9)
--
--(12, 9)
--(13, 9)

-- [ Wave 27 ] --
--
TDS:Upgrade(9)
TDS:Upgrade(9)
--(13, 9)
--(14, 9)
--

-- [ Wave 28 ] --
--(14, 9)
--(15, 9)
--

-- [ Wave 29 ] --
--(15, 9)
--(12, 9)
--
--(12, 13)
--(12, 9)
--(13, 9)
--

-- [ Wave 30 ] --
--(13, 9)
--(14, 9)
--
--(14, 9)
--(15, 9)
--
TDS:Upgrade(11, 2)
--(15, 9)
--(12, 9)

-- [ Wave 31 ] --
--
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(-12.425029754638672, 30.361268997192383, -45.10478973388672), towerToClone = 9})
--(12, 9)
--(13, 9)
TDS:Upgrade(10, 2)
TDS:Place("Demoman", -61.04015350341797, 30.366230010986328, -56.461029052734375)
TDS:Place("Demoman", -66.10714721679688, 30.383066177368164, -52.77477264404297)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
--(13, 9)
--(14, 9)
TDS:Place("Demoman", -62.07223892211914, 30.861265182495117, -21.877708435058594)
TDS:Place("Demoman", -64.88578033447266, 30.861265182495117, -20.76693344116211)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(19)
TDS:Upgrade(18)
TDS:Upgrade(18)
TDS:Upgrade(18)
TDS:Upgrade(18)

-- [ Wave 32 ] --
TDS:Place("Scout", -58.215335845947266, 30.86126136779785, 9.450196266174316)
TDS:Place("Scout", -59.19559860229492, 30.864648818969727, -9.847274780273438)
--
TDS:Place("Scout", -49.41679763793945, 30.861265182495117, -21.963180541992188)
TDS:Place("Scout", -56.104862213134766, 30.861268997192383, -37.28974151611328)
TDS:Place("Scout", -69.20706939697266, 30.861268997192383, -38.22640609741211)
TDS:Place("Scout", -77.611572265625, 30.86126708984375, -30.29711151123047)
TDS:Place("Scout", -88.57150268554688, 30.86126708984375, -32.27619171142578)
--(14, 9)
TDS:Place("Scout", -96.48064422607422, 30.890260696411133, -26.772451400756836)
TDS:Place("Scout", -105.67457580566406, 30.890270233154297, -31.649080276489258)
TDS:Place("Scout", -54.490081787109375, 30.37428855895996, -80.70699310302734)
TDS:Place("Scout", -52.336708068847656, 30.36127281188965, -68.48461151123047)
--(15, 9)
TDS:Place("Scout", -67.31275939941406, 30.384380340576172, -65.62911987304688)
TDS:Place("Scout", -67.36705017089844, 30.386445999145508, -55.96942901611328)
TDS:Place("Scout", -75.5685043334961, 30.366132736206055, -55.001564025878906)
--
TDS:Place("Scout", -71.93292236328125, 30.3760929107666, -43.38590621948242)
TDS:Place("Scout", -57.33953094482422, 30.361268997192383, -41.29188919067383)
--(15, 9)
TDS:Place("Scout", -49.99946975708008, 30.361268997192383, -43.18741226196289)
--(12, 9)
--
TDS:Place("Scout", -35.536293029785156, 30.361268997192383, -37.40185546875)

-- [ Wave 33 ] --
TDS:Place("Scout", -33.391563415527344, 30.361268997192383, -44.03288269042969)
TDS:Place("Scout", -19.21990203857422, 30.37405014038086, -44.312374114990234)
--(12, 9)
TDS:Upgrade(12)
--(13, 9)
TDS:Upgrade(12)
--
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(15)
TDS:Upgrade(15)
--(13, 9)
--(14, 9)
TDS:Place("Demoman", -58.99147033691406, 30.861265182495117, -22.508323669433594)
TDS:Upgrade(40)
TDS:Upgrade(40)
TDS:Upgrade(40)
--
TDS:Upgrade(40)
TDS:Place("Demoman", -62.604339599609375, 30.861265182495117, -18.714094161987305)
TDS:Upgrade(41)
TDS:Upgrade(41)
TDS:Upgrade(41)
TDS:Upgrade(41)
TDS:Place("Demoman", -68.11106872558594, 30.861265182495117, -19.674652099609375)
TDS:Upgrade(42)
TDS:Upgrade(42)
TDS:Upgrade(42)
TDS:Upgrade(42)
TDS:Place("Demoman", -65.71528625488281, 30.861265182495117, -17.51747703552246)
TDS:Upgrade(43)
TDS:Upgrade(43)
TDS:Upgrade(43)
TDS:Upgrade(43)
--(14, 9)
--(15, 9)
TDS:Place("Demoman", -57.72179412841797, 30.36127281188965, -55.01200866699219)
TDS:Upgrade(44)
TDS:Upgrade(44)
TDS:Upgrade(44)
TDS:Upgrade(44)

-- [ Wave 34 ] --
TDS:Place("Demoman", -57.62959671020508, 30.36127281188965, -51.98514938354492)
TDS:Upgrade(45)
TDS:Upgrade(45)
TDS:Upgrade(45)
TDS:Upgrade(45)
--
TDS:Place("Demoman", -57.59933853149414, 30.361268997192383, -48.966365814208984)
TDS:Upgrade(46)
TDS:Upgrade(46)
TDS:Upgrade(46)
TDS:Upgrade(46)
TDS:Place("Demoman", -63.22700500488281, 30.374767303466797, -48.38760757446289)
TDS:Upgrade(47)
TDS:Upgrade(47)
TDS:Upgrade(47)
TDS:Upgrade(47)
--(15, 9)
--(12, 9)
--
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(-13.368343353271484, 30.361268997192383, -46.21827697753906), towerToClone = 9})
--(12, 9)
--(13, 9)
--

-- [ Wave 35 ] --
--(13, 9)
--(14, 9)
--
--(14, 9)
--(15, 9)
--
--(15, 9)
--(12, 9)
--

-- [ Wave 36 ] --
--(12, 9)
--(13, 9)
--
--(13, 9)
--(14, 9)
--

-- [ Wave 37 ] --
--(14, 9)
--(15, 9)
--
--(15, 9)
--(12, 9)
--
--(12, 9)
--(13, 9)

-- [ Wave 38 ] --
--
--(13, 9)
--(14, 9)
--
--(14, 9)
--(15, 9)
--

-- [ Wave 39 ] --
--(15, 9)
--(12, 9)
--
--(12, 9)
--(13, 9)
--

-- [ Wave 40 ] --
--(13, 9)
--(14, 9)
--
--(14, 9)
--(15, 9)
--
--(15, 9)
--(12, 9)
--
--(12, 9)
--(13, 9)
--
--(13, 9)
--(14, 9)
--
--(14, 9)
--(15, 9)
--
--(15, 9)
--(12, 9)
--
--(12, 9)
--(13, 9)
--
--(13, 9)
--(14, 9)
--
--(14, 9)
--(15, 9)
--
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(-13.300681114196777, 30.361268997192383, -45.656005859375), towerToClone = 9}, true)
TDS:Ability(10, "Hologram Tower", {towerPosition = Vector3.new(-13.300681114196777, 30.361268997192383, -45.656005859375), towerToClone = 9}, true)
--(15, 9)
--(12, 9)
--
--(12, 9)
--(13, 9)
--
--(13, 9)
--(14, 9)
