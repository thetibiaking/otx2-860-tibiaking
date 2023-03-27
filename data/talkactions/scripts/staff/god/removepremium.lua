function onSay(cid, words, param) 
local t = string.explode(param, ",") 
local player = getPlayerByNameWildcard(t[1]) 
local premiumdays = tonumber(t[2]) 
      if (not t[1]) then 
      doPlayerSendCancel(cid, "You must fill with a player name.") 
      elseif (premiumdays < 0) then 
         doPlayerRemovePremiumDays(player, premiumdays) 
         doPlayerSendTextMessage(cid,22,"You have removed " .. t[2] .. " premium days from " .. player .. ".") 
         doPlayerSendTextMessage(player,25,"You have lost " .. t[2] .. " premium days.") 
      elseif (premiumdays >= 1 and premiumdays < 150) then 
         doPlayerRemovePremiumDays(player, premiumdays) 
         doPlayerSendTextMessage(cid,22,"You have removed " .. premiumdays .. " premium days from " .. getCreatureName(player) .. ".") 
         doPlayerSendTextMessage(player,25,"Foram removidos " .. premiumdays .. " VIPs Days de sua ACC.")       
     end
return TRUE 
end