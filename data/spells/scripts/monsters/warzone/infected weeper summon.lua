function onCastSpell(cid, var)
	local sto = getCreatureStorage(cid, 100)
	if sto and not isMonster(sto) then
		local summon = doCreateMonster("Parasite",getCreaturePosition(cid))
		doSendMagicEffect(getCreaturePosition(summon), 12)
		registerCreatureEvent(summon, "ParasiteWarzone")
		doCreatureSetStorage(cid, 100, summon)
	end
	return true
end