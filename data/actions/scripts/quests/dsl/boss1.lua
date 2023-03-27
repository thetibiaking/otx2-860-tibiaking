function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 33057, y = 32135, z = 14}
        if(item.actionid == 27001) then
                doTeleportThing(cid, newPosition, TRUE)
        end
        return TRUE
end