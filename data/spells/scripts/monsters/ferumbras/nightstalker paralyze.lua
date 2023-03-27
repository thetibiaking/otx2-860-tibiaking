local combat = createCombatObject() 
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_SLEEP)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

local condition = createConditionObject(CONDITION_PARALYZE) 
setConditionParam(condition, CONDITION_PARAM_TICKS, 20000) 
setConditionFormula(condition, -1, 40, -1, 40) 
setCombatCondition(combat, condition) 

function onCastSpell(creature, var)
	return doCombat(creature, combat, var)
end