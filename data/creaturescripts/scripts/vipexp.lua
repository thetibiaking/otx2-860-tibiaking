--italo viado ;D

dofile("./_woe.lua")

function onLogin(cid)
Woe.getInfo()
local Guild_ID = getPlayerGuildId(cid)
if (infoLua[2] ~= 0) then
if vip.hasVip(cid) and Guild_ID == infoLua[2] then
doPlayerSetExperienceRate(cid, 1.30)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voc� tem "..((1.30 - 1)*100).."% de exp a mais agora! (VIP ACCOUNT + WAR OF EMPERIUM).")
elseif vip.hasVip(cid) and Guild_ID ~= infoLua[2] then
doPlayerSetExperienceRate(cid, 1.15)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voc� tem "..((1.15 - 1)*100).."% de exp a mais agora! (VIP ACCOUNT).")
elseif (not vip.hasVip(cid)) and Guild_ID == infoLua[2] then
doPlayerSetExperienceRate(cid, 1.15)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voc� tem "..((1.15 - 1)*100).."% de exp a mais agora! (WAR OF EMPERIUM).")
else
doPlayerSetExperienceRate(cid, 1)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Voc� n�o possui VIP e sua Guild n�o conquistou o War of Emperium.")
end
end
return TRUE
end