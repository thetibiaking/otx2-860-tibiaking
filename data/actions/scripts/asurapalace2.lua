function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 32953, y = 32672, z = 7}
        if(item.itemid == 9656 and item.actionid == 25002) then
                doTeleportThing(cid, newPosition, TRUE)
                doSendMagicEffect(newPosition, CONST_ME_TELEPORT)
                doSendMagicEffect(fromPosition, CONST_ME_POFF)
				doCreatureSay(cid, "Exit Mirror", TALKTYPE_ORANGE_1)
        end
        return TRUE
end