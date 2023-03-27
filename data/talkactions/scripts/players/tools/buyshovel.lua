function onSay(cid, words, param)
if(not checkExhausted(cid, 66666, 600)) then
  return false
end

local ShovelID = 2554
doPlayerAddItem(cid, ShovelID, 1)
doSendMagicEffect(getPlayerPosition(cid), 59)
return true
end