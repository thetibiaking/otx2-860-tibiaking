function onSay(cid, words, param)
if getPlayerMoney(cid) > 2 then

doPlayerRemoveMoney(cid, 100000)

if getPlayerSex(cid) == 0 then

doPlayerSetSex(cid, 1)

else

doPlayerSetSex(cid, 0)

end

doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voc� mudou seu sexo.")

else

doPlayerSendCancel(cid, "Voc� precisa de 100k para fazer altera��o de sexo.")

doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)

end

end