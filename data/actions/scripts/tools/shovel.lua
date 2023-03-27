function onUse(cid, item, fromPosition, itemEx, toPosition)

if getPlayerStorageValue(cid, 42541) - os.time() > 0 then
		return doPlayerSendCancel(cid, "You are exhausted.")
	else
		setPlayerStorageValue(cid, 42541, os.time() + (2*1))
	end

	if(isInArray(HOLES, itemEx.itemid)) then
		local newId = itemEx.itemid + 1
		if(itemEx.itemid == 8579) then
			newId = 8585
		end

		doTransformItem(itemEx.uid, newId)
		doDecayItem(itemEx.uid)
	elseif(isInArray(SAND, itemEx.itemid)) then
		local rand = math.random(1, 100)
		local ground = getThingFromPos({x = toPosition.x, y = toPosition.y, z = toPosition.z + 1, stackpos = STACKPOS_GROUND})
		if(isInArray(SPOTS, ground.itemid) and rand <= 20) then
			doTransformItem(itemEx.uid, 489)
			doDecayItem(itemEx.uid)
		elseif(rand >= 1 and rand <= 5) then
			doCreateItem(2159, 1, toPosition)
		elseif(rand > 85) then
			doCreateMonster("Scarab", toPosition, false)
		end

		doSendMagicEffect(toPosition, CONST_ME_POFF)
	end

	return true
end