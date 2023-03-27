function onUse(cid, item, fromPosition, itemEx, toPosition)
 if itemEx.itemid == 2342 then
   doTransformItem(itemEx.uid, 2343)
 end

return TRUE
end