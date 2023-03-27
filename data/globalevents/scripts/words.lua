dofile('data/creaturescripts/scripts/daily_monster_bonus.lua')

function onThink(cid, interval, lastExecution)
      doSendAnimatedText({x = 32436, y = 32221, z = 7},"Loot +"..loot_bonus.."%", 244)
      doSendAnimatedText({x = 32437, y = 32221, z = 7},"Boosted", 244)
      doSendAnimatedText({x = 32438, y = 32221, z = 7},"Exp +"..experienceBonus.."%", 244)
return true
end