-- dsl Quest --

function onUse(cid, item, frompos, item2, topos)
if item.uid == 2131 then
  queststatus = getPlayerStorageValue(cid,13113)
  if queststatus == -1 or queststatus == 0 then
   doPlayerSendTextMessage(cid,22,"You have found a Star Amulet.")
   item_uid = doPlayerAddItem(cid,2131,1)
   setPlayerStorageValue(cid,13113,1)

  else
   doPlayerSendTextMessage(cid,22,"it\'s empty.")
  end
else
  return 0
end
return 1
end