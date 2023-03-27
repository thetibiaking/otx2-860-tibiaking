local coins = {
	[ITEM_GOLD_COIN] = {
		to = ITEM_PLATINUM_COIN, effect = COLOR_YELLOW
	},
	[ITEM_PLATINUM_COIN] = {
		from = ITEM_GOLD_COIN, to = ITEM_CRYSTAL_COIN, effect = COLOR_LIGHTBLUE
	},
	[ITEM_CRYSTAL_COIN] = {
		from = ITEM_PLATINUM_COIN, to = ITEM_SPECIAL_COIN, effect = COLOR_TEAL
	},
	[ITEM_SPECIAL_COIN] = {
		from = ITEM_CRYSTAL_COIN, effect = COLOR_TEAL
	}
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
if getPlayerStorageValue(cid, 42543) - os.time() > 0 then
		return doPlayerSendCancel(cid, "You are exhausted.")
	else
		setPlayerStorageValue(cid, 42543, os.time() + (1*1))
	end


	if(getPlayerFlagValue(cid, PLAYERFLAG_CANNOTPICKUPITEM)) then
		return false
	end

	local coin = coins[item.itemid]
	if(not coin) then
		return false
	end

	if(coin.to ~= nil and item.type == ITEMCOUNT_MAX) then
		doChangeTypeItem(item.uid, item.type - item.type)
		doPlayerAddItem(cid, coin.to, 1)
		doSendAnimatedText(fromPosition, "$$$", coins[coin.to].effect)
	elseif(coin.from ~= nil) then
		doChangeTypeItem(item.uid, item.type - 1)
		doPlayerAddItem(cid, coin.from, ITEMCOUNT_MAX)
		doSendAnimatedText(fromPosition, "$$$", coins[coin.from].effect)
	end

	return true
end
