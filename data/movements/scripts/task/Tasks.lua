local taskTimer = {}
local configs =
{
	bosses =
	{
		[1] = {75304, {"The Snapper"}},
		[2] = {75305, {"Hide"}},
		[3] = {75306, {"Tiquandas Revenge"}},
		[4] = {75308, {"The Bloodtusk"}},
		[5] = {75309, {"Shardhead"}},
		[6] = {75311, {"Thul"}},
		[7] = {75316, {"Esmeralda"}},
		[8] = {75317, {"The Old Widow"}},
		[9] = {75318, {"The Many"}},
		[10] = {75319, {"Leviathan"}},
		[11] = {75320, {"Stonecracker"}},
		[12] = {75321, {"The Noxious Spawn"}},
		[13] = {75322, {"Merikh The Slaughterer"}},
		[14] = {75323, {"Fahim The Wise"}},
		[15] = {75324, {"Brutus Bloodbeard", "Deadeye Devious", "Lethal Lissy", "Ron the Ripper"}},
		[16] = {75325, {"Demodras"}},
		[17] = {75326, {"The Horned Fox"}},
		[18] = {75327, {"Necropharus"}},
		[19] = {75329, {"Kerberos"}},
		[20] = {75330, {"Zanakeph"}},
		[21] = {75331, {"Ethershreck"}},
		[22] = {75332, {"Paiz The Pauperizer"}},
		[23] = {75333, {"Gorgonas"}},
		[24] = {75334, {"God Of Death"}}
	},
	positions =
	{
		exitPos = {x = 32356, y = 32210, z = 7},
		[1] =
		{
			topLeftPos = {x = 32520, y = 32422, z = 7},
			bottomRightPos = {x = 32529, y = 32428, z = 7},
			monsterPos = {x = 32527, y = 32425, z = 7},
			enterPos = {x = 32523, y = 32425, z = 7},
			exitPos = {x = 32516, y = 32425, z = 7}
		},
		[2] =
		{
			topLeftPos = {x = 32510, y = 32432, z = 7},
			bottomRightPos = {x = 32516, y = 32441, z = 7},
			monsterPos = {x = 32513, y = 32439, z = 7},
			enterPos = {x = 32513, y = 32435, z = 7},
			exitPos = {x = 32513, y = 32428, z = 7}
		},
		[3] =
		{
			topLeftPos = {x = 32497, y = 32422, z = 7},
			bottomRightPos = {x = 32506, y = 32428, z = 7},
			monsterPos = {x = 32499, y = 32425, z = 7},
			enterPos = {x = 32503, y = 32425, z = 7},
			exitPos = {x = 32510, y = 32425, z = 7}
		},
		[4] =
		{
			topLeftPos = {x = 32510, y = 32409, z = 7},
			bottomRightPos = {x = 32516, y = 32418, z = 7},
			monsterPos = {x = 32513, y = 32411, z = 7},
			enterPos = {x = 32513, y = 32415, z = 7},
			exitPos = {x = 32513, y = 32422, z = 7}
		}
	}
}

local function doCheckArena(ArenaID)
	local PosZ = 7
	for PosX = configs.positions[ArenaID].topLeftPos.x, configs.positions[ArenaID].bottomRightPos.x do
		for PosY = configs.positions[ArenaID].topLeftPos.y, configs.positions[ArenaID].bottomRightPos.y do
			local Stack = 1
			local tile = getThingfromPos({x = PosX, y = PosY, z = PosZ, stackpos = Stack})
			while tile.itemid > 0 do
				if isCreature(tile.uid) then
					if isPlayer(tile.uid) then
						if getPlayerAccess(tile.uid) < 3 then
							return false
						else
							Stack = Stack + 1
						end
					else
						Stack = Stack + 1
					end
				else
					Stack = Stack + 1
				end
				tile = getThingfromPos({x = PosX, y = PosY, z = PosZ, stackpos = Stack})
			end
		end
	end
	return true
end

local function doCheckKillBoss(cid)
	for i = 1, #configs.bosses do
		local storage = getCreatureStorage(cid, configs.bosses[i][1])
		if storage > 0 and #configs.bosses[i][2] >= storage then
			return i
		end
	end
	return false
end

local function doCleanTaskArena(ArenaID)
	local PosZ = 7
	for PosX = configs.positions[ArenaID].topLeftPos.x, configs.positions[ArenaID].bottomRightPos.x do
		for PosY = configs.positions[ArenaID].topLeftPos.y, configs.positions[ArenaID].bottomRightPos.y do
			local Stack = 1
			local tile = getThingfromPos({x = PosX, y = PosY, z = PosZ, stackpos = Stack})
			while tile.itemid > 0 do
				if isCreature(tile.uid) then
					if isPlayer(tile.uid) then
						Stack = Stack + 1
					else
						doRemoveCreature(tile.uid)
						doSendMagicEffect({x = PosX, y = PosY, z = PosZ}, CONST_ME_POFF)
					end
				else
					doRemoveItem(tile.uid)
					doSendMagicEffect({x = PosX, y = PosY, z = PosZ}, CONST_ME_POFF)
				end
				tile = getThingfromPos({x = PosX, y = PosY, z = PosZ, stackpos = Stack})
			end
		end
	end
	return true
end

local function doTaskTimer(cid, ArenaID)
	local position = {x = getThingPosition(cid).x, y = getThingPosition(cid).y, z = getThingPosition(cid).z}
	if position.x >= configs.positions[ArenaID].topLeftPos.x and position.x <= configs.positions[ArenaID].bottomRightPos.x and position.y >= configs.positions[ArenaID].topLeftPos.y and position.y <= configs.positions[ArenaID].bottomRightPos.y then
		doTeleportThing(cid, configs.positions[ArenaID].exitPos)
		doSendMagicEffect(position, CONST_ME_POFF)
		doSendMagicEffect(getThingPosition(cid), CONST_ME_TELEPORT)
	end
	return true
end

local function doEnterArena(cid, ArenaID, fromPosition, array)
	doCleanTaskArena(ArenaID)
	if taskTimer[ArenaID] then
		stopEvent(taskTimer[ArenaID])
		taskTimer[ArenaID] = nil
	end
	taskTimer[ArenaID] = addEvent(doTaskTimer, 10 * 60 * 1000, cid, ArenaID)
	doTeleportThing(cid, configs.positions[ArenaID].enterPos)
	doSendMagicEffect(fromPosition, CONST_ME_POFF)
	doSendMagicEffect(configs.positions[ArenaID].enterPos, CONST_ME_TELEPORT)
	doCreateMonster(array[2][getCreatureStorage(cid, array[1])], configs.positions[ArenaID].monsterPos, false, true)
	doSendMagicEffect(configs.positions[ArenaID].monsterPos, CONST_ME_TELEPORT)
	return true
end

local function doExitArena(cid, ArenaID, fromPosition)
	if taskTimer[ArenaID] then
		stopEvent(taskTimer[ArenaID])
		taskTimer[ArenaID] = nil
	end
	doTeleportThing(cid, configs.positions[ArenaID].exitPos)
	doRemoveItem(getTileItemById(fromPosition, 1387).uid)
	doSendMagicEffect(fromPosition, CONST_ME_POFF)
	doSendMagicEffect(configs.positions[ArenaID].exitPos, CONST_ME_TELEPORT)
        doPlayerSave(cid)
	return true
end

function onStepIn(cid, item, position, fromPosition)
	if item.actionid == 47555 then
		doTeleportThing(cid, configs.positions.exitPos)
		doSendMagicEffect(configs.positions.exitPos, CONST_ME_TELEPORT)
	end
	if item.actionid >= 47556 and item.actionid <= 47559 then
		ArenaID = item.actionid - 47555
		if getPlayerAccess(cid) >= 7 then
			doTeleportThing(cid, fromPosition, true)
			return true
		end
		if doCheckArena(ArenaID) then
			if doCheckKillBoss(cid) then
				if getPlayerStamina(cid) > 14 * 60 then
					doEnterArena(cid, ArenaID, position, configs.bosses[doCheckKillBoss(cid)])
				else
					doPlayerSendCancel(cid, "Entry with stamina over 14 hours is only allowed.")
					doTeleportThing(cid, fromPosition, true)
				end
			else
				doTeleportThing(cid, fromPosition, true)
			end
		else
			doTeleportThing(cid, fromPosition, true)
		end
	end
	if item.actionid >= 47560 and item.actionid <= 47563 then
		if getPlayerAccess(cid) >= 7 then
			doTeleportThing(cid, fromPosition, true)
			return true
		end
		ArenaID = item.actionid - 47559
		doExitArena(cid, ArenaID, position)
	end
    return true
end
