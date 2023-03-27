local t, player = {
	pedestals = {
		{x=33061, y=30950, z=2},
		{x=33060, y=30950, z=2}
	},
	newPos = {
		{x=33035, y=30970, z=3},
		{x=33035, y=30971, z=3}
	},
	area = {
		fromX = 33034, toX = 30958,
		fromY = 33055, toY = 30981,
		z = 3
	},
	storageDone = 4767,
	level = 80
}, {0, 0}

function getCreaturesInRange(position, radiusx, radiusy, showMonsters, showPlayers, showSummons)
	local creaturesList = {}
	for x = -radiusx, radiusx do
		for y = -radiusy, radiusy do
			if not (x == 0 and y == 0) then
				creature = getTopCreature({x = position.x+x, y = position.y+y, z = position.z, stackpos = 253})
				if (creature.type == 1 and showPlayers == TRUE) or (creature.type == 2 and showMonsters == TRUE and (showSummons == FALSE or (showSummons == TRUE and getCreatureMaster(creature.uid) == (creature.uid)))) then
					table.insert(creaturesList, creature.uid)
				end
			end
		end
	end

	local creature = getTopCreature(position)
	if (creature.type == 1 and showPlayers == TRUE) or (creature.type == 2 and showMonsters == TRUE and (showSummons == FALSE or (showSummons == TRUE and getCreatureMaster(creature.uid) == (creature.uid)))) then
		if not(table.find(creaturesList, creature.uid)) then
			table.insert(creaturesList, creature.uid)
		end
	end
    return creaturesList
end

function Wave1()
       doSendMagicEffect(getCreaturePosition(doCreateMonster('Baron Brute', {x = 33046, y = 30970, z = 3})), CONST_ME_TELEPORT)
	doSendMagicEffect(getCreaturePosition(doCreateMonster('The Axeorcist', {x = 33047, y = 30971, z = 3})), CONST_ME_TELEPORT)
	addEvent(Wave2, 30 * 1000)
end

function Wave2()
       doSendMagicEffect(getCreaturePosition(doCreateMonster('Menace', {x = 33046, y = 30970, z = 3})), CONST_ME_TELEPORT)
	doSendMagicEffect(getCreaturePosition(doCreateMonster('Fatality', {x = 33047, y = 30971, z = 3})), CONST_ME_TELEPORT) 
	addEvent(Wave3, 35 * 1000)
end

function Wave3()
       doSendMagicEffect(getCreaturePosition(doCreateMonster('Incineron', {x = 33046, y = 30970, z = 3})), CONST_ME_TELEPORT)
	doSendMagicEffect(getCreaturePosition(doCreateMonster('Coldheart', {x = 33047, y = 30971, z = 3})), CONST_ME_TELEPORT)
	addEvent(Wave4, 40 * 1000)
end

function Wave4()
       doSendMagicEffect(getCreaturePosition(doCreateMonster('Dreadwing', {x = 33046, y = 30970, z = 3})), CONST_ME_TELEPORT)
	doSendMagicEffect(getCreaturePosition(doCreateMonster('Doomhowl', {x = 33047, y = 30971, z = 3})), CONST_ME_TELEPORT)
	addEvent(Wave5, 40 * 1000)
end

function Wave5()
       doSendMagicEffect(getCreaturePosition(doCreateMonster('Haunter', {x = 33046, y = 30970, z = 3})), CONST_ME_TELEPORT)
	addEvent(Wave6, 40 * 1000)
end

function Wave6()
       doSendMagicEffect(getCreaturePosition(doCreateMonster('The Dreadorian', {x = 33046, y = 30970, z = 3})), CONST_ME_TELEPORT)
	doSendMagicEffect(getCreaturePosition(doCreateMonster('Rocko', {x = 33047, y = 30971, z = 3})), CONST_ME_TELEPORT)
       doSendMagicEffect(getCreaturePosition(doCreateMonster('Tremorak', {x = 33047, y = 30971, z = 3})), CONST_ME_TELEPORT)
	addEvent(Wave7, 40 * 1000)
end

function Wave7()
	doSendMagicEffect(getCreaturePosition(doCreateMonster('Tirecz', {x = 33046, y = 30970, z = 3})), CONST_ME_TELEPORT)
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local failed = false
	for i = 1, #t.pedestals do
		player[i] = getTopCreature(t.pedestals[i]).uid
		if(not(player[i] > 0 and isPlayer(player[i]) == TRUE and getPlayerStorageValue(player[i], t.storageDone) < 1 and getPlayerLevel(player[i]) >= t.level)) then
			failed = true
			break
		end
	end
	if not failed then
		if #getCreaturesInRange({x=33045, y=30969,z=3}, 10, 9, FALSE, TRUE) > 0 then
			doPlayerSendTextMessage(cid,25, "Some people are already in the arena.")
			return true
		end
		for i = 1, #player do
			doTeleportThing(player[i], t.newPos[i])
		end
		Wave1()
		doTransformItem(item.uid, 1946)
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_CANNOTUSETHISOBJECT)
	end
	return true
end