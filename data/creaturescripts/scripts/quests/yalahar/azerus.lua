local topLeft = {x = 32768, y = 31155, z = 10}
local rightBottom = {x = 32801, y = 31183, z = 10}


local function removeTeleport(pos)
	local tpItem = getTileItemById(pos, 9738).uid
	if tpItem > 0 then
		doRemoveItem(tpItem)
		doSendMagicEffect(pos, CONST_ME_POFF)
	end
end

local function removeCorpse(pos)
	local corpse = getTileItemById(pos, 6068).uid
	if corpse > 0 then 
		doRemoveItem(corpse) 
	end
end

local function removeCreatures(pos1, pos2)
	for x = pos1.x, pos2.x do
		for y = pos1.y, pos2.y do
			for z = pos1.z, pos2.z do
				targetPos = {x = x, y = y, z = z, stackpos = 253}
				creature = getTopCreature(targetPos).uid
				if isMonster(creature) and getCreatureName(creature):lower() ~= "azerus" then
					doSendMagicEffect(getThingPos(creature), CONST_ME_POFF)	
					doRemoveCreature(creature)
				end								
			end
		end
	end
end

function onKill(cid, target)
	local targetName = getCreatureName(target):lower()
	if targetName == "azerus" and isMonster(target) then
		local createPosition = getThingPos(target)
		createPosition.stackpos = 255
		addEvent(removeCorpse, 10, createPosition)
		doSendMagicEffect(createPosition, CONST_ME_TELEPORT)
		doCreateItem(9738, createPosition)
		doCreatureSay(target, "Azerus ran into teleporter! It will disappear in 2 minutes. Enter it!", TALKTYPE_MONSTER_YELL, false, 0, createPosition)
		addEvent(removeTeleport, 2 * 60 * 1000, createPosition)
		removeCreatures(topLeft, rightBottom)
	end
	return true	
end