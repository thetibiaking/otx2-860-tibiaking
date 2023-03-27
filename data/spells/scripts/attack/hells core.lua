local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
setAttackFormula(combat, COMBAT_FORMULA_LEVELMAGIC, 6.9, 7, 8, 11)

local area = createCombatArea(AREA_CROSS5X5)
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
