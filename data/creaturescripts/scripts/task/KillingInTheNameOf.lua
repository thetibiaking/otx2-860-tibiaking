local questCreatures =
{
	["troll"] = {questStarted = 1510, questStorage = 65000, creatureStorage = 15000, killsRequired = 100, raceName = "Trolls"},
	["frost troll"] = {questStarted = 1510, questStorage = 65000, creatureStorage = 15001, killsRequired = 100, raceName = "Trolls"},
	["furious troll"] = {questStarted = 1510, questStorage = 65000, creatureStorage = 15002, killsRequired = 100, raceName = "Trolls"},
	["island troll"] = {questStarted = 1510, questStorage = 65000, creatureStorage = 15003, killsRequired = 100, raceName = "Trolls"},
	["swamp troll"] = {questStarted = 1510, questStorage = 65000, creatureStorage = 15004, killsRequired = 100, raceName = "Trolls"},
	["troll champion"] = {questStarted = 1510, questStorage = 65000, creatureStorage = 15005, killsRequired = 100, raceName = "Trolls"},
	["troll legionnaire"] = {questStarted = 1510, questStorage = 65000, creatureStorage = 15006, killsRequired = 100, raceName = "Trolls"},
	["goblin"] = {questStarted = 1511, questStorage = 65001, creatureStorage = 15007, killsRequired = 150, raceName = "Goblins"},
	["goblin assassin"] = {questStarted = 1511, questStorage = 65001, creatureStorage = 15008, killsRequired = 150, raceName = "Goblins"},
	["goblin leader"] = {questStarted = 1511, questStorage = 65001, creatureStorage = 15009, killsRequired = 150, raceName = "Goblins"},
	["goblin scavenger"] = {questStarted = 1511, questStorage = 65001, creatureStorage = 15010, killsRequired = 150, raceName = "Goblins"},
	["rotworm"] = {questStarted = 1512, questStorage = 65002, creatureStorage = 15011, killsRequired = 300, raceName = "Rotworms"},
	["carrion worm"] = {questStarted = 1512, questStorage = 65002, creatureStorage = 15012, killsRequired = 300, raceName = "Rotworms"},
	["cyclops"] = {questStarted = 1513, questStorage = 65003, creatureStorage = 15013, killsRequired = 500, raceName = "Cyclops"},
	["cyclops smith"] = {questStarted = 1513, questStorage = 65003, creatureStorage = 15014, killsRequired = 500, raceName = "Cyclops"},
	["cyclops drone"] = {questStarted = 1513, questStorage = 65003, creatureStorage = 15015, killsRequired = 500, raceName = "Cyclops"},
	["crocodile"] = {questStarted = 1514, questStorage = 65004, creatureStorage = 15016, killsRequired = 300, raceName = "Crocodiles"},
	["tarantula"] = {questStarted = 1515, questStorage = 65005, creatureStorage = 15017, killsRequired = 300, raceName = "Tarantulas"},
	["carniphila"] = {questStarted = 1516, questStorage = 65006, creatureStorage = 15018, killsRequired = 400, raceName = "Carniphilas"},
	["stone golem"] = {questStarted = 1517, questStorage = 65007, creatureStorage = 15019, killsRequired = 200, raceName = "Stone Golems"},
	["mammoth"] = {questStarted = 1518, questStorage = 65008, creatureStorage = 15020, killsRequired = 300, raceName = "Mammoths"},
	["ice golem"] = {questStarted = 1519, questStorage = 65009, creatureStorage = 15021, killsRequired = 300, raceName = "Ice Golems"},
	["quara predator scout"] = {questStarted = 1520, questStorage = 65010, creatureStorage = 15022, killsRequired = 300, raceName = "Quaras Scout"},
	["quara constrictor scout"] = {questStarted = 1520, questStorage = 65010, creatureStorage = 15023, killsRequired = 300, raceName = "Quaras Scout"},
	["quara hydromancer scout"] = {questStarted = 1520, questStorage = 65010, creatureStorage = 15024, killsRequired = 300, raceName = "Quaras Scout"},
	["quara mantassin scout"] = {questStarted = 1520, questStorage = 65010, creatureStorage = 15025, killsRequired = 300, raceName = "Quaras Scout"},
	["quara pincher scout"] = {questStarted = 1520, questStorage = 65010, creatureStorage = 15026, killsRequired = 300, raceName = "Quaras Scout"},
	["quara predator"] = {questStarted = 1521, questStorage = 65011, creatureStorage = 15027, killsRequired = 300, raceName = "Quaras"},
	["quara constrictor"] = {questStarted = 1521, questStorage = 65011, creatureStorage = 15028, killsRequired = 300, raceName = "Quaras"},
	["quara hydromancer"] = {questStarted = 1521, questStorage = 65011, creatureStorage = 15029, killsRequired = 300, raceName = "Quaras"},
	["quara mantassin"] = {questStarted = 1521, questStorage = 65011, creatureStorage = 15030, killsRequired = 300, raceName = "Quaras"},
	["quara pincher"] = {questStarted = 1521, questStorage = 65011, creatureStorage = 15031, killsRequired = 300, raceName = "Quaras"},
	["water elemental"] = {questStarted = 1522, questStorage = 65012, creatureStorage = 15032, killsRequired = 70, raceName = "Water Elementals"},
	["roaring water elemental"] = {questStarted = 1522, questStorage = 65012, creatureStorage = 15033, killsRequired = 70, raceName = "Water Elementals"},
	["slick water elemental"] = {questStarted = 1522, questStorage = 65012, creatureStorage = 15034, killsRequired = 70, raceName = "Water Elementals"},
	["massive water elemental"] = {questStarted = 1522, questStorage = 65012, creatureStorage = 15035, killsRequired = 70, raceName = "Water Elementals"},
	["earth elemental"] = {questStarted = 1523, questStorage = 65013, creatureStorage = 15036, killsRequired = 70, raceName = "Earth Elementals"},
	["jagged earth elemental"] = {questStarted = 1523, questStorage = 65013, creatureStorage = 15037, killsRequired = 70, raceName = "Earth Elementals"},
	["massive earth elemental"] = {questStarted = 1523, questStorage = 65013, creatureStorage = 15038, killsRequired = 70, raceName = "Earth Elementals"},
	["muddy earth elemental"] = {questStarted = 1523, questStorage = 65013, creatureStorage = 15039, killsRequired = 70, raceName = "Earth Elementals"},
	["energy elemental"] = {questStarted = 1524, questStorage = 65014, creatureStorage = 15040, killsRequired = 70, raceName = "Energy Elementals"},
	["charged energy elemental"] = {questStarted = 1524, questStorage = 65014, creatureStorage = 15041, killsRequired = 70, raceName = "Energy Elementals"},
	["massive energy elemental"] = {questStarted = 1524, questStorage = 65014, creatureStorage = 15042, killsRequired = 70, raceName = "Energy Elementals"},
	["overcharged energy elemental"] = {questStarted = 1524, questStorage = 65014, creatureStorage = 15043, killsRequired = 70, raceName = "Energy Elementals"},
	["fire elemental"] = {questStarted = 1525, questStorage = 65015, creatureStorage = 15044, killsRequired = 70, raceName = "Fire Elementals"},
	["blazing fire elemental"] = {questStarted = 1525, questStorage = 65015, creatureStorage = 15045, killsRequired = 70, raceName = "Fire Elementals"},
	["blistering fire elemental"] = {questStarted = 1525, questStorage = 65015, creatureStorage = 15046, killsRequired = 70, raceName = "Fire Elementals"},
	["massive fire elemental"] = {questStarted = 1525, questStorage = 65015, creatureStorage = 15047, killsRequired = 70, raceName = "Fire Elementals"},
	["mutated rat"] = {questStarted = 1526, questStorage = 65016, creatureStorage = 15048, killsRequired = 200, raceName = "Mutated Rats"},
	["giant spider"] = {questStarted = 1527, questStorage = 65017, creatureStorage = 15049, killsRequired = 500, raceName = "Giant Spiders"},
	["hydra"] = {questStarted = 1528, questStorage = 65018, creatureStorage = 15050, killsRequired = 10000, raceName = "Hydras"},
	["sea serpent"] = {questStarted = 1529, questStorage = 65019, creatureStorage = 15051, killsRequired = 2000, raceName = "Sea Serpents"},
	["behemoth"] = {questStarted = 1530, questStorage = 65020, creatureStorage = 15052, killsRequired = 2000, raceName = "Behemoths"},
	["serpent spawn"] = {questStarted = 1531, questStorage = 65021, creatureStorage = 15053, killsRequired = 7000, raceName = "Serpents Spawn"},
	["green djinn"] = {questStarted = 1532, questStorage = 65022, creatureStorage = 15054, killsRequired = 500, raceName = "Green Djinns"},
	["efreet"] = {questStarted = 1532, questStorage = 65022, creatureStorage = 15055, killsRequired = 500, raceName = "Green Djinns"},
	["blue djinn"] = {questStarted = 1533, questStorage = 65023, creatureStorage = 15056, killsRequired = 500, raceName = "Blue Djinns"},
	["marid"] = {questStarted = 1533, questStorage = 65023, creatureStorage = 15057, killsRequired = 500, raceName = "Blue Djinns"},
	["pirate buccaneer"] = {questStarted = 1534, questStorage = 65024, creatureStorage = 15058, killsRequired = 10000, raceName = "Pirates"},
	["pirate corsair"] = {questStarted = 1534, questStorage = 65024, creatureStorage = 15059, killsRequired = 10000, raceName = "Pirates"},
	["pirate cutthroat"] = {questStarted = 1534, questStorage = 65024, creatureStorage = 15060, killsRequired = 10000, raceName = "Pirates"},
	["pirate ghost"] = {questStarted = 1534, questStorage = 65024, creatureStorage = 15061, killsRequired = 10000, raceName = "Pirates"},
	["pirate marauder"] = {questStarted = 1534, questStorage = 65024, creatureStorage = 15062, killsRequired = 10000, raceName = "Pirates"},
	["pirate skeleton"] = {questStarted = 1534, questStorage = 65024, creatureStorage = 15063, killsRequired = 10000, raceName = "Pirates"},
	["dragon"] = {questStarted = 1535, questStorage = 65025, creatureStorage = 15064, killsRequired = 9000, raceName = "Dragons"},
	["dragon lord"] = {questStarted = 1535, questStorage = 65025, creatureStorage = 15065, killsRequired = 9000, raceName = "Dragons"},
	["frost dragon"] = {questStarted = 1535, questStorage = 65025, creatureStorage = 15076, killsRequired = 9000, raceName = "Dragons"},
	["minotaur"] = {questStarted = 1536, questStorage = 65026, creatureStorage = 15068, killsRequired = 10000, raceName = "Minotaurs"},
	["minotaur archer"] = {questStarted = 1536, questStorage = 65026, creatureStorage = 15069, killsRequired = 10000, raceName = "Minotaurs"},
	["minotaur guard"] = {questStarted = 1536, questStorage = 65026, creatureStorage = 15070, killsRequired = 10000, raceName = "Minotaurs"},
	["minotaur mage"] = {questStarted = 1536, questStorage = 65026, creatureStorage = 15071, killsRequired = 10000, raceName = "Minotaurs"},
	["necromancer"] = {questStarted = 1537, questStorage = 65027, creatureStorage = 15072, killsRequired = 9000, raceName = "Necros"},
	["priestess"] = {questStarted = 1537, questStorage = 65027, creatureStorage = 15073, killsRequired = 9000, raceName = "Necros"},
	["demon"] = {questStarted = 1538, questStorage = 65028, creatureStorage = 15074, killsRequired = 6666, raceName = "Demons"},
	["medusa"] = {questStarted = 1539, questStorage = 65029, creatureStorage = 16075, killsRequired = 10000, raceName = "Medusas"},
	["grim reaper"] = {questStarted = 1540, questStorage = 65030, creatureStorage = 16076, killsRequired = 15000, raceName = "Grim Reapers"},
	["nightmare"] = {questStarted = 1541, questStorage = 65031, creatureStorage = 16077, killsRequired = 25000, raceName = "Nightmares"},
	["nightmare scion"] = {questStarted = 1541, questStorage = 65031, creatureStorage = 16083, killsRequired = 25000, raceName = "Nightmares"},
	["lizard chosen"] = {questStarted = 1542, questStorage = 65032, creatureStorage = 16078, killsRequired = 10000, raceName = "Lizards"},
	["lizard dragon priest"] = {questStarted = 1542, questStorage = 65032, creatureStorage = 16079, killsRequired = 10000, raceName = "Lizards"},
	["lizard high guard"] = {questStarted = 1542, questStorage = 65032, creatureStorage = 16080, killsRequired = 10000, raceName = "Lizards"},
	["lizard legionnaire"] = {questStarted = 1542, questStorage = 65032, creatureStorage = 16081, killsRequired = 10000, raceName = "Lizards"},
	["lizard zaogun"] = {questStarted = 1542, questStorage = 65032, creatureStorage = 16082, killsRequired = 10000, raceName = "Lizards"},

}

function onKill(cid, target, lastHit)
	local creature = questCreatures[string.lower(getCreatureName(target))]
	if creature then
		if(isPlayer(target) == true) then
			return true
		end
		local QuestStarted = getPlayerStorageValue(cid, creature.questStarted)
		if QuestStarted > 0 then
			if getPlayerStorageValue(cid, creature.questStorage) < creature.killsRequired then
				local QuestStorage = getPlayerStorageValue(cid, creature.questStorage)
				if QuestStorage < 0 then
					doPlayerSetStorageValue(cid, creature.questStorage, 1)
				else
					doPlayerSetStorageValue(cid, creature.questStorage, QuestStorage + 1)
				end
				local CreatureStorage = getPlayerStorageValue(cid, creature.creatureStorage)
				if CreatureStorage < 0 then
					doPlayerSetStorageValue(cid, creature.creatureStorage, 1)
				else
					doPlayerSetStorageValue(cid, creature.creatureStorage, CreatureStorage + 1)
				end
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "" .. CreatureStorage .. " " .. getCreatureName(target) .. " defeated. Total [" .. QuestStorage .. "/" .. creature.killsRequired .. "] " .. creature.raceName .. ".")
			end
		end
	end
	return true
end