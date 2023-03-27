local t = {
	from = {x=27066, y=26587, z=7},
	to = {x=27086, y=26605, z=7},
	storage = {
		max = 10002,
		radius = 10003,
                speed = 10004
	}
}
function onStepIn(cid, item, pos, fromPos)
	if isInRange(pos, t.from, t.to) then
		if item.itemid == 12677 then
			local n = getPlayerStorageValue(cid, t.storage.max)
			if n < 3 then
				setPlayerStorageValue(cid, t.storage.max, n + 1)
				doRemoveItem(item.uid)
				doSendMagicEffect(pos, CONST_ME_FIREATTACK)
			end
		elseif item.itemid == 12678 then
			local n = getPlayerStorageValue(cid, t.storage.speed)
			if n < 1 then
                                setPlayerStorageValue(cid, t.storage.speed, n + 1)
				doChangeSpeed(cid, getCreatureBaseSpeed(cid) - 150)
				doRemoveItem(item.uid)
				doSendMagicEffect(pos, CONST_ME_ENERGYHIT)
			end
		elseif item.itemid == 12679 then
			local n = getPlayerStorageValue(cid, t.storage.radius)
			if n < 4 then
				setPlayerStorageValue(cid, t.storage.radius, n + 1)
				doRemoveItem(item.uid)
				doSendMagicEffect(pos, CONST_ME_GROUNDSHAKER)
			end
		end
	end
end