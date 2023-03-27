dofile("./_woe.lua")

local config = woe_config

local reward = 100000 -- 100k

local function doRemoveMonstersInArea(from, to)
	for x = from.x, to.x do
		for y = from.y, to.y do
			local pos = {x=x, y=y, z = from.z}
			local m = getTopCreature(pos).uid
			if m > 0 and isMonster(m) then
				doRemoveCreature(m)
			end
		end
	end
end

local function EndWoe()
	Woe.getInfo()
	setGlobalStorageValue(stor.Started, 0)
	setGlobalStorageValue(stor.WoeTime, 0)
	local players = Woe.expulsar({x = 31785, y = 32602, z = 6}, {x = 31880, y = 32684, z = 8});
	for i = 1, #players do
		doTeleportThing(players[i], Castle._exit, false)
	end
	
	doBroadcastMessage("[War Castle] A luta pelo castelo acabou!", config.bcType)
	doBroadcastMessage("[War Castle] O castelo foi dominado pela guild ".. Woe.guildName() ..".", config.bcType)
	
	if isCreature(getThingFromPos(Castle.empePos).uid) then
		doRemoveCreature(getThingFromPos(Castle.empePos).uid)
	end
	
	Woe.removePre()
	
	Woe.save()
	
	for _, cid in ipairs(getPlayersOnline()) do
		if infoLua[2] == getPlayerGuildId(cid) then
			doPlayerAddMoney(cid, reward)
		end
	end
	
	Woe.remove()
	setGlobalStorageValue(24503, -1)
	
end

function onThink(interval, lastExecution)
	Woe.getInfo()
	if Woe.isTime() then
		if not Woe.isStarted() then		
			doCreateMonster("empe", Castle.empePos, false, true);
			doCreateMonster("pre1", Castle.PreEmpes[1], false, true);
			doCreateMonster("pre2", Castle.PreEmpes[2], false, true);
		doRemoveMonstersInArea({x = 31807, y = 32660, z = 7}, {x = 31807, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31808, y = 32660, z = 7}, {x = 31808, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31809, y = 32660, z = 7}, {x = 31809, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31806, y = 32636, z = 7}, {x = 31806, y = 32636, z = 7})
		doRemoveMonstersInArea({x = 31821, y = 32646, z = 6}, {x = 31821, y = 32646, z = 6})
		doRemoveMonstersInArea({x = 31821, y = 32645, z = 6}, {x = 31821, y = 32645, z = 6})
		doRemoveMonstersInArea({x = 31821, y = 32644, z = 6}, {x = 31821, y = 32644, z = 6})
		doRemoveMonstersInArea({x = 31825, y = 32675, z = 8}, {x = 31825, y = 32675, z = 8})
		doRemoveMonstersInArea({x = 31824, y = 32675, z = 8}, {x = 31824, y = 32675, z = 8})
		doRemoveMonstersInArea({x = 31843, y = 32631, z = 8}, {x = 31843, y = 32631, z = 8})
		doRemoveMonstersInArea({x = 31843, y = 32632, z = 8}, {x = 31843, y = 32632, z = 8})
		doRemoveMonstersInArea({x = 31867, y = 32643, z = 8}, {x = 31867, y = 32643, z = 8})
		doRemoveMonstersInArea({x = 31853, y = 32629, z = 8}, {x = 31853, y = 32629, z = 8})
		doCreateMonster("Antirush", {x = 31807, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31808, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31809, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31806, y = 32636, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32646, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32645, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32644, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31825, y = 32675, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31824, y = 32675, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31843, y = 32631, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31843, y = 32632, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31867, y = 32643, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31853, y = 32629, z = 8}, false, true);
			doBroadcastMessage("[War Castle] A luta pelo castelo começou!", config.bcType)
			setGlobalStorageValue(stor.Started, 1)
			Woe.updateInfo({os.time(), infoLua[2], infoLua[3], infoLua[4]})
			addEvent(doBroadcastMessage, 55 * 60 * 1000, "[War Castle] Faltam 5 minutos para o fim do evento.", config.bcType) 
			addEvent(EndWoe, config.timeToEnd * 60 * 1000)
		end
	end
	return true
end 	