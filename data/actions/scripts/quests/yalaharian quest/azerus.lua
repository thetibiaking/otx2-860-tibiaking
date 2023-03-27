local waves = {
	{x=32779, y=31166, z=10},
	{x=32787, y=31166, z=10},
	{x=32782, y=31162, z=10},
	{x=32784, y=31162, z=10},
	{x=32782, y=31170, z=10},
	{x=32784, y=31170, z=10}
}

local creatureNames = {
	[1] = "Rift Worm",
	[2] = "Rift Scythe",
	[3] = "Rift Brood",
	[4] = "War Golem"
}

local effectPositions = {
	{32779, 31161, 10},
	{32787, 31171, 10}
}

local function getPlayersInArea()
	i = 0
	for x = 32768, 32801 do
		for y = 31155, 31183 do
			targetPos = {x = x, y = y, z = 10, stackpos = 253}
			creature = getTopCreature(targetPos).uid
			if isPlayer(creature) then
				i = i + 1
			end								
		end
	end
	return i
end

local function doClearAreaAzerus()
	if getGlobalStorageValue(50533) == 1 then
		for x = 32768, 32801 do
			for y = 31155, 31183 do
				targetPos = {x = x, y = y, z = 10, stackpos = 253}
				creature = getTopCreature(targetPos).uid
				if isMonster(creature) then
					doSendMagicEffect(getThingPos(creature), CONST_ME_POFF)	
					doRemoveCreature(creature)
				end								
			end
		end
		setGlobalStorageValue(50533, 0)
	end
	return true
end

local function doChangeAzerus()
	for x = 32768, 32801 do
		for y = 31155, 31183 do
			targetPos = {x = x, y = y, z = 10, stackpos = 253}
			creature = getTopCreature(targetPos).uid
			if isMonster(creature) and getCreatureName(creature):lower() == "azerus" then
				doCreatureSay(creature, "No! I am losing my energy!", TALKTYPE_MONSTER_YELL, false, 0, getThingPos(creature))
				doCreateMonster("Azerus3", getThingPos(creature), false, true)
				doRemoveCreature(creature)
			end								
		end
	end
	return false
end

local function summonMonster(name, position)
	doCreateMonster(name, position, false, true)
	doSendMagicEffect(position, CONST_ME_TELEPORT)
end

function onUse(cid, item, fromPos, itemEx, toPos)	
	if getGlobalStorageValue(50533) == 1 then
		doCreatureSay(cid, "You have to wait some time before this globe charges.", TALKTYPE_MONSTER_YELL, false, 0, getThingPos(cid))
		return true
	end

	local amountOfPlayers = 3
	if getPlayersInArea() < amountOfPlayers then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You need atleast " .. amountOfPlayers .. " players inside the quest room.")
		return true
	end
	
	setGlobalStorageValue(50533, 1)
	addEvent(doCreateMonster, 18 * 1000, "Azerus2", {x=32783, y=31167, z=10}, false, true)
	
	local azeruswavemonster
	for i = 1, #creatureNames do
		azeruswavemonster = creatureNames[i]
		for k = 1, #waves do
			addEvent(summonMonster, (i - 1) * 60 * 1000, azeruswavemonster, waves[k])
		end
	end
	
	for i = 1, #effectPositions do
		doSendMagicEffect(effectPositions[i], CONST_ME_HOLYAREA)
	end
	
	addEvent(doChangeAzerus, 4 * 20 * 1000)
	addEvent(doClearAreaAzerus, 5 * 60 * 1000)
	return true	
end