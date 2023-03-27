function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 6050 and getPlayerStorageValue(cid, 16051) == 2) then
				setPlayerStorageValue(cid, 16051, 3)
				doCreatureSay(cid, "Erva Encontrada.", TALKTYPE_ORANGE_1)
				else	
				doCreatureSay(cid, "Procure Annagiov primeiro ou erva ja encontrada.", TALKTYPE_ORANGE_1)
		end
	return TRUE
end