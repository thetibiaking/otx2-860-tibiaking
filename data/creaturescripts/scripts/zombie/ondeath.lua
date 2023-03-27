 function onDeath(cid)
	local totalZombiesSummonar = getTotalZombiesSummonar()+2
	setTotalZombiesSummonar(totalZombiesSummonar)
	doCreatureSay(cid, "I'll be back!", 19)
	return true
end 