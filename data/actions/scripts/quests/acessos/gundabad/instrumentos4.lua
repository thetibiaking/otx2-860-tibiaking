function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 58763 and getPlayerStorageValue(cid, 58750) == 8 and getPlayerStorageValue(cid, 58761) == 3) then
				setPlayerStorageValue(cid, 58761, 4)
				doCreatureSay(cid, "Um livro encontrado.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58761) >= 4 then
				doCreatureSay(cid, "Voc� j� encontrou esse livro.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58750) < 8 then
				doCreatureSay(cid, "Voc� precisa iniciar a miss�o com o monge Andry.", TALKTYPE_ORANGE_1)
		end
	return TRUE
end