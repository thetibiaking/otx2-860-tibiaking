local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)

local FIREATTACK_AREA = {
{1, 0, 1},
{0, 2, 0},
{1, 0, 1}
}

local area = createCombatArea(FIREATTACK_AREA)
setCombatArea(combat, area)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
