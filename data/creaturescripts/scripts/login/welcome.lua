function onLogin(cid)

 local storage = getPlayerStorageValue(cid, 1000)
 
 if storage == -1 then
 doPlayerSendTextMessage(cid, 22, "Hello "..getPlayerName(cid).." this is your first visit to the server, enjoy your stay!")
 setPlayerStorageValue(cid, 1000, 1)
 else
 playerpos = getPlayerPosition(cid)
 --doSendMagicEffect(getCreaturePosition(cid), CONST_ME_FIREWORK_BLUE)--
 --doSendAnimatedText(playerpos, "Welcome!", TEXTCOLOR_LIGHTBLUE)--
 doPlayerSendTextMessage(cid, 22, "Welcome back "..getPlayerName(cid).."!")
 end
return TRUE
end