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

TDS:Loadout("Trapper", "Medic", "Gatling Gun", "Tesla", "Hacker")
TDS:Mode("Trial")

TDS:Place("Trapper", -12.889202117919922, 0.9999653100967407, -4.010560512542725)
TDS:Ready()

-- [ Wave 1 ] --
TDS:Upgrade(1)

-- [ Wave 3 ] --
TDS:Place("Trapper", -15.789953231811523, 0.9999642372131348, -2.4152495861053467)

-- [ Wave 4 ] --
TDS:Upgrade(2)
TDS:Place("Trapper", -16.8074893951416, 0.9999620914459229, 0.5615583658218384)
TDS:Upgrade(3)

-- [ Wave 5 ] --
TDS:SetTarget(1, "Last")
TDS:SetTarget(1, "Strongest")
TDS:SetTarget(1, "Weakest")
TDS:SetTarget(1, "Closest")
TDS:Upgrade(1)
TDS:SetOption(1, "Trap", "Landmine")

-- [ Wave 8 ] --

-- [ Wave 9 ] --
TDS:Place("Gatling Gun", 26.730873107910156, 3.5999791622161865, 9.862312316894531)
TDS:VoteSkip(9)

-- [ Wave 10 ] --
TDS:Upgrade(4)

-- [ Wave 11 ] --
TDS:Place("Hacker", -3.3476505279541016, 0.999939501285553, 32.90883255004883)
TDS:Upgrade(5)
TDS:Place("Hacker", 11.938796997070312, 0.999943733215332, 26.88080406188965)
TDS:Upgrade(6)
TDS:SetTarget(6, "Last")
TDS:Upgrade(6)
TDS:Upgrade(5)

-- [ Wave 12 ] --
TDS:VoteSkip(12)

-- [ Wave 13 ] --
TDS:VoteSkip(13)
TDS:Upgrade(4)

-- [ Wave 15 ] --
TDS:Place("Tesla", 3.5708751678466797, 3.59997820854187, 17.480335235595703)
TDS:Place("Tesla", -1.6147675514221191, 3.6000001430511475, -1.0011186599731445)

-- [ Wave 16 ] --
TDS:Upgrade(4)

-- [ Wave 17 ] --
TDS:Upgrade(7)
TDS:Upgrade(8)

-- [ Wave 20 ] --
TDS:Upgrade(4)

-- [ Wave 22 ] --
TDS:Place("Medic", 24.685380935668945, 3.599979877471924, 6.5185227394104)
TDS:Place("Medic", 21.898469924926758, 3.599979877471924, 5.257613182067871)
TDS:Place("Medic", 24.521276473999023, 3.599979877471924, 3.5142316818237305)
TDS:Place("Medic", 27.736936569213867, 3.599999189376831, 5.161745548248291)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)

-- [ Wave 23 ] --
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(12)
TDS:Upgrade(12)
TDS:Upgrade(12)

-- [ Wave 24 ] --
TDS:Upgrade(4)

-- [ Wave 28 ] --
TDS:Upgrade(4)
TDS:Upgrade(7)
TDS:Upgrade(8)

-- [ Wave 29 ] --
TDS:Upgrade(6)
TDS:Upgrade(6)
TDS:Upgrade(5)

-- [ Wave 30 ] --
TDS:Upgrade(5)
TDS:Place("Trapper", 20.75980567932129, 0.9999528527259827, 13.821240425109863)

-- [ Wave 31 ] --
TDS:Place("Trapper", 21.566415786743164, 0.9999504685401917, 17.205366134643555)
TDS:Place("Trapper", 17.797607421875, 0.9999533891677856, 13.078210830688477)
TDS:Place("Trapper", 20.784488677978516, 0.9999570250511169, 7.848598003387451)
TDS:MedicSelect(9, 15)
TDS:MedicSelect(9, 15)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:Upgrade(16)
TDS:SetOption(16, "Trap", "Bear Traps")
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:Upgrade(15)
TDS:SetOption(15, "Trap", "Landmine")
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:SetOption(13, "Trap", "Bear Traps")

-- [ Wave 32 ] --
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:Upgrade(14)
TDS:SetOption(14, "Trap", "Landmine")
TDS:Ability(6, "Hologram Tower")
TDS:Upgrade(2)
TDS:Upgrade(2)
TDS:Upgrade(2)
TDS:SetOption(2, "Trap", "Bear Traps")
TDS:Upgrade(3)
TDS:Upgrade(3)
TDS:Upgrade(3)

-- [ Wave 33 ] --
TDS:SetOption(3, "Trap", "Bear Traps")
TDS:Upgrade(1)
TDS:Upgrade(1)
TDS:SetOption(1, "Trap", "Bear Traps")
TDS:Upgrade(7)
TDS:Upgrade(8)
TDS:VoteSkip(33)

-- [ Wave 34 ] --
TDS:Ability(6, "Hologram Tower", {towerPosition = Vector3.new(17.28837013244629, 0.9999579191207886, 6.612399101257324), towerToClone = 4}, true)
TDS:Upgrade(7)

-- [ Wave 35 ] --
TDS:Upgrade(8)
TDS:Ability(5, "Hologram Tower", {towerPosition = Vector3.new(17.152769088745117, 0.9999580383300781, 6.425708770751953), towerToClone = 4}, true)
TDS:VoteSkip(35)

-- [ Wave 36 ] --
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:MedicSelect(9, 10)
TDS:MedicSelect(9, 10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(12)
TDS:Upgrade(12)

-- [ Wave 37 ] --
TDS:Ability(5, "Hologram Tower", {towerPosition = Vector3.new(16.987476348876953, 0.999957799911499, 6.6809587478637695), towerToClone = 4}, true)
TDS:Ability(6, "Hologram Tower", {towerPosition = Vector3.new(16.987476348876953, 0.999957799911499, 6.6809587478637695), towerToClone = 4}, true)

TDS:VoteSkip(37)
TDS:WaitForWave(40)
TDS:Upgrade(5, 2)
TDS:Upgrade(6, 2)
