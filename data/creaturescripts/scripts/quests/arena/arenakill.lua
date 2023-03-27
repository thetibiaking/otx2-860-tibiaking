function onKill(cid, target)
	if isMonster(target) then
		local room = getArenaMonsterIdByName(getCreatureName(target))
		if room > 0 then
			setPlayerStorageValue(cid, room, 1)
			doPlayerSendTextMessage(cid,MESSAGE_EVENT_DEFAULT,'You can enter next room!')
		end
	end
	return true
end