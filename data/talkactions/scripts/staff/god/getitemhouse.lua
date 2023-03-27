-- Comando feito por Paulo Vitor exclusivo para TwkSoft
function onSay(cid, words, param)
local coisas = db.getResult("SELECT `tile_id` FROM `tibera-world`.`tile_items` WHERE `itemtype` = '".. param .."';")
if (coisas:getID() ~= -1) then
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "Lista de HOUSES que possuem o item ID: ".. param .." (".. getItemNameById(param) ..").")
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "------------------------------")
contador = 1
repeat
local paes = db.getResult("SELECT `house_id` FROM `tibera-world`.`tiles` WHERE `id` = '" ..coisas:getDataInt("tile_id") .."';")
local xaxa = paes:getDataInt("house_id")
local omai = db.getResult("SELECT `x` FROM `tibera-world`.`tiles` WHERE `id` = '" ..coisas:getDataInt("tile_id") .."';")
local astrox = omai:getDataInt("x")
local omaiu = db.getResult("SELECT `y` FROM `tibera-world`.`tiles` WHERE `id` = '" ..coisas:getDataInt("tile_id") .."';")
local astroy = omaiu:getDataInt("y")
local omaia = db.getResult("SELECT `z` FROM `tibera-world`.`tiles` WHERE `id` = '" ..coisas:getDataInt("tile_id") .."';")
local astroz = omaia:getDataInt("z")
local owned = db.getResult("SELECT `owner`,`name` FROM `tibera-world`.`houses` WHERE `id` = '" .. xaxa .."';")
local final = owned:getDataInt("owner")
local grande = db.getResult("SELECT `name` FROM `tibera-world`.`players` WHERE `id` = '" .. final .."';")
local peqe = grande:getDataString("name")
local casanome = owned:getDataString("name")
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "".. contador ..". [DONO: ".. peqe .."] [NOME DA HOUSE: ".. casanome .."] [REFERENCIA: X:"..astrox..", Y:"..astroy..", Z:".. astroz.."].")
contador = contador + 1
until not coisas:next()
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "------------------------------")
return TRUE
else
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Parametros incorretos ou nenhum player possui este item.")
return TRUE
end
end