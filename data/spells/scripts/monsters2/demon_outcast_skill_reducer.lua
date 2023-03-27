local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FLASHARROW)

local area = createCombatArea(AREA_BEAM1)
setCombatArea(combat, area)

local condition = createConditionObject(CONDITION_ATTRIBUTES)
setConditionParam(condition, CONDITION_PARAM_TICKS, 6000)
setConditionParam(condition, CONDITION_PARAM_SKILL_DISTANCEPERCENT, 25)
setCombatCondition(combat, condition)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end