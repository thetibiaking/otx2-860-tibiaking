function onCastSpell(cid, var)
	local health, hp, cpos = math.random(7500, 9000), (getCreatureHealth(cid)/getCreatureMaxHealth(cid))*100
	if getCreatureName(cid) == "Omrafir" and (hp < 99) then
		cpos = getTileThingByPos({x = getCreaturePosition(cid).x, y = getCreaturePosition(cid).y, z = getCreaturePosition(cid).z, stackpos = 2}).itemid
		if cpos == 1487 or cpos == 1492 or cpos == 1493 or cpos == 1494 then
			doCreatureAddHealth(cid, health)
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_BLUE)
			doCreatureSay(cid, "Omrafir gains new strength from the fire", TALKTYPE_MONSTER_SAY, nil, nil, getCreaturePosition(cid))
		end
	end
end