function onUse(cid, item, fromPosition, itemEx, toPosition)
        if getPlayerStorageValue(cid, 42540) - os.time() > 0 then
		return doPlayerSendCancel(cid, "You are exhausted.")
	else
		setPlayerStorageValue(cid, 42540, os.time() + (1*1))
	end

	if(isInArray(JUNGLE_GRASS, itemEx.itemid)) then
		doTransformItem(itemEx.uid, itemEx.itemid - 1)
		doDecayItem(itemEx.uid)
		return true
	end

	if(isInArray(SPIDER_WEB, itemEx.itemid)) then
		doTransformItem(itemEx.uid, (itemEx.itemid + 6))
		doDecayItem(itemEx.uid)
		return true
	end

	if(isInArray(WILD_GROWTH, itemEx.itemid)) then
		doSendMagicEffect(toPosition, CONST_ME_POFF)
		doRemoveItem(itemEx.uid)
		return true
	end
	return destroyItem(cid, itemEx, toPosition)
end