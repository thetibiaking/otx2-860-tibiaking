local function placeBonus(position)
	local bonusId = bomberman.bonuses[math.random(#bomberman.bonuses)]
	doCreateItem(bonusId, 1, position)
	addEvent(function()
		local item = getTileItemById(position, bonusId)
		if item and item.uid and item.uid > 0 then
			doRemoveItem(item.uid)
		end
	end, 30000)
end

local function getPlayersInArea(frompos, topos) -- By Killua
    local players_ = {}
    local count = 1
    for _, pid in pairs(getPlayersOnline()) do
        if isInArea(getCreaturePosition(pid), frompos, topos) then
            players_[count] = pid
            count = count + 1
        end
    end
    return countTable(players_) > 0 and players_ or false
end

function countTable(table) -- By Killua
    local y = 0
    if type(table) == "table" then
        for _ in pairs(table) do
            y = y + 1
        end
        return y
    end
    return false
end

local function removeBonuses(position)
	for _, id in next, bomberman.bonuses do
		local bonus = getTileItemById(position, id)
		if bonus and bonus.uid and bonus.uid > 0 then
			doRemoveItem(bonus.uid)
		end
	end
end

local function cleanArena(arenaNumber)
	for xx = bomberman.arenas[arenaNumber].fromPos.x, bomberman.arenas[arenaNumber].toPos.x do
		for yy = bomberman.arenas[arenaNumber].fromPos.y, bomberman.arenas[arenaNumber].toPos.y do
			local position = {x = xx, y = yy, z = bomberman.arenas[arenaNumber].fromPos.z}
			local stone = getTileItemById(position, bomberman.stoneId)
			if stone and stone.uid and stone.uid > 0 then
				doRemoveItem(stone.uid)
			end
		end
	end
end

local function decreaseStorage(cid, limit)
	if limit == 0 then
		return;
	end
	if getCreatureStorage(cid, bomberman.inGameStorage) == -1 then
		return;
	end
	doCreatureSetStorage(cid, bomberman.bombStorage, getCreatureStorage(cid, bomberman.bombStorage) - 1)
	addEvent(decreaseStorage, 1000, cid, limit - 1)
end

local function checkForWinner(arenaNumber)
	local players = getPlayersInArea(bomberman.arenas[arenaNumber].fromPos, bomberman.arenas[arenaNumber].toPos)
	if players and #players == 1 then
		doPlayerSendTextMessage(players[1], MESSAGE_INFO_DESCR, "Parabéns, você foi o vencedor desta rodada de Bomberman!")
		doPlayerAddItem(players[1], 2160, 5)
		doPlayerAddExperience(players[1], 35000)
		setGlobalStorageValue(bomberman.arenas[arenaNumber].storage, -1)
		doChangeSpeed(players[1], getCreatureStorage(players[1], bomberman.oldSpeedStorage) - getCreatureSpeed(players[1]))
		doCreatureSetStorage(players[1], bomberman.oldSpeedStorage, -1)
		doTeleportThing(players[1], bomberman.arenas[arenaNumber].exit)
		doCreatureSetStorage(players[1], bomberman.inGameStorage, -1)
		Events:leave(players[1])
		cleanArena(arenaNumber)
	end
end

local function die(cid)
	if getCreatureStorage(cid, bomberman.imuneStorage) >= os.time() then
		doSendMagicEffect(getThingPos(cid), CONST_ME_POFF)
		doSendAnimatedText(getThingPos(cid), "IMUNE", 16)
		return
	end

	local arenaNumber = getCreatureStorage(cid, bomberman.inGameStorage)
	for _, pid in next, getPlayersOnline() do
		if getCreatureStorage(pid, bomberman.inGameStorage) == arenaNumber then
			doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_ORANGE, getCreatureName(cid).." morreu!")
		end
	end
	doChangeSpeed(cid, getCreatureStorage(cid, bomberman.oldSpeedStorage) - getCreatureSpeed(cid))
	doCreatureSetStorage(cid, bomberman.oldSpeedStorage, -1)
	doSendAnimatedText(getThingPos(cid), "BOOOM", 150)
	doTeleportThing(cid, bomberman.arenas[arenaNumber].exit)
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você foi explodido!")
	doCreatureSetStorage(cid, bomberman.inGameStorage, -1)
	Events:leave(cid)
	checkForWinner(arenaNumber)
end

local function burn(pos, radius, direction)

	local position
	for o = 1, radius do
		if direction == 1 then
			position = {x = pos.x, y = pos.y + o, z = pos.z}
		elseif direction == 2 then
			position = {x = pos.x + o, y = pos.y, z = pos.z}
		elseif direction == 3 then
			position = {x = pos.x, y = pos.y - o, z = pos.z}
		elseif direction == 4 then
			position = {x = pos.x - o, y = pos.y, z = pos.z}
		end

		local stone = getTileItemById(position, bomberman.stoneId)
		if stone and stone.uid and stone.uid > 0 then
			doRemoveItem(stone.uid)
			if math.random(100) <= 20 then
				addEvent(placeBonus,1000,position)
			end
			doSendMagicEffect(position, CONST_ME_FIREAREA)
			return
		end
		local player = getTopCreature(position)
		if player and player.uid and player.uid > 0 and isPlayer(player.uid) then
			die(player.uid)
		end
		local bomb = getTileItemById(position, bomberman.bombId)
		if bomb and bomb.uid and bomb.uid > 0 then
			local recursive_radius = tonumber(getItemAttribute(bomb.uid, "radius"))
			doRemoveItem(bomb.uid)
			for i = 1,4 do
				burn(position, recursive_radius, i)
			end
		end
		local thing = getThingFromPos({x = position.x, y = position.y, z = position.z, stackpos = 1})
		if thing.uid > 0 and thing.itemid > 1 and not isMoveable(thing.uid) and not isInArray(bomberman.bonuses, thing.itemid) then
			return;
		end
		doSendMagicEffect(position, CONST_ME_FIREAREA)
		removeBonuses(position)
	end
end

local function explode(pos, radius)
	local bomb = getTileItemById(pos, bomberman.bombId)
	if bomb and bomb.uid and bomb.uid > 0 then
		doRemoveItem(bomb.uid)
		doSendMagicEffect(pos, CONST_ME_FIREAREA)
		for i = 1,4 do
			burn(pos, radius, i)
		end
	end
end

local function sendCountDown(position, time)
	doSendAnimatedText(position, time, 150)
	if time > 0 then
		addEvent(sendCountDown,1000,position,time - 1)
	end
end

function onSay(cid, words, param, channel)
if(not checkExhausted(cid, 666, 1)) then
	return true
end

	if getCreatureStorage(cid, bomberman.inGameStorage) > -1 then
		local bombs = getCreatureStorage(cid, bomberman.bombStorage)
		local bombLimit = getCreatureStorage(cid, bomberman.bombLimitStorage)
		if bombs <= ((bombLimit * 3) + 997) then
			local pos = getThingPos(cid)
			local radius = getCreatureStorage(cid, bomberman.radiusStorage)
			local bomb_item = doCreateItem(bomberman.bombId, 1, pos)
			doItemSetAttribute(bomb_item, "radius", radius)
			sendCountDown(pos,3)
			addEvent(decreaseStorage, 1100, cid, 3)
			addEvent(explode, 3000, pos, radius)
			doCreatureSetStorage(cid, bomberman.bombStorage, bombs + 3)
		else
			doPlayerSendCancel(cid, "Aguarde um pouco antes de colocar uma bomba.")
		end
	end
	return true
end
