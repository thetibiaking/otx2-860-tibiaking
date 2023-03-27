function onSay(cid, words, param, channel)
local waittime = 4 -- (4000 seconds)
local storage = 5560
local event = {x= 32292, y= 32467, z= 7}
local war = {x= 32001, y= 32038, z= 7}

if(not checkExhausted(cid, 666, 10)) then
  return false
end

if getTilePzInfo(getPlayerPosition(cid)) then
  if (param == 'event') then
    doTeleportThing(cid, event)
    doSendMagicEffect(getPlayerPosition(cid), 10)
  elseif (param == 'war') then
    doTeleportThing(cid, war)
    doSendMagicEffect(getPlayerPosition(cid), 10)
  elseif (param == '') then
    local str = "(EVENT \n WAR \n)"
      doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, str)
  end
else
  doPlayerSendCancel(cid, "Voce so pode em area pz.")
  doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
end
return true
end