function onDeath(cid, corpse, deathList)
	if isPlayer(cid) and isPlayer(deathList[1]) and cid ~= deathList[1] then
		setPlayerStorageValue(deathList[1], 12398, math.max(1, tonumber(getPlayerStorageValue(deathList[1], 12398))+1))
		setPlayerStorageValue(deathList[1], 94310, 1)
	end
	return true
end
