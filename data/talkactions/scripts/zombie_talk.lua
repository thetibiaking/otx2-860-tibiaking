function onSay(cid, words, param, channel)
	if getGlobalStorageValue(zombie_config.storages[3]) > 0 then
		doPlayerSendCancel(cid, "The event is already starting.") return true
	elseif not param or not tonumber(param) then 
		doPlayerSendCancel(cid, "Use only numbers.") return true 
	end
	local param = tonumber(param) <= 0 and 1 or tonumber(param)
	local tp = doCreateItem(1387, 1, zombie_config.teleport[1])
		doItemSetAttribute(tp, "aid", 45110)
		CheckZombieEvent(tonumber(param))
		ZerarStoragesZombie()
		setGlobalStorageValue(zombie_config.storages[3], 1)
		HaveCreatureZombie(zombie_config.arena, true)
return true
end