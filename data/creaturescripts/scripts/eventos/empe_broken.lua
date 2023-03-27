dofile("./_woe.lua")

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

local config = woe_config
	
function onDeath(cid, corpse, deathList)
	local killer = deathList[1]
	Woe.getInfo()
	if Woe.isTime() then
		if isPlayer(killer) == true then
			if Woe.isRegistered(killer) then
				local Guild_ID = getPlayerGuildId(killer)
				local players = Woe.expulsar({x = 31785, y = 32602, z = 6}, {x = 31880, y = 32684, z = 8});
				Woe.updateInfo({infoLua[1], Guild_ID, getPlayerGUID(killer), os.time()})
				doBroadcastMessage("[War Castle] O castle foi conquistado pelo jogador " .. getCreatureName(killer) .. " para a guild " .. getPlayerGuildName(killer) .. ".", config.bcType)
				Woe.deco("[War Castle] A guild " .. getPlayerGuildName(killer) .. " é agora dominante do castle.")
				for i = 1, #players do
					if (getPlayerGuildId(players[i]) ~= Guild_ID) then
						doTeleportThing(players[i], Castle._exit, false)
					end
				end
			end
		end
		if isCreature(cid) == true then
			doRemoveCreature(cid)
		end
		
		Woe.removePre()
		Woe.remove()
		setGlobalStorageValue(24503, -1)
		doCreateMonster("empe", Castle.empePos, false, true);
		doCreateMonster("pre1", Castle.PreEmpes[1], false, true);
		doCreateMonster("pre2", Castle.PreEmpes[2], false, true);
		doRemoveMonstersInArea({x = 31808, y = 32660, z = 7}, {x = 31808, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31807, y = 32660, z = 7}, {x = 31807, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31809, y = 32660, z = 7}, {x = 31809, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31821, y = 32644, z = 6}, {x = 31821, y = 32644, z = 6})
		doRemoveMonstersInArea({x = 31821, y = 32645, z = 6}, {x = 31821, y = 32645, z = 6})
		doRemoveMonstersInArea({x = 31821, y = 32646, z = 6}, {x = 31821, y = 32646, z = 6})
		doRemoveMonstersInArea({x = 31806, y = 32636, z = 7}, {x = 31806, y = 32636, z = 7})
		doRemoveMonstersInArea({x = 31867, y = 32643, z = 8}, {x = 31867, y = 32643, z = 8})
		doRemoveMonstersInArea({x = 31843, y = 32632, z = 8}, {x = 31843, y = 32632, z = 8})
		doRemoveMonstersInArea({x = 31843, y = 32631, z = 8}, {x = 31843, y = 32631, z = 8})
		doRemoveMonstersInArea({x = 31824, y = 32675, z = 8}, {x = 31824, y = 32675, z = 8})
		doRemoveMonstersInArea({x = 31825, y = 32675, z = 8}, {x = 31825, y = 32675, z = 8})
		doCreateMonster("Antirush", {x = 31808, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31807, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31809, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32644, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32645, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32646, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31806, y = 32636, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31867, y = 32643, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31843, y = 32632, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31843, y = 32631, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31824, y = 32675, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31825, y = 32675, z = 8}, false, true);
		local porta1 = getTileItemById({x = 31858, y = 32616, z = 7}, 1544).uid
		local porta2 = getTileItemById({x = 31859, y = 32616, z = 7}, 1544).uid
		if porta1 < 1 then
			doCreateItem(1544, 1, {x = 31858, y = 32616, z = 7})
		end
		if porta2 < 1 then
			doCreateItem(1544, 1, {x = 31859, y = 32616, z = 7})
		end
	end
	return true
end