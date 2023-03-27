function onSay(cid, words, param)
if(not checkExhausted(cid, 6666, 600)) then
  return false
end

local macheteID = 2420
doPlayerAddItem(cid, macheteID, 1)
doSendMagicEffect(getPlayerPosition(cid), 59)
return true
end