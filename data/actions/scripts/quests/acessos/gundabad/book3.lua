function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 58752 and getPlayerStorageValue(cid, 58750) == 5 and getPlayerStorageValue(cid, 58751) == 2) then
				setPlayerStorageValue(cid, 58751, 3)
				doCreatureSay(cid, "Um livro encontrado.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58751) >= 3 then
				doCreatureSay(cid, "Voc� j� encontrou esse livro.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58750) < 5 then
				doCreatureSay(cid, "Voc� precisa iniciar a miss�o com o monge Andry.", TALKTYPE_ORANGE_1)
		end
	return TRUE
end