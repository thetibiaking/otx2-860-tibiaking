local cfg = {
    rate = 2,
    ringOn = 9955,
	ringOff = 8752,
}

function onDeEquip(cid, item, slot)
local rates = getPlayerRates(cid) 
local newrates = 0
    if (item.itemid == cfg.ringOn) then
		newrates = rates[SKILL__LEVEL] / cfg.rate
		doPlayerSetRate(cid, SKILL__LEVEL, newrates)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Experience rate set back to normal.") 
		doTransformItem(item.uid, cfg.ringOff)
    end
	return true
end

function onEquip(cid, item, slot) 
local rates = getPlayerRates(cid) 
local normalrate = getConfigValue("rateExperience")
local newrates = 0
    if(item.itemid == cfg.ringOn) then
		if getConfigValue("experienceStages") == true then
			normalrate = getExperienceStage(getPlayerLevel(cid))
		end
			newrates = rates[SKILL__LEVEL]*cfg.rate
			doPlayerSetRate(cid, SKILL__LEVEL, newrates)
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Your double experience rate has been activated. Your exp rate is now: " .. (normalrate*cfg.rate) .. "x.") 
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Your double experience rate has been activated. Your exp rate is now: " .. (normalrate*cfg.rate) .. "x.") 
			doSendMagicEffect(getCreaturePosition(cid),CONST_ME_FIREWORK_YELLOW)
	  return true
    end
	return false
end
