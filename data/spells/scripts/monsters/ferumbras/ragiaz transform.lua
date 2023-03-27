local posBoss = {x = 33514, y = 32238, z = 12}

function onCastSpell(cid, creature, var)
	local posInicial = getCreaturePosition(cid)
	doCreatureSay(cid, "Ragiaz encase himself in bones to regenerate.", TALKTYPE_MONSTER_SAY)
	doTeleportThing(cid, posBoss)
	doCreateMonster("Bone Capsule", {x = 33481, y = 32332, z = 13})
	doCreatureAddHealth(cid, math.random(15000, 30000))
	return true
end