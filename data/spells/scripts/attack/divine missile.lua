local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLHOLY)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -2, -3.3, -1.1, -12.5, 6, 6, 2.8, 4)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
