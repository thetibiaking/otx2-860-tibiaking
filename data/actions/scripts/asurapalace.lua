function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 32949, y = 32685, z = 14}
        if(item.itemid == 9656 and item.actionid == 25001) then
                doTeleportThing(cid, newPosition, TRUE)
                doSendMagicEffect(newPosition, CONST_ME_TELEPORT)
                doSendMagicEffect(fromPosition, CONST_ME_POFF)
				doCreatureSay(cid, "Welcome to Mirror", TALKTYPE_ORANGE_1)
        end
        return TRUE
end