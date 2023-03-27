local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_PLANTATTACK)
setAttackFormula(combat, COMBAT_FORMULA_LEVELMAGIC, 5, 5, 5, 7)

local area = createCombatArea(AREA_CROSS6X6)
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
