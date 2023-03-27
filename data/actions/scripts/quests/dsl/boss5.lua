function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 33031, y = 32153, z = 14}
        if(item.actionid == 27005) then
                doTeleportThing(cid, newPosition, TRUE)
        end
        return TRUE
end