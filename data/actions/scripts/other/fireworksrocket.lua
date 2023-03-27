function onUse(cid, item, fromPosition, itemEx, toPosition)
 
        if getPlayerStorageValue(cid,21024) == 250 then
        doPlayerSendTextMessage(cid,22,"Congratulations! You earned the achievement \"Fireworks in the Sky\".")
   	doPlayerAddAchievement(cid, 24)
        end
 
	if fromPosition.x ~= CONTAINER_POSITION then
		fireworksEffect = math.random(CONST_ME_FIREWORK_YELLOW, CONST_ME_FIREWORK_BLUE)
		doSendMagicEffect(fromPosition, fireworksEffect)
	else
		doSendMagicEffect(fromPosition, CONST_ME_HITBYFIRE)
		doSendMagicEffect(fromPosition, CONST_ME_EXPLOSIONAREA)
		doCreatureSay(cid, "Ouch! Rather place it on the ground next time.", TALKTYPE_ORANGE_1)
		doCreatureAddHealth(cid, -10)
	end
	doRemoveItem(cid, item.uid, 1)
   	setPlayerStorageValue(cid, 21024, getCreatureStorage(cid, 21024) + 1)
	return TRUE
end
