function onUse(cid, item, fromPosition)
    local maxfood = 100
    local size = 10
    
    if item.itemid == 1945 then
    doTransformItem(item.uid,item.itemid+1)
    elseif item.itemid == 1946 then
    doTransformItem(item.uid, item.itemid-1)
    end
    
    if(getPlayerFood(cid) + size > maxfood) then
        doPlayerSendCancel(cid, "You are full.")
        doSendMagicEffect(fromPosition, CONST_ME_POFF)    
        return true
    end
    doPlayerFeed(cid, size)
    doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_GREEN)
    return true
end