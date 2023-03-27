function onSay(cid, words, param, channel)
local sto,lvl,days = 399710,58,30
if getPlayerStorageValue(cid, sto) >= 1 then
doPlayerSendCancel(cid, "Voce ja testou a sua VIP.") return true
elseif getPlayerLevel(cid) < lvl then
doPlayerSendCancel(cid, "Voce precisa ser level "..lvl.." para ganhar vip test") return true
end
vip.addVipByAccount(getPlayerAccount(cid) ,vip.getDays(tonumber(days)))
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Foram adicionados "..tonumber(days).." dias de vip.")
setPlayerStorageValue(cid, sto, 1)
return true
end