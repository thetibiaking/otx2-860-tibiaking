-- dsl Quest --

function onUse(cid, item, frompos, item2, topos)
if item.uid == 2197 then
  queststatus = getPlayerStorageValue(cid,13115)
  if queststatus == -1 or queststatus == 0 then
   doPlayerSendTextMessage(cid,22,"You have found a Stone Skin Amulet.")
   item_uid = doPlayerAddItem(cid,2197,1)
   setPlayerStorageValue(cid,13115,1)

  else
   doPlayerSendTextMessage(cid,22,"it\'s empty.")
  end
else
  return 0
end
return 1
end