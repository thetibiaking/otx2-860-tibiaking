function onUse(cid, item, fromPosition, itemEx, toPosition)
        local newPosition = {x = 33042, y = 32068, z = 14}
        if(item.actionid == 27008) then
                doTeleportThing(cid, newPosition, TRUE)
        end
        return TRUE
end