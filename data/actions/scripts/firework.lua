function onUse(cid, item, fromPosition, itemEx, toPosition)
    if itemEx.itemid == 9934 then
  doTransformItem(itemEx.uid, 9933)
   else
     return FALSE
   end
   return TRUE
end