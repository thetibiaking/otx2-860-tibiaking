function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 33056, y = 32173, z = 14}
        if(item.actionid == 27002) then
                doTeleportThing(cid, newPosition, TRUE)
        end
        return TRUE
end