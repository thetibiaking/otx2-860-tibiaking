local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
setAttackFormula(combat, COMBAT_FORMULA_LEVELMAGIC, 3.5, 4, 3.5, 5)

local area = createCombatArea(AREA_SQUAREWAVE5, AREADIAGONAL_SQUAREWAVE5)
setCombatArea(combat, area)

function onCastSpell(cid, var)
	if getPlayerStorageValue(cid, WarConfigs.WarUEDisabled) == 1 then
		doPlayerSendCancel(cid, "Spell blocked for war administrator.")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		return false
	else
	return doCombat(cid, combat, var)
end
end