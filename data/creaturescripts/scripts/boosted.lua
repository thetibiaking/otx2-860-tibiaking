function onKill(cid, target, damage, flags)
	
	if not (isMonster(target)) then
		return true
	end

	if (string.lower(getCreatureName(target)) == string.lower(getGlobalStorageValue(monster_name_backup))) then
		local exp = tonumber(getGlobalStorageValue(74813))
		doPlayerSetRate(cid, SKILL__LEVEL, getExperienceStage(getPlayerLevel(cid))*(getGlobalStorageValue(monster_exp_backup) / 1000))
		addLoot(getCreaturePosition(target), getCreatureName(target), {})
	else
		doPlayerSetRate(cid, SKILL__LEVEL, 1)
	end

	return true
end

function addLoot(position, name, ignoredList)
    local check = false
    for i = 0, 255 do
        position.stackpos = i
        corpse = getTileThingByPos(position)
        if corpse.uid > 0 and isCorpse(corpse.uid) then
            check = true 
            break
        end
    end
	if check == true then
        local newRate = (1 + (getGlobalStorageValue(monster_loot_backup)/100)) * getConfigValue("rateLoot")
        local mainbp = doCreateItemEx(1987, 1)
        local monsterLoot = getMonsterLootList(name)
        for i, loot in pairs(monsterLoot) do
            if math.random(1, 100000) <= newRate * loot.chance then 
                if #ignoredList > 0 then
                    if (not isInArray(ignoredList, loot.id)) then
                        doAddContainerItem(mainbp, loot.id, loot.countmax and math.random(1, loot.countmax) or 1)
                    end
                else
                    doAddContainerItem(mainbp, loot.id, loot.countmax and math.random(1, loot.countmax) or 1)
                end
            end
        end
        doAddContainerItemEx(corpse.uid, mainbp)  
    end
end