function onUse(cid, item, fromPosition, itemEx, toPosition)
 if itemEx.itemid == 10022 then
   doTransformItem(itemEx.uid, 9932)
 end

return TRUE
end