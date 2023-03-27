local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

local condition = createConditionObject(CONDITION_INVISIBLE)
setConditionParam(condition, CONDITION_PARAM_TICKS, 200000)
setCombatCondition(combat, condition)

function onCastSpell(cid, var)
	if getPlayerStorageValue(cid, 72) > 0 or getPlayerStorageValue(cid, 71) > 0 then
		doPlayerSendCancel(cid, "Este spell não pode ser usado no CTF.")
		doSendMagicEffect(getThingPos(cid), CONST_ME_POFF)
		return false
	end
	return doCombat(cid, combat, var)
end