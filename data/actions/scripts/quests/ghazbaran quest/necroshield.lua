function onUse(cid, item, frompos, item2, topos)
if item.actionid == 12003 then
queststatus = getPlayerStorageValue(cid,2003)
	if queststatus == -1 or queststatus == 0 then
		doPlayerSendTextMessage(cid,22,"You have found a necromancer shield")
		item_uid = doPlayerAddItem(cid,6433,1)
		setPlayerStorageValue(cid,2003,1)


	else
		doPlayerSendTextMessage(cid,22,"This chest is empty.")
	end
else
	return 0
end
return 1
end