function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 58762 and getPlayerStorageValue(cid, 58750) == 8 and getPlayerStorageValue(cid, 58761) == 2) then
				setPlayerStorageValue(cid, 58761, 3)
				doCreatureSay(cid, "Um livro encontrado.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58761) >= 3 then
				doCreatureSay(cid, "Você já encontrou esse livro.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58750) < 8 then
				doCreatureSay(cid, "Você precisa iniciar a missão com o monge Andry.", TALKTYPE_ORANGE_1)
		end
	return TRUE
end