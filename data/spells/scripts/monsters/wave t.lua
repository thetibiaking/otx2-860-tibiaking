local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)

local WARDENT_AREA = {
{1, 1, 1},
{0, 1, 0},
{0, 3, 0}
}

local area = createCombatArea(WARDENT_AREA)
setCombatArea(combat, area)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end