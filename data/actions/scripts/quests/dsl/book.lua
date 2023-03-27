function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.itemid == 8046 and item.actionid == 15402) then
                if getPlayerStorageValue(cid, 5401) == 1 then
				doCreatureSay(cid, "Found.", TALKTYPE_ORANGE_1)
				else
				setPlayerStorageValue(cid, 5401, 1)
				doSendMagicEffect(getCreaturePosition(cid),51)
				doCreatureSay(cid, "Cave access guide found.", TALKTYPE_ORANGE_1)
				end
		end
        return TRUE
end