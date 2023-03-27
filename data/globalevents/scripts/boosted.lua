
function onThink(interval, lastExecution)
	local current_hour = os.date("%X")
	if config_boosted[current_hour] then
		local time = config_boosted[current_hour]
		
		local monster = getTopCreature(time.pos_monster).uid
		local random_monster = monsters_boosteds[math.random(1, #monsters_boosteds)]
		if (monster >= 1) then
			doRemoveCreature(monster)
		end
		SummonMonster(time, random_monster)
		setGlobalStorageValue(monster_name_backup, random_monster.monster_name)
		setGlobalStorageValue(monster_exp_backup, random_monster.exp)
		setGlobalStorageValue(monster_loot_backup, random_monster.loot)
	end
	return true
end 	


function SummonMonster(time, monster)
	doCreateMonster(monster.monster_name, time.pos_monster)
	effectsMonster(time, monster)
end

function effectsMonster(time, monster)

	effectLoot(time.pos_monster, monster)
	effectExp(time.pos_monster, monster)
	doSendMagicEffect(time.pos_monster, 30)
	doSendAnimatedText(time.pos_monster, "Boosted", COLOR_DARKYELLOW)

	addEvent(function()
		effectsMonster(time, monster)
	end, time.time_effects * 1000)
end

function effectLoot(pos, monster)
	local pos_effect = {x=pos.x, y=pos.y-1, z=pos.z}
	doSendMagicEffect(pos_effect, 29)
	doSendAnimatedText(pos_effect, "Loot +"..monster.loot.."%", COLOR_DARKYELLOW)
end

function effectExp(pos, monster)
	local pos_effect = {x=pos.x, y=pos.y+1, z=pos.z}
	doSendMagicEffect(pos_effect, 29)
	doSendAnimatedText(pos_effect, "EXP +"..monster.exp.."%", COLOR_DARKYELLOW)
end