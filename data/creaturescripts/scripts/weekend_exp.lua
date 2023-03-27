function onKill(cid, target, lastHit)
   if lastHit and isMonster(target) then
      local master = getCreatureMaster(target)
      if not master or master == target then
         set_bonus_weekend_exp(cid, getCreatureName(target))
      end
   end
   return true
end