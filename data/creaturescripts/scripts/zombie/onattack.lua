function onStatsChange(target, cid, changetype, combat, value)
	if((cid and isMonster(cid) and getCreatureName(cid) == "Zumbie") or (isInRange(getThingPosition(target), ZB_LOCAL_ARENA_TE, ZB_LOCAL_ARENA_BD) and changetype == STATSCHANGE_HEALTHLOSS and math.abs(value) >= getCreatureHealth(target))) then
		levouDanoZombie(target)
	end
	return true
end 