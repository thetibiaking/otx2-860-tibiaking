local defaultMuteTime = 2 * 60
local muteMsgOnPlayer = "Voce foi mutado no Help por %s."
local muteMsgOnChannel = "O player %s foi mutado por %s."

function onSay(cid, words, param)
	if param == "" then
		return doPlayerSendCancel(cid, "Informe o nome do jogador e o tempo em segundos.")
	end
	
	local tmp = string.explode(param, ",")	
	if not isCreature(getCreatureByName(tmp[1])) then
		return doPlayerSendCancel(cid, "Jogador nao existe ou esta offline.")
	end
	
	setPlayerStorageValue(getPlayerByName(tmp[1]), 455010, os.time() + ((tonumber(tmp[2]) * 60) or defaultMuteTime))
	doPlayerSendTextMessage(getPlayerByName(tmp[1]), MESSAGE_EVENT_ADVANCE, muteMsgOnPlayer:format(getTimeString(defaultMuteTime)))
	
	for _, pid in pairs(getPlayersOnline()) do
		doPlayerSendChannelMessage(pid, "", muteMsgOnChannel:format(tmp[1], getTimeString((tonumber(tmp[2]) * 60)) or getTimeString(defaultMuteTime)), TALKTYPE_CHANNEL_MANAGEMENT, CHANNEL_HELP)
	end
	
	doPlayerSendCancel(cid, "O jogador " .. tmp[1] .. " foi mutado por ".. getTimeString((tonumber(tmp[2]) * 60) or defaultMuteTime) ..".")
	return true
end