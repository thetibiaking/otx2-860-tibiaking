 function onUse(cid, item, frompos, item2, topos)

   	if item.uid == 15004 then
   		queststatus = getPlayerStorageValue(cid,67818)
   		if queststatus == -1 then
   			doPlayerSendTextMessage(cid,25,"You have found a royal scale robe.")
   			doPlayerAddItem(cid,12643,1)
   			setPlayerStorageValue(cid,67818,1)
   		else
   			doPlayerSendTextMessage(cid,25,"It is empty.")
   		end
   	elseif item.uid == 15005 then
   		queststatus = getPlayerStorageValue(cid,67818)
   		if queststatus == -1 then
   			doPlayerSendTextMessage(cid,25,"You have found a royal draken mail.")
   			doPlayerAddItem(cid,12642,1)
   			setPlayerStorageValue(cid,67818,1)
   		else
   			doPlayerSendTextMessage(cid,25,"It is empty.")
   		end
   	elseif item.uid == 15006 then
   		queststatus = getPlayerStorageValue(cid,67818)
   		if queststatus == -1 then
   			doPlayerSendTextMessage(cid,25,"You have found a elite draken helmet.")
   			doPlayerAddItem(cid,12645,1)
   			setPlayerStorageValue(cid,67818,1)
   		else
   			doPlayerSendTextMessage(cid,25,"It is empty.")
   		end
	else
		return 0
   	end

   	return 1
end