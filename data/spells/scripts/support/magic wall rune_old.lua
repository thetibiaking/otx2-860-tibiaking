local ItemID = 1497
local Duration = 20
 
local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
 
function onTargetTile(cid, position)
    local item = doCreateItem(ItemID, 1, position)
    doItemSetAttribute(item, "description", string.format("Created by: %s", getCreatureName(cid)))
    addEvent(function()
        local item = getTileItemById(position, ItemID)
        if item.uid > 0 then
            doRemoveItem(item.uid, 1)
        end
    end, Duration*1000)
    return true
end
 
setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")
 
 
function onCastSpell(cid, var)
    return doCombat(cid, combat, var)
end