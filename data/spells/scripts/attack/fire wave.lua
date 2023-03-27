local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, -1, -15, -1, -30, 5, 5, 1.8, 2.5)

local area = createCombatArea(AREA_WAVE4, AREADIAGONAL_WAVE4)
setCombatArea(combat, area)

function onCastSpell(cid, var)
	if(getPlayerStorageValue(cid, 18775) == 2) then
		doPlayerSendCancel(cid, "You are in a war zone that does not allow this spell.")
		return false
	end
	return doCombat(cid, combat, var)
end

