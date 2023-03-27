-- 11544 = PoI Demonwing.
-- 11545 = PoI Dark Trinity.
-- 11546 = PoI Calamiyu.
-- 11547 = PoI Arrow.


function onUse(cid, item, frompos, item2, topos)

	if item.uid == 11544 then
if getPlayerStorageValue(cid,11544) == -1 then
 	doPlayerSendTextMessage(cid,25,"You have chosen an Demonwing Axe.")
 	doPlayerAddItem(cid,8926,1)
 	setPlayerStorageValue(cid,11544,1)
 else
 	doPlayerSendTextMessage(cid,25,"The chest is empty.")
 end
 
	elseif item.uid == 11545 then
if getPlayerStorageValue(cid,11544) == -1 then
 	doPlayerSendTextMessage(cid,25,"You have chosen the dark trinity mace.")
 	doPlayerAddItem(cid,8927,1)
 	setPlayerStorageValue(cid,11544,1)
 else
 	doPlayerSendTextMessage(cid,25,"The chest is empty.")
 end
 
 	elseif item.uid == 11546 then
if getPlayerStorageValue(cid,11544) == -1 then
 	doPlayerSendTextMessage(cid,25,"You have chosen an The Calamity.")
 	doPlayerAddItem(cid,8932,1)
 	setPlayerStorageValue(cid,11544,1)
 else
 	doPlayerSendTextMessage(cid,25,"The chest is empty.")
 end
 
	elseif item.uid == 11547 then
if getPlayerStorageValue(cid,11544) == -1 then
 	doPlayerSendTextMessage(cid,25,"You have found a Crystal arrow.")
 	doPlayerAddItem(cid,2352,1)
 	setPlayerStorageValue(cid,11547,1)
 else
 	doPlayerSendTextMessage(cid,25,"The chest is empty.")
 end

end
return TRUE
end