local storage = 323274
local store,exausted = 156892,30
function onLogin(cid)
	registerCreatureEvent(cid, "StaminaThink")
	setPlayerStorageValue(cid, store,0)
	setPlayerStorageValue(cid, storage, 0)
	return true
end
function onThink(cid, interval)
	if not isPlayer(cid) or not isCreature(cid) then
		return true
	end
	if getTilePzInfo(getCreaturePosition(cid)) and getPlayerStorageValue(cid, storage) <= 0 then
		setPlayerStorageValue(cid, storage, 1)
		if getPlayerStorageValue(cid, store) - os.time() <= 0 then
			doPlayerSendTextMessage(cid, 20, "{Stamina Recovery} Sua stamina come�ou a se recuperar, o fator de recupera��o � de 1 minuto de stamina a cada 7 minutos dentro da zona de prote��o em rela��o as condi��es normais.")
			setPlayerStorageValue(cid, store, os.time()+exausted)
		end 
	elseif not getTilePzInfo(getCreaturePosition(cid)) and getPlayerStorageValue(cid, storage) > 0 then
		setPlayerStorageValue(cid, storage, 0)
	end
	return true
end