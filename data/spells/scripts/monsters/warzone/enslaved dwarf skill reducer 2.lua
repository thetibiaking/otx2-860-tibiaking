local combat = createCombatObject() 
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)


local condition = createConditionObject(CONDITION_ATTRIBUTES) 
setConditionParam(condition, CONDITION_PARAM_TICKS, 7000)
setConditionParam(condition, CONDITION_PARAM_SKILL_MELEEPERCENT, -10)
setCombatCondition(combat, condition) 

local area = createCombatArea(AREA_CIRCLE2X2)
setCombatArea(combat, area)

function onCastSpell(creature, var)
	return doCombat(creature, combat, var)
end