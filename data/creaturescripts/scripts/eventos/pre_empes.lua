dofile("./_woe.lua")

local config = woe_config

function onDeath(cid, corpse, killer)
	if isCreature(cid) == true then
		doRemoveCreature(cid)
	end
	if Woe.isTime() then
		if Woe.checkPre() then
		--	doSetItemActionId(doCreateItem(1387, 1, Castle.PrePortalsPos[1]), Castle.portals)
		--	doSetItemActionId(doCreateItem(1387, 1, Castle.PrePortalsPos[2]), Castle.portals)
			local porta1 = getTileItemById({x = 31858, y = 32616, z = 7}, 1544).uid
			local porta2 = getTileItemById({x = 31859, y = 32616, z = 7}, 1544).uid
			if porta1 > 0 then
				doRemoveItem(porta1, 1)
			end
			if porta2 > 0 then
				doRemoveItem(porta2, 1)
			end
			
			doBroadcastMessage("[War Castle] Ambos cristais foram quebrados, os portões para a sala do REI foram abertas!", config.bcType)
		else
			doBroadcastMessage("[War Castle] Um dos cristais foi quebrado...", config.bcType)
		end
	end
	return true
end 
