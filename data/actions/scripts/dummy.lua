---@ Create by Sarah Wesker | Tested Version: TFS 0.4
---@ list of training dummies.
local dummies = {
    [12773] = { skillRate = 1, skillSpeed = 1 }
}

---@ Global training parameters of the system.
local staminaTries = 1 --# on minutes
local skillTries = 7 --# tries by blow
local skillSpent = function() return math.random(425, 575) end --# mana consumed by blow

---@ list of weapons to train.
local weapons = {
    [12772] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_ICE, skillType = SKILL_MAGLEVEL }, -- magicLevel Dru 100
	[12784] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_ICE, skillType = SKILL_MAGLEVEL }, -- magicLevel Dru 500
	[12785] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_ICE, skillType = SKILL_MAGLEVEL }, -- magicLevel Dru 1000
	
    [12771] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_ENERGY, skillType = SKILL_MAGLEVEL }, -- magicLevel Sor 100
	[12782] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_ENERGY, skillType = SKILL_MAGLEVEL }, -- magicLevel Sor 500
	[12783] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_ENERGY, skillType = SKILL_MAGLEVEL }, -- magicLevel Sor 1000
	
    [12770] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_SIMPLEARROW, skillType = SKILL_DISTANCE }, -- distance 100
	[12780] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_SIMPLEARROW, skillType = SKILL_DISTANCE }, -- distance 500
	[12781] = { shootEffect = CONST_ME_HITAREA, shootDistEffect = CONST_ANI_SIMPLEARROW, skillType = SKILL_DISTANCE }, -- distance 1000
	
    [12767] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_SWORD }, -- sword 100
	[12774] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_SWORD }, -- sword 500
	[12775] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_SWORD }, -- sword 1000
	
    [12769] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_AXE }, -- axe 100
	[12778] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_AXE }, -- axe 500
	[12779] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_AXE }, -- axe 1000
	
    [12768] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_CLUB }, -- club 100
	[12776] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_CLUB }, -- club 500
	[12777] = { shootEffect = CONST_ME_HITAREA, skillType = SKILL_CLUB } -- club 1000
}

---@ EDTE is the global event table to control the system correctly.
if not EDTE then EDTE = {} end

---@ functions to assign or obtain the training status of a player.
function getPlayerExerciseTrain(cid) return EDTE[cid] or false end
function setPlayerExerciseTrain(cid, status) EDTE[cid] = status return status end

---@ local training function.
local function exerciseDummyTrainEvent(params, weapon)
    if isPlayer(params.cid) then
        local item = getPlayerItemById(params.cid, true, params.itemid)
        local playerPosition = getCreaturePosition(params.cid)
        if getDistanceBetween(playerPosition, params.currentPos) <= 1 then
            local weaponCharges = getItemAttribute(item.uid, "charges") or getItemInfo(params.itemid).charges
            local reloadMs = getVocationInfo(getPlayerVocation(params.cid)).attackSpeed * params.dummy.skillSpeed
            if weaponCharges >= 1 then
                doItemSetAttribute(item.uid, "charges", weaponCharges -1)
                if weapon.shootDistEffect then doSendDistanceShoot(playerPosition, params.dummyPos, weapon.shootDistEffect) end
                if weapon.shootEffect then doSendMagicEffect(params.dummyPos, weapon.shootEffect) end
                if weapon.skillType == SKILL_MAGLEVEL then
                    doPlayerAddSpentMana(params.cid, (skillSpent() * params.dummy.skillRate) * getConfigValue("rateMagic"))
                else
                    doPlayerAddSkillTry(params.cid, weapon.skillType, (skillTries * params.dummy.skillRate) * getConfigValue("rateSkill"))
                end
                local currentStamina = getPlayerStamina(params.cid)
                doPlayerSetStamina(params.cid, currentStamina + staminaTries)
                if weaponCharges <= 1 then
                    exerciseDummyTrainEvent(params, weapon)
                else
                    setPlayerExerciseTrain(params.cid, addEvent(exerciseDummyTrainEvent, reloadMs, params, weapon))
                end
                return true
            else
                doRemoveItem(item.uid)
                doPlayerSendTextMessage(params.cid, MESSAGE_EVENT_ADVANCE, "Sua arma de exercício expirou, portanto, seu treinamento também.")
            end
        else
            doPlayerSendTextMessage(params.cid, MESSAGE_EVENT_ADVANCE, "Você terminou seu treinamento.")
        end
    end
    return setPlayerExerciseTrain(params.cid, nil)
end

function onUse(cid, item, fromPos, target, toPos, isHotkey)
    if not target then
        return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
    end
    local playerPosition = getCreaturePosition(cid)
    if not getTileInfo(playerPosition).protection then
        return doPlayerSendCancel(cid, "Você só pode treinar em área Protection Zone.")
    end
    local dummy = dummies[target.itemid]
    local weapon = weapons[item.itemid]
    if not weapon or not dummy then
        return doPlayerSendDefaultCancel(cid, RETURNVALUE_CANNOTUSETHISOBJECT)
    end
    local dummyPosition = getThingPosition(target.uid)
    if getDistanceBetween(playerPosition, dummyPosition) > 1 then
        return doPlayerSendDefaultCancel(cid, RETURNVALUE_THEREISNOWAY)
    end
    if not getPlayerExerciseTrain(cid) then
        local params = {}
        params.cid = cid
        params.currentPos = playerPosition
        params.dummyPos = dummyPosition
        params.item = item.uid
        params.itemid = item.itemid
        params.dummy = dummy
        exerciseDummyTrainEvent(params, weapon)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Você começou a treinar com manequim.")
    else
        doPlayerSendCancel(cid, "Você não pode treinar.")
    end
    return true
end