local combat = createCombatObject() 
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_POISON)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISON)

local condition = createConditionObject(CONDITION_POISON)
setConditionParam(condition, CONDITION_PARAM_MINVALUE, -1500)
setConditionParam(condition, CONDITION_PARAM_MAXVALUE, -1500)
setConditionParam(condition, CONDITION_PARAM_STARTVALUE, -1500)
setCombatCondition(combat, condition)

arr = {
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 1, 1, 3, 1, 1, 1, 1, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

local area = createCombatArea(arr)
setCombatArea(combat, area)

function onCastSpell(cid, var)
	local targetCriatura = getCreatureTarget(cid)
	doSetCreatureOutfit(targetCriatura, {lookType = 299}, 10*1000)
	
	addEvent(function()		
		var = positionToVariant(getPlayerPosition(targetCriatura))
		return doCombat(cid, combat, var)
	end, 10000)
end 