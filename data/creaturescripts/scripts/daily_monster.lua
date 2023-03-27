function onLogin(cid)
local BOOSTED_MONSTER = 56404
local boostedMonstersList = {"rat", "spider", "troll", "orc", "minotaur", "dwarf", "elf", "skeleton", "amazon", "valkirie", "dark apprentice", "ghoul", "cyclops", "dwarf guard", "necromancer", "vampire", "werewolf", "dragon", "dragon lord", "wyrm", "giant spider", "hydra", "warlock", "demon"}
local boostedMonster = boostedMonstersList[getGlobalStorageValue(BOOSTED_MONSTER)]
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Today's monster boosted is: "..boostedMonster.."!")
return true
end