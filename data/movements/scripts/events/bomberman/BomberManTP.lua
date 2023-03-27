local waitingroom = {
    [1] = {x=27102, y=26595, z=7},
    [2] = {x=27103, y=26595, z=7},
    [3] = {x=27104, y=26595, z=7},
    [4] = {x=27102, y=26596, z=7},
    [5] = {x=27103, y=26596, z=7},
    [6] = {x=27104, y=26596, z=7},
    [7] = {x=27102, y=26597, z=7},
    [8] = {x=27103, y=26597, z=7},
    [9] = {x=27104, y=26597, z=7},
}

local t, n, storage = {
	{x=27102, y=26595, z=7},
	{x=27103, y=26595, z=7},
	{x=27104, y=26595, z=7},
	{x=27102, y=26596, z=7},
	{x=27103, y=26596, z=7},
	{x=27104, y=26596, z=7},
    {x=27102, y=26597, z=7},
	{x=27103, y=26597, z=7},
	{x=27104, y=26597, z=7}

}, {
	{x=27068, y=26588, z=7},
	{x=27076, y=26588, z=7},
	{x=26784, y=26588, z=7},
	{x=27068, y=26596, z=7},
	{x=27076, y=26596, z=7},
	{x=26784, y=26596, z=7},
    {x=27068, y=26604, z=7},
	{x=27076, y=26604, z=7},
	{x=26784, y=26604, z=7}
}, {
	placed = 10001,
	max = 10002,
	radius = 10003
}

local bomberman = {
	playerstorage = 19597,
	storagecount = 19596,
	temple = {x = 32369, y = 32241, z = 7},
	teleportPosition = {x = 32276, y = 32462, z = 7, stackpos = 1},
	teleportToPosition = {x = 27103, y = 26596, z = 7},
	players = 9,
	level = 80
}

local function startBomberman()
	local players = {}
	for i = 1, #t do
		local v = getTopCreature(t[i]).uid 
		players[i] = isPlayer(v) and v or nil
	end
	
	local first = players[1] and 1 or players[2] and 2 or players[3] and 3 or players[4] and 4 or players[5] and 5 or players[6] and 6 or players[7] and 7 or players[8] and 8 or players[9] and 9
	for i = 1, 9 do
		if players[i] then
			setPlayerStorageValue(players[i], storage.placed, 0)
			setPlayerStorageValue(players[i], storage.max, 1)
			setPlayerStorageValue(players[i], storage.radius, 1)
			doRemoveCondition(players[i], CONDITION_HASTE)
			doSendMagicEffect(t[i], CONST_ME_TELEPORT)
			doTeleportThing(players[i], n[i])
			doSendMagicEffect(n[i], CONST_ME_TELEPORT)
		end
	end
end

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
if item.aid == 6081 then -- tp de entrada
	if getPlayerAccess(cid) > 3 then
		doTeleportThing(cid, bomberman.teleportToPosition)
		return true
	elseif getPlayerLevel(cid) < bomberman.level then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "[BomberMan] You don\'t have level "..bomberman.level.." to participate this event.")
		doTeleportThing(cid, lastPosition)
		doSendMagicEffect(getThingPos(cid), 2)
		return true
	elseif getGlobalStorageValue(bomberman.storagecount) > 0 then
		setGlobalStorageValue(bomberman.storagecount, getGlobalStorageValue(bomberman.storagecount)-1)
		doCreatureSetStorage(cid, bomberman.playerstorage, 1)
		for i = 1, table.maxn(waitingroom) do
		local position = {x=waitingroom[i].x, y=waitingroom[i].y, z=waitingroom[i].z, stackpos=255}
		local thing = getThingFromPos(position)
			if (thing.itemid == 0) then
				doTeleportThing(cid, position)
			end
		end
		doSendMagicEffect(getThingPos(cid), 10)
		doBroadcastMessage("[BomberMan] The player "..getCreatureName(cid).." has entered in event, we are waiting " .. getGlobalStorageValue(bomberman.storagecount) .. " players.")
	end
	if getGlobalStorageValue(bomberman.storagecount) == 0 then
		doRemoveItem(getTileItemById(bomberman.teleportPosition, 1387).uid, 1)
		doSendAnimatedText(bomberman.teleportPosition, "Closed!", TEXTCOLOR_RED)
		doBroadcastMessage("[BomberMan] The teleport was closed because it reached the maximum of players. Good luck.")
		addEvent(startBomberman, 1 * 10 * 1000)
	end
end
return true
end