function onStepIn(cid, item, position, fromPosition)
if getPlayerGuildId(cid) > 0 then
doPlayerSendTextMessage(cid, 27, "Voce entrou, sua guild � a "..getPlayerGuildName(cid)..".")
return true
else
doPlayerSendTextMessage(cid, 27, "Voce n�o possue guild, portanto n�o pode entrar nessa zona.")
doTeleportThing(cid, fromPosition)
return false
end
end