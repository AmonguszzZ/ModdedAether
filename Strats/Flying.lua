
TDS:Loadout("Hacker", "Gatling Gun", "Militant", "Mercenary Base", "DJ Booth")
TDS:Mode("Trial")


TDS:Place("Militant", -8.568724632263184, 0.400004506111145, -14.020751953125)
TDS:Ready()
-- [ Wave 1 ] --
TDS:Upgrade(1)

-- [ Wave 2 ] --
TDS:Place("Militant", -6.670487403869629, 0.4000064730644226, -16.346250534057617)

-- [ Wave 3 ] --
TDS:Upgrade(2)
TDS:Place("Militant", -11.495475769042969, 0.40000441670417786, -13.283121109008789)

-- [ Wave 4 ] --
TDS:Upgrade(3)

-- [ Wave 5 ] --
TDS:Place("Militant", -10.564520835876465, 0.40000665187835693, -16.313037872314453)
TDS:Upgrade(4)

-- [ Wave 7 ] --
TDS:VoteSkip(7)

-- [ Wave 8 ] --
TDS:WaitForWave(8)
TDS:Sell(2)
TDS:Sell(4)
TDS:Sell(1)
TDS:Sell(3)
TDS:VoteSkip(8)
TDS:Place("Gatling Gun", 9.519998550415039, 1.6807754039764404, -24.630443572998047)

-- [ Wave 9 ] --
TDS:Upgrade(5)

-- [ Wave 12 ] --
TDS:Upgrade(5)

-- [ Wave 15 ] --
TDS:Upgrade(5)
TDS:Place("DJ Booth", 2.7790544033050537, 0.4000016450881958, -16.425376892089844)
TDS:Upgrade(6)
TDS:Upgrade(6)

-- [ Wave 16 ] --
TDS:SetOption(6, "Track", "Green")
TDS:Upgrade(6)

-- [ Wave 18 ] --
TDS:Upgrade(6)

-- [ Wave 19 ] --
TDS:Upgrade(6)

-- [ Wave 22 ] --
TDS:Upgrade(5)

-- [ Wave 24 ] --
TDS:Upgrade(5)

-- [ Wave 27 ] --
TDS:Upgrade(5)
TDS:Place("Mercenary Base", 6.662245750427246, 0.4000079929828644, -20.898029327392578)

-- [ Wave 28 ] --
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:SetOption(8, "Unit 1", "Rifleman")
TDS:SetOption(8, "Unit 2", "Rifleman")
TDS:SetOption(8, "Unit 3", "Rifleman")
TDS:Upgrade(8)
TDS:Upgrade(8)
TDS:SetOption(6, "Track", "Red")

-- [ Wave 29 ] --
TDS:Place("Mercenary Base", 33.77254867553711, 0.3999965786933899, -6.123828887939453)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)
TDS:Upgrade(9)

-- [ Wave 30 ] --
TDS:Upgrade(9)

-- [ Wave 31 ] --
TDS:Upgrade(9)
TDS:Place("Mercenary Base", 27.39444923400879, 0.3999958038330078, -6.726582050323486)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Upgrade(10)

-- [ Wave 32 ] --
TDS:Upgrade(10)
TDS:Upgrade(10)

-- [ Wave 33 ] --
TDS:Place("Hacker", 33.205448150634766, 0.39999258518218994, 21.003557205200195)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)
TDS:Upgrade(11)

-- [ Wave 34 ] --
TDS:Upgrade(11, 2)

-- [ Wave 35 ] --


-- [ Wave 36 ] --
TDS:Ability(11, "Hologram Tower", {towerPosition = Vector3.new(6.341592311859131, 1.6807842254638672, -27.144189834594727), towerToClone = 5}, true)
