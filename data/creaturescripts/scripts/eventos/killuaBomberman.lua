function onLogin(cid)
	if getCreatureStorage(cid, bomberman.inGameStorage) > -1 then
		doCreatureSetStorage(cid, bomberman.inGameStorage, -1)
	end
	registerCreatureEvent(cid, "bombermanPush")
	return true
end

function onThrow(cid, target)
	if isPlayer(target) then
		if getCreatureStorage(target, bomberman.inGameStorage) > -1 then
			doPlayerSendCancel(cid, "Você não pode empurrar aqui.")
			return false
		end
	end
	return true
end
