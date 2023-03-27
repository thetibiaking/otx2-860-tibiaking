function onUse(cid, item, frompos, item2, topos)
local gatepos = {x = 33701, y = 32826, z = 11, stackpos=1}
local getgate = getThingfromPos(gatepos)

if item.uid == 15403 and item.itemid == 1945 and getgate.itemid == 1304 then
doRemoveItem(getgate.uid,1)
doTransformItem(item.uid,item.itemid+1)
elseif item.uid == 15403 and item.itemid == 1946 and getgate.itemid == 0 then
doCreateItem(1304,1,gatepos)
doTransformItem(item.uid,item.itemid-1)
end
  return 1
  end
  
  