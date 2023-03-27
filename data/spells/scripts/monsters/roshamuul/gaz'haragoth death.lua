local combat = createCombatObject() 
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

local condition = createConditionObject(CONDITION_ENERGY)
setConditionParam(condition, CONDITION_PARAM_MINVALUE, -30000)
setConditionParam(condition, CONDITION_PARAM_MAXVALUE, -30000)
setConditionParam(condition, CONDITION_PARAM_STARTVALUE, -30000)
setCombatCondition(combat, condition)

arr = {
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
}

local area = createCombatArea(arr)
setCombatArea(combat, area)

function onCastSpell(cid, var)
    doCreatureSay(cid, "Gaz'haragoth begins to channel DEATH AND DOOM into the area! RUN!", TALKTYPE_MONSTER_SAY, nil, nil, getCreaturePosition(cid))
    addEvent(function()  
        if isMonster(cid) then
        	doCreatureSay(cid, "Gaz'haragoth calls down: DEATH AND DOOM!", TALKTYPE_MONSTER_SAY, nil, nil, getCreaturePosition(cid))   
            return doCombat(cid, combat, var)
        end
    end, 5000)
end 
