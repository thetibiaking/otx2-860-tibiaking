function onSay(cid, words, param)
local level = getConfigInfo("levelToBuyHouse")

local house = House.getHouseByPos(getPlayerLookPos(cid))

local effect = CONST_ME_POFF

if getPlayerLevel(cid) < LEVEL then doPlayerSendCancel(cid, "You need level "..LEVEL.." to buy a house.")

elseif(house == nil) then doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You must be looking to a house to buy one.")

elseif(house:buy(cid)) then effect = CONST_ME_MAGIC_BLUE end

doSendMagicEffect(getThingPos(cid), effect)

return TRUE

end