local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)
setCombatParam(combat, COMBAT_PARAM_CREATEITEM, 1492)

local area = createCombatArea(AREA_WALLFIELD, AREADIAGONAL_WALLFIELD)
setCombatArea(combat, area)

function onCastSpell(cid, var)
local block_area = {
{{x=32698,y=32333,z=7}, {x=32698,y=32363,z=7}}, -- pos começo e final da area
{{x=32699,y=32333,z=7}, {x=32699,y=32363,z=7}},
{{x=32700,y=32333,z=7}, {x=32700,y=32363,z=7}},
{{x=32701,y=32333,z=7}, {x=32701,y=32363,z=7}},
{{x=32702,y=32333,z=7}, {x=32702,y=32363,z=7}},
{{x=32703,y=32333,z=7}, {x=32703,y=32363,z=7}},
{{x=32704,y=32333,z=7}, {x=32704,y=32363,z=7}},
{{x=32705,y=32333,z=7}, {x=32705,y=32363,z=7}},
{{x=32706,y=32333,z=7}, {x=32706,y=32363,z=7}},
{{x=32707,y=32333,z=7}, {x=32707,y=32363,z=7}},
{{x=32708,y=32333,z=7}, {x=32708,y=32363,z=7}},
{{x=32709,y=32333,z=7}, {x=32709,y=32363,z=7}},
{{x=32710,y=32333,z=7}, {x=32710,y=32363,z=7}},
{{x=32711,y=32333,z=7}, {x=32711,y=32363,z=7}},
{{x=32712,y=32333,z=7}, {x=32712,y=32363,z=7}},
{{x=32713,y=32333,z=7}, {x=32713,y=32363,z=7}},
{{x=32714,y=32333,z=7}, {x=32714,y=32363,z=7}},
{{x=32715,y=32333,z=7}, {x=32715,y=32363,z=7}},
{{x=32716,y=32333,z=7}, {x=32716,y=32363,z=7}},
{{x=32717,y=32333,z=7}, {x=32717,y=32363,z=7}},
{{x=32718,y=32333,z=7}, {x=32718,y=32363,z=7}},
{{x=32719,y=32333,z=7}, {x=32719,y=32363,z=7}},
{{x=32720,y=32333,z=7}, {x=32720,y=32363,z=7}},
{{x=32721,y=32333,z=7}, {x=32721,y=32363,z=7}},
{{x=32722,y=32333,z=7}, {x=32722,y=32363,z=7}},
{{x=32723,y=32333,z=7}, {x=32723,y=32363,z=7}},
{{x=32724,y=32333,z=7}, {x=32724,y=32363,z=7}},
{{x=32725,y=32333,z=7}, {x=32725,y=32363,z=7}},
{{x=32726,y=32333,z=7}, {x=32726,y=32363,z=7}},
{{x=32727,y=32333,z=7}, {x=32727,y=32363,z=7}},
{{x=32728,y=32333,z=7}, {x=32728,y=32363,z=7}},
{{x=32729,y=32333,z=7}, {x=32729,y=32363,z=7}},
{{x=32730,y=32333,z=7}, {x=32730,y=32363,z=7}},
{{x=32731,y=32333,z=7}, {x=32731,y=32363,z=7}},
{{x=32732,y=32333,z=7}, {x=32732,y=32363,z=7}},
{{x=32733,y=32333,z=7}, {x=32733,y=32363,z=7}},
{{x=32734,y=32333,z=7}, {x=32734,y=32363,z=7}}
}
for _, var in ipairs(block_area) do
if isInRange(getCreaturePosition(cid), var[1], var[2]) then
doPlayerSendCancel(cid, "você não pode jogar esta runa nesta area.") return false
end
end
return doCombat(cid, combat, var)
end
