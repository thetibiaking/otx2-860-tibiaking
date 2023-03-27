local exhausted = 30 -- Segundos

function onSay(cid, words, param)
	if exhaustion.get(cid, 200) then
		doPlayerSendCancel(cid, 'You can only use this command again after '.. exhaustion.get(cid, 200) ..' seconds.')
		return true
	end
	exhaustion.set(cid, 200, exhausted)
	
	if (param == '') then
		doPlayerSendCancel(cid, 'Use the parameters ON or OFF to change emote spell state.')
		return true
	elseif (param == 'on' or param == 'ON') then
		if getPlayerStorageValue(cid, 58678) < 1 then
			setPlayerStorageValue(cid, 58678, 1)
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "You just turned emote spells on.")
		else
			doPlayerSendCancel(cid, 'Emote spells it\'s already on.')
		end
	elseif (param == 'off' or param == 'OFF') then
		if getPlayerStorageValue(cid, 58678) > 0 then
			setPlayerStorageValue(cid, 58678, 0)
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "You just turned emote spells off.")
		else
			doPlayerSendCancel(cid, 'Emote spells it\'s already off.')
		end
	else
		doPlayerSendCancel(cid, 'Wrong parameters, use either ON or OFF.')
	end
	return true
end