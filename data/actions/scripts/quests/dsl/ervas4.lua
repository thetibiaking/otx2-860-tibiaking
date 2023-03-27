function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 6053 and getPlayerStorageValue(cid, 16051) == 5) then
				setPlayerStorageValue(cid, 16051, 6)
				doCreatureSay(cid, "Erva Encontrada.", TALKTYPE_ORANGE_1)
				else
				doCreatureSay(cid, "Encontre a Annagiov primeiro.", TALKTYPE_ORANGE_1)
			end
			return TRUE
		end
