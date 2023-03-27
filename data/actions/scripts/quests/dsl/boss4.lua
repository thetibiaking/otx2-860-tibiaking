function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 33006, y = 32136, z = 14}
        if(item.actionid == 27004) then
                doTeleportThing(cid, newPosition, TRUE)
        end
        return TRUE
end