-- Comando feito por Paulo Vitor exclusivo para TwkSoft
function onSay(cid, words, param)
local coisas = db.getResult("SELECT `player_id` FROM `tibera-world`.`player_depotitems` WHERE `itemtype` = '".. param .."';")
if (coisas:getID() ~= -1) then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "Lista de players que possuem o item ID: ".. param .." (".. getItemNameById(param) ..") (NO DEPOT).")
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "------------------------------")
contador = 1
repeat
local paes = db.getResult("SELECT `name` FROM `tibera-world`.`players` WHERE `id` = '" ..coisas:getDataInt("player_id") .."';")
local xaxa = paes:getDataString("name")
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "".. contador ..". ".. xaxa .."")
contador = contador + 1
until not coisas:next()
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "------------------------------")
return TRUE
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Parametros incorretos ou nenhum player possui este item.")
return TRUE
end
end