-- dsl Quest --

function onUse(cid, item, frompos, item2, topos)
if item.uid == 2323 then
  queststatus = getPlayerStorageValue(cid,13114)
  if queststatus == -1 or queststatus == 0 then
   doPlayerSendTextMessage(cid,22,"You have found a Hat of the mad.")
   item_uid = doPlayerAddItem(cid,2323,1)
   setPlayerStorageValue(cid,13114,1)

  else
   doPlayerSendTextMessage(cid,22,"it\'s empty.")
  end
else
  return 0
end
return 1
end