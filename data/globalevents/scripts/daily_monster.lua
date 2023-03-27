function onStartup()
local BOOSTED_MONSTER = 56404
local boostedMonstersList = {"rat", "spider", "troll", "orc", "minotaur", "dwarf", "elf", "skeleton", "amazon", "valkirie", "dark apprentice", "ghoul", "cyclops", "dwarf guard", "necromancer", "vampire", "werewolf", "dragon", "dragon lord", "wyrm", "giant spider", "hydra", "warlock", "demon"}
local randomMonster = math.random(#boostedMonstersList)
setGlobalStorageValue(BOOSTED_MONSTER, randomMonster)
local spawn = {x = 32437, y = 32221, z = 7}  --  monster spawn position
    doCreateMonster(boostedMonstersList[randomMonster], spawn)
    print("Today's boosted monster is: " .. boostedMonstersList[randomMonster])
end