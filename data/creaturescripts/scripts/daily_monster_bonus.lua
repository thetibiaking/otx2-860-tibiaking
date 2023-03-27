loot_bonus = 50
ignoredList = {1987}
function addBonusLoot(position, name)
        for i = 0, 255 do
        position.stackpos = i
        corpse = getTileThingByPos(position)
        if corpse.uid > 0 and isCorpse(corpse.uid) then
            break
        end
    end
        local newRate = (1 + (loot_bonus/100)) * getConfigValue("rateLoot")
        local monsterLoot = getMonsterLootList(name)
        local mainbp = doCreateItemEx(1987, 1)
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
            doAddContainerItemEx(corpse.uid, mainbp) 
        end
end

BOOSTED_MONSTER = 56404
boostedMonstersList = {"rat", "spider", "troll", "orc", "minotaur", "dwarf", "elf", "skeleton", "amazon", "valkirie", "dark apprentice", "ghoul", "cyclops", "dwarf guard", "necromancer", "vampire", "werewolf", "dragon", "dragon lord", "wyrm", "giant spider", "hydra", "warlock", "demon"}
experienceBonus = 50

function onDeath(cid, corpse, deathList)

local master = getCreatureMaster(cid)
  if (master and master ~= cid) then
    return true
  end

  local boostedMonster = boostedMonstersList[getGlobalStorageValue(BOOSTED_MONSTER)]
    if getCreatureName(cid):lower() == boostedMonster then
    
for i = 1, #deathList do
    
-- exp bonus
    local bonusExperience = getMonsterInfo(getCreatureName(cid)).experience/i * getPlayerRates(deathList[i])[SKILL__LEVEL] * experienceBonus/100
    doPlayerAddExperience(deathList[i], bonusExperience)
    doSendAnimatedText(getPlayerPosition(deathList[i]), bonusExperience, 215)
    
-- loot bonus
    addEvent(addBonusLoot, 10, getCreaturePosition(cid), getCreatureName(cid))
    
end
    
    end
    return true
end