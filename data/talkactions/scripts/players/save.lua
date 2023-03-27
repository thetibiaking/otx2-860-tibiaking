local exausted = 1 -- Minutos

function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, 84621) < os.time() then
		doPlayerSave(cid)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Seu personagem foi salvo com sucesso.")
		setPlayerStorageValue(cid, 84621, os.time() + (exausted * 60))
	else
		doPlayerSendCancel(cid, "Aguarde "..getPlayerStorageValue(cid, 84621) - os.time().." segundos para utilizar novamente.")
	end
	return true
end