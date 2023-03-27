local combat = createCombatObject() 
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED) 

local condition = createConditionObject(CONDITION_PARALYZE) 
setConditionParam(condition, CONDITION_PARAM_TICKS, 20000) 
setConditionFormula(condition, -0.6, 0, -0.8, 0) 
setCombatCondition(combat, condition) 

local area = createCombatArea(AREA_CIRCLE3X3)
setCombatArea(combat, area)

function onCastSpell(creature, var)
	return doCombat(creature, combat, var)
end