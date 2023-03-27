--Config--
local starting = {x = 32778, y = 31160, z = 10, stackpos = 253} -- Top Left of the Final Room
local ending = {x = 32788, y = 31172, z = 10, stackpos = 253} -- Bottom Right of the Final Romm
local checking = {x = starting.x, y = starting.y, z = starting.z, stackpos = starting.stackpos} -- Don't touch
local player_pos_entrada = {x = 32783, y = 31173, z = 10} -- Where player spawns when entering the tp to the final room
local storageID = 10510 --Storage ID, used for the door to the reward room
local canBeEnteredAgain = false -- Can you enter the place where you defeat Azerus many times? true/false
--End Config--

function onStepIn(cid, item, position, fromPosition)
local queststatus = getPlayerStorageValue(cid, storageID) 

if item.actionid == 1974 and queststatus == -1 then
doCreatureSay(cid, "It seems by defeating Azerus you have stopprd this army from entering your world! Better leave this ghastly place forever.", TALKTYPE_ORANGE_1)
setPlayerStorageValue(cid, storageID, 1)
return TRUE
end

if item.actionid == 1973 and (queststatus == -1 or canBeEnteredAgain) then
totalmonsters = 0
monster = {}
repeat
creature = getThingfromPos(checking)
if creature.itemid > 0 then
if getPlayerAccess(creature.uid) ~= 0 and getPlayerAccess(creature.uid) ~= 3 then
totalmonsters = totalmonsters + 1
monster[totalmonsters] = creature.uid
end
end

checking.x = checking.x + 1

if checking.x > ending.x then
checking.x = starting.x
checking.y = checking.y + 1
end

until checking.y > ending.y

if totalmonsters ~= 0 then
current = 0
repeat
current = current + 1
doRemoveCreature(monster[current])
until current >= totalmonsters
end

doTeleportThing(cid, player_pos_entrada)
doSendMagicEffect(player_pos_entrada, 10)

else
doTeleportThing(cid, fromPosition, false)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, 'You have already defeated Azerus, and decided to stay out of this haunted place.')
end
end