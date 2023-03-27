function onSay(cid, words, param)
if getPlayerMoney(cid) > 2 then

doPlayerRemoveMoney(cid, 100000)

if getPlayerSex(cid) == 0 then

doPlayerSetSex(cid, 1)

else

doPlayerSetSex(cid, 0)

end

doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você mudou seu sexo.")

else

doPlayerSendCancel(cid, "Você precisa de 100k para fazer alteração de sexo.")

doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)

end

end