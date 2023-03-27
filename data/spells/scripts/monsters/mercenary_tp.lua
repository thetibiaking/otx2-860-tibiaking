local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_ASSASSIN)

function onCastSpell(cid, var)
	local pos = getCreaturePosition
	for nx = (pos(cid).x - 5), (pos(cid).x + 5) do 
		for ny = (pos(cid).y - 5), (pos(cid).y + 5) do 
			local creatureFound = getThingFromPos( { x = nx, y = ny, z = pos(cid).z, stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE })
			if isCreature(creatureFound.uid) and creatureFound.uid ~= cid and creatureFound.uid == getCreatureTarget(cid) and isSightClear(pos(cid), pos(creatureFound.uid), true) then 
				doTeleportThing(cid, getThingPos(creatureFound.uid)) 
				doSendMagicEffect(getThingPos(creatureFound.uid), CONST_ME_TELEPORT)
			end
		end
	end

	return doCombat(cid, combat, var)
end