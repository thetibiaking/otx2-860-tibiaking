-- dsl Quest --

function onUse(cid, item, frompos, item2, topos)
if item.uid == 11111 then
  queststatus = getPlayerStorageValue(cid,11111)
  if queststatus == -1 or queststatus == 0 then
   doPlayerSendTextMessage(cid,22,"You have found a Tribal Crest.")
   item_uid = doPlayerAddItem(cid,11115,1)
   setPlayerStorageValue(cid,11111,1)

  else
   doPlayerSendTextMessage(cid,22,"it\'s empty.")
  end
else
  return 0
end
return 1
end