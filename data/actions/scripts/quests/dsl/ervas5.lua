function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 6054 and getPlayerStorageValue(cid, 16051) == 6) then
				setPlayerStorageValue(cid, 16053, 2)
				doCreatureSay(cid, "Erva Encontrada.", TALKTYPE_ORANGE_1)
				else
				doCreatureSay(cid, "Encontre a Annagiov primeiro ou ja encontrou essa.", TALKTYPE_ORANGE_1)
			end
			return TRUE
		end