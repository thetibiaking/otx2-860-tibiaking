function onSay(cid, words, param)
if(not checkExhausted(cid, 66667, 600)) then
  return false
end

local RopeID = 2120
doPlayerAddItem(cid, RopeID, 1)
doSendMagicEffect(getPlayerPosition(cid), 59)
return true
end