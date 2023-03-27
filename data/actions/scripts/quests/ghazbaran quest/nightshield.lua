function onUse(cid, item, frompos, item2, topos)
if item.actionid == 12004 then
	queststatus = getPlayerStorageValue(cid,2004)
	if queststatus == -1 or queststatus == 0 then
		doPlayerSendTextMessage(cid,22,"You have found a nightmare shield")
		item_uid = doPlayerAddItem(cid,6391,1)
		setPlayerStorageValue(cid,2004,1)


	else
		doPlayerSendTextMessage(cid,22,"This chest is empty.")
	end
else
	return 0
end
return 1
end