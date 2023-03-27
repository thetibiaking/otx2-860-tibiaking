function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 33006, y = 32175, z = 14}
        if(item.actionid == 27003) then
                doTeleportThing(cid, newPosition, TRUE)
        end
        return TRUE
end