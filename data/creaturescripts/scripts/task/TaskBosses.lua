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
		[18] = {75327, {"Necropharus"}}
	},
	positions =
	{
		[1] =
		{
			topLeftPos = {x = 32520, y = 32422, z = 7},
			bottomRightPos = {x = 32529, y = 32428, z = 7},
			monsterPos = {x = 32527, y = 32425, z = 7},
			tpPos = {x = 32520, y = 32425, z = 7},
			emergencyPos = {x = 32521, y = 32425, z = 7}
		},
		[2] =
		{
			topLeftPos = {x = 32510, y = 32432, z = 7},
			bottomRightPos = {x = 32516, y = 32441, z = 7},
			monsterPos = {x = 32513, y = 32439, z = 7},
			tpPos = {x = 32513, y = 32432, z = 7},
			emergencyPos = {x = 32513, y = 32433, z = 7}
		},
		[3] =
		{
			topLeftPos = {x = 32497, y = 32422, z = 7},
			bottomRightPos = {x = 32506, y = 32428, z = 7},
			monsterPos = {x = 32499, y = 32425, z = 7},
			tpPos = {x = 32506, y = 32425, z = 7},
			emergencyPos = {x = 32505, y = 32425, z = 7}
		},
		[4] =
		{
			topLeftPos = {x = 32510, y = 32409, z = 7},
			bottomRightPos = {x = 32516, y = 32418, z = 7},
			monsterPos = {x = 32513, y = 32411, z = 7},
			tpPos = {x = 32513, y = 32418, z = 7},
			emergencyPos = {x = 32513, y = 32417, z = 7}
		}
	}
}

local function getArenaID(cid)
	local position = {x = getThingPosition(cid).x, y = getThingPosition(cid).y, z = getThingPosition(cid).z}
	for i = 1, #configs.positions do
		if position.x >= configs.positions[i].topLeftPos.x and position.x <= configs.positions[i].bottomRightPos.x and position.y >= configs.positions[i].topLeftPos.y and position.y <= configs.positions[i].bottomRightPos.y then
			return i
		end
	end
	return nil
end

local function getStorageByBossName(cid)
	local CreatureName = getCreatureName(cid)
	for i = 1, #configs.bosses do
		if #configs.bosses[i][2] > 1 then
			for k = 1, #configs.bosses[i][2] do
				if configs.bosses[i][2][k] == CreatureName then
					return configs.bosses[i][1]
				end
			end
		else
			if configs.bosses[i][2][1] == CreatureName then
				return configs.bosses[i][1]
			end
		end
	end
	return nil
end

local function getBossesNameArray(cid)
	local CreatureName = getCreatureName(cid)
	for i = 1, #configs.bosses do
		if #configs.bosses[i][2] > 1 then
			for k = 1, #configs.bosses[i][2] do
				if configs.bosses[i][2][k] == CreatureName then
					return {#configs.bosses[i][2], k, configs.bosses[i][2][k + 1]}
				end
			end
		else
			if configs.bosses[i][2][1] == CreatureName then
				return {1, 1}
			end
		end
	end
	return nil
end

function onDeath(cid, corpse, deathList)
	local ArenaID = getArenaID(cid)
	if ArenaID then
		for i = 1, #deathList do
			doCreatureSetStorage(deathList[i], getStorageByBossName(cid), getCreatureStorage(deathList[i], getStorageByBossName(cid)) + 1)
		end
		if getBossesNameArray(cid)[1] == getBossesNameArray(cid)[2] then
			local Position = getThingfromPos({x = configs.positions[ArenaID].tpPos.x, y = configs.positions[ArenaID].tpPos.y, z = configs.positions[ArenaID].tpPos.z, stackpos = 1})
			while Position.itemid ~= 0 do
				if getItemInfo(Position.itemid).movable then
					doTeleportThing(Position.uid, configs.positions[ArenaID].emergencyPos)
				else
					doRemoveItem(Position.uid)
				end
				Position = getThingfromPos({x = configs.positions[ArenaID].tpPos.x, y = configs.positions[ArenaID].tpPos.y, z = configs.positions[ArenaID].tpPos.z, stackpos = 1})
			end
			if Position.itemid ~= 1387 then
				doItemSetAttribute(doCreateItem(1387, 1, configs.positions[ArenaID].tpPos), "aid", 47559 + ArenaID)
			end
		else
			doCreateMonster(getBossesNameArray(cid)[3], configs.positions[ArenaID].monsterPos, false, true)
			doSendMagicEffect(configs.positions[ArenaID].monsterPos, CONST_ME_TELEPORT)
		end
	end
	return true
end
