function onStepIn(cid, item, position, fromPosition)
if getPlayerGuildId(cid) > 0 then
doPlayerSendTextMessage(cid, 27, "Voce entrou, sua guild é a "..getPlayerGuildName(cid)..".")
return true
else
doPlayerSendTextMessage(cid, 27, "Voce não possue guild, portanto não pode entrar nessa zona.")
doTeleportThing(cid, fromPosition)
return false
end
end