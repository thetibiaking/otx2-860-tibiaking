local storage = 100137
 
function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(getPlayerStorageValue(cid, storage) == 5) then
	      if item.itemid == 1242 then return false end
            	doTransformItem(item.uid, item.itemid + 1)
		doTeleportThing(cid, toPosition, TRUE)
	else
	        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "This door seems to be sealed against unwanted intruders.")
	        end
	        return true
end