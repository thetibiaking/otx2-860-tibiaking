function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 58764 and getPlayerStorageValue(cid, 58750) == 8 and getPlayerStorageValue(cid, 58761) == 4) then
				setPlayerStorageValue(cid, 58761, 5)
				setPlayerStorageValue(cid, 58750, 9)
				doCreatureSay(cid, "Um livro encontrado.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58761) >= 5 then
				doCreatureSay(cid, "Você já encontrou esse livro.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58750) < 8 then
				doCreatureSay(cid, "Você precisa iniciar a missão com o monge Andry.", TALKTYPE_ORANGE_1)
		end
	return TRUE
end