local configs = {
	items = {
		--[ItemID] = Points
		[12756] = 1,
	}
}

local function doAccountAddPoints(cid, points)
	db.executeQuery(("UPDATE `accounts` SET `premium_points` = `premium_points` + %d WHERE `id` = %d;"):format(points, getPlayerAccountId(cid)))
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local points = configs.items[item.itemid]
	if not points then
		return false
	end

	doAccountAddPoints(cid, points)
	doCreatureSay(cid, ("PARABÉNS! Você recebeu %d premium point%s."):format(points, points > 1 and "s" or ""), TALKTYPE_ORANGE_1)
	doSendMagicEffect(getThingPos(cid), CONST_ME_FIREWORK_YELLOW)
	doRemoveItem(item.uid, 1)
	return true
end