local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, 37)
setCombatParam(combat, COMBAT_PARAM_EFFECT, 31)
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, 0, -80, 0, -100)

function onUseWeapon(cid, var)
return doCombat(cid, combat, var)
end