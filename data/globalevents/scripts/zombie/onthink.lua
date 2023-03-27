function onThink(interval, lastExecution, thinkInterval)
	local statusZombieEvent = getStatusZombieEvent()
	if(statusZombieEvent == 2) then
		local totalZombiesSummonar = getTotalZombiesSummonar()+1
		setTotalZombiesSummonar(totalZombiesSummonar)

		for i=1,totalZombiesSummonar do
			summonaZombie()
		end
	end
	return true
end 