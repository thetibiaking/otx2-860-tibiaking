function onUse(cid, item, fromPosition, itemEx, toPosition)
        if(item.actionid == 58753 and getPlayerStorageValue(cid, 58750) == 5 and getPlayerStorageValue(cid, 58751) == 3) then
				setPlayerStorageValue(cid, 58751, 4)
				doCreatureSay(cid, "Um livro encontrado.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58751) >= 4 then
				doCreatureSay(cid, "Você já encontrou esse livro.", TALKTYPE_ORANGE_1)
				elseif getPlayerStorageValue(cid, 58750) < 5 then
				doCreatureSay(cid, "Você precisa iniciar a missão com o monge Andry.", TALKTYPE_ORANGE_1)
		end
	return TRUE
end