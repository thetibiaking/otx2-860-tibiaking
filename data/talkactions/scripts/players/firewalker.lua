--[[ script By gean Riot SUBWAT PARA XTIBIA!]]--  
function onSay(cid, words, param) 
 
local config = { 
price = 10000, 
new_soft = 9933, -- id da nova bota que vai ser dada 
worn_soft = 10022, -- id da bota velha que vai ser retirada 
needPremium = true -- se precisa ser premium (true or false) 
} 
 
if (config.needPremium == false) and (not isPremium(cid)) then 
doPlayerSendTextMessage(cid, 23, "desculpe apenas Premium players podem recarregar a bota.") 
return TRUE 
end 
 
if getPlayerItemCount(cid, config.worn_soft) >= 1 then 
if doPlayerRemoveMoney(cid,config.price) == TRUE then 
doPlayerRemoveItem(cid,config.worn_soft,1) 
doPlayerAddItem(cid,config.new_soft, 1)  
doSendMagicEffect(getPlayerPosition(cid), math.random(28,30)) 
doCreatureSay(cid, "Firewalker Boots Repaired", TALKTYPE_ORANGE_1) 
else 
doPlayerSendCancel(cid, 'Você precisa de ' .. config.price ..' gps para trocar.') 
end 
else 
doPlayerSendCancel(cid, 'você não tem uma ' .. getItemNameById(config.worn_soft) .. ' para trocar por uma nova.') 
end 
return TRUE 
end

