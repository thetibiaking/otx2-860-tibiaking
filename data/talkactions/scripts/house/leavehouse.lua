local config = {
storage = 34527,
exausted = 60
}

function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, config.storage) >= os.time() then
		doPlayerSendCancel(cid, "Aguarde ".. getPlayerStorageValue(cid, config.storage) - os.time() .. " segundos para utilizar novamente.")
		return true
	end
	setPlayerStorageValue(cid, config.storage, os.time()+config.exausted)

	local house = getHouseFromPos(getCreaturePosition(cid))
	if(not house) then
		doPlayerSendCancel(cid, "You are not inside a house.")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		return false
	end

	local owner = getHouseInfo(house).owner
	if(owner ~= getPlayerGUID(cid) and (owner ~= getPlayerGuildId(cid) or getPlayerGuildLevel(cid) ~= GUILDLEVEL_LEADER)) then
		doPlayerSendCancel(cid, "You are not the owner of this house.")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		return false
	end

	setHouseOwner(house, 0)
	doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
	return false
end
