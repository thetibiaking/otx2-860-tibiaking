local FragsStorage = 2001
 
function onKill(cid, target, lastHit)
	if getPlayerLevel(target) >= 150 then
		setPlayerStorageValue(cid, FragsStorage, (getPlayerStorageValue(cid, FragsStorage) >= 0 and getPlayerStorageValue(cid, FragsStorage) or 0)+1)
	end
    return true
end