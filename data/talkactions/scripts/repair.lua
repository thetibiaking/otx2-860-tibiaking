--[[ script By Subwat Repair soft e firewalker boots!]]-- 

function onSay(cid, words, param) 

local config = {
price = 20000,
new_soft = 6132, -- id da nova soft boots
worn_soft = 10021, -- id da velha soft boots
new_firewalker = 9933, -- id da firewalker boots
worn_firewalker = 10022, -- id da velha firewalker boots
needPremium = true -- se precisa ser premium (true or false)
}

if (config.needPremium == true) and (not isPremium(cid)) then
doPlayerSendTextMessage(cid, 23, "only premium players can use that command.")
return TRUE
end

if param == "soft" or param == "soft boots" then
if getPlayerItemCount(cid, config.worn_soft) >= 1 then
if doPlayerRemoveMoney(cid,config.price) == TRUE then
doPlayerRemoveItem(cid,config.worn_soft,1)
doPlayerAddItem(cid,config.new_soft, 1) 
doPlayerPopupFYI(cid,"you recharged your pair of soft boots!")
end
end
return TRUE 
end

if param == "firewalker" or param == "firewalker boots" then
if getPlayerItemCount(cid, config.worn_firewalker) >= 1 then
if doPlayerRemoveMoney(cid,config.price) == TRUE then
doPlayerRemoveItem(cid,config.worn_firewalker,1)
doPlayerAddItem(cid,config.new_firewalker, 1) 
doPlayerPopupFYI(cid,"you recharged your firewalker boots!")
end
end
return TRUE 
end
end