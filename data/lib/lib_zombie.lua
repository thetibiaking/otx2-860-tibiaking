-- Lib Zombie-Event by WooX

zombieEvent = {
	config = {
		startTime = {
			[1] = {"09:00", "22:40"}, -- domingo
			[2] = {"09:00", "20:32"}, -- segunda
			[3] = {"09:00", "22:40"}, -- terça
			[4] = {"09:00", "22:40"}, -- quarta
			[5] = {"09:00", "22:40"}, -- quinta
			[6] = {"09:00", "23:04"}, -- sexta
			[7] = {"09:00", "22:40"}  -- sabado
		},
		
		messages = {
			announcement = "O ataque de zombies esta prestes a começar, o teleporte será fechado em %d minuto",
			startEvent = "O teleporte fechou, boa sorte aos participantes!",
			playerBitten = "O jogador %s acaba de ser mordido e agora está no time dos zombies!",
			endEvent = "%s foi o sobrevivente do ataque de zombies! Párabens!",
			notEnoughPlayers = "Apenas %d jogadores não é o suficiente para se defender de um ataque zombie, os zombies venceram antes mesmo do ataque começar",
			
			zombiesRant = {"Mst.... klll....", "Whrrrr... ssss.... mmm.... grrrrl", "Dnnnt... cmmm... clsrrr....", "Httt.... hmnnsss...", "Uhhhhhhh!", "Aaaaahhhh!", "Hoooohhh!", "Chhhhhhh!"}
		},
		
		minOnlinePlayers = 1, -- Quantidade minima de jogadores online para iniciar o evento
		minPlayers = 1, -- Quantidade minima de jogadores para iniciar o evento
		
		closeTeleportTime = 5, -- Tempo em minutos para fechar o teleporte de entrada do evento apos aviso de inicio
		countDownTime = 30, -- Tempo em segundos para iniciar o evento apos o fechamento do teleporte de entrada
		
		zombieRatio = 1, -- Quantidade inicial de Zombies = [quantidade de players no evento multiplicado pelo valor definido aqui]
		playerSpeed = 300,
		delayToTransform = 3, -- Tempo em segundos para o jogador que foi mordido virar um zombie
		allowMultiClient = false,
		
		rewards = {
			human = {{2160, 10}, {6527, 20}}, -- {id, count}
			zombie = {{6527, 5}} -- {id, count}
		},
		
		zombiesRank = {
			[0] = {lookType = 100, speed = 250},
			[{1, 2}] = {lookType = 18, speed = 270},
			[{3, 4}] = {lookType = 68, speed = 290},
			[{5, math.huge}] = {lookType = 246, speed = 310}
		},
		
		area = {
			fromPos = {x = 32120, y = 32195}, -- Coordenadas ponto superior-esquerdo
			toPos = {x = 32190, y = 32195}, -- Coordenadas ponto inferior-direito
			z = 7,
		},
		
		teleportAid = 1800,
		teleportPos = {x = 32359, y = 32239, z = 7}, -- Onde o teleporte pra entrada do evento vai ser criado.
	},
	
	storages = {
		global = {
			playerCount = 17800,
			zombiePlayers = 17801
		},		
		playerState = 1780, -- [1] = Human, [2] = Zombie
		zombieScore = 1781,
		originalSpeed = 1782
	}
}

-- Funções --
zombieEvent.isMultiClient = function(cid)
    for _, pid in pairs(getPlayersOnline()) do
        if cid ~= pid and getPlayerIp(cid) == getPlayerIp(pid) and getPlayerStorageValue(pid, zombieEvent.storages.playerState) > 0 then
            return true
        end
    end
    return false
end

zombieEvent.doRemovePlayer = function(cid)
	local events = {"zombieEvent_areacombat", "zombieEvent_combat", "zombieEvent_follow", "zombieEvent_throw"}
	for i = 1, #events do
		unregisterCreatureEvent(cid, events[i])
	end
	if getPlayerStorageValue(cid, zombieEvent.storages.playerState) > 1 then
		setPlayerStorageValue(cid, zombieEvent.storages.zombieScore)
		doRemoveCondition(cid, CONDITION_OUTFIT)
	end
	if getCreatureNoMove(cid) then
		doCreatureSetNoMove(cid, false)
	end
	doChangeSpeed(cid, -getCreatureSpeed(cid))
	doChangeSpeed(cid, getPlayerStorageValue(cid, zombieEvent.storages.originalSpeed))
	setPlayerStorageValue(cid, zombieEvent.storages.originalSpeed)
	setPlayerStorageValue(cid, zombieEvent.storages.playerState)
	doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
	doSendMagicEffect(getThingPos(cid), CONST_ME_TELEPORT)
end

zombieEvent.countDown = function(time, players)
	if time < 0 then
		return
	end
	local colors = {
		[{0, 10}] = 180,
		[{11, 15}] = 210,
		[{16, math.huge}] = 143
	}
	
	local color
	for k, v in pairs(colors) do
		if time >= k[1] and time <= k[2] then
			color = v
		end
	end
	
	local startEvent = false
	for n in pairs(players) do
		local cid = players[n]
		if time > 0 then
			doSendAnimatedText(getThingPos(cid), time, color, cid)
		else
			startEvent = true
			doCreatureSetNoMove(cid, false)
			doSendAnimatedText(getThingPos(cid), "START!", color, cid)
		end
	end
	if startEvent then
		zombieEvent.doSpawnZombies()
	else
		addEvent(zombieEvent.countDown, 1000, time-1, players)
	end
end

zombieEvent.onTime = function()
	if #getPlayersOnline() < zombieEvent.config.minOnlinePlayers then
		return
	end
	local day = zombieEvent.config.startTime[os.date("%w") + 1]
	if day and isInArray(day, os.date("%X"):sub(1, 5)) then
		local teleport = doCreateItem(1387, 1, zombieEvent.config.teleportPos)
		doSetItemActionId(teleport, zombieEvent.config.teleportAid)
		local plural = zombieEvent.config.closeTeleportTime > 1 and "s" or ""
		doBroadcastMessage(zombieEvent.config.messages.announcement:format(zombieEvent.config.closeTeleportTime)..plural, MESSAGE_EVENT_ADVANCE)
		setGlobalStorageValue(zombieEvent.storages.global.playerCount, 0)
		setGlobalStorageValue(zombieEvent.storages.global.zombiePlayers, 0)
		addEvent(zombieEvent.start, zombieEvent.config.closeTeleportTime * 60 * 1000)
	end
end

zombieEvent.start = function()
	doBroadcastMessage(zombieEvent.config.messages.startEvent, MESSAGE_EVENT_ADVANCE)
	doRemoveItem(getTileItemById(zombieEvent.config.teleportPos, 1387).uid, 1)
	local players = {}
	for _, cid in pairs(getPlayersOnline()) do
		if getPlayerStorageValue(cid, zombieEvent.storages.playerState) > 0 then
			players[#players+1] = cid
		end
	end	
	if getGlobalStorageValue(zombieEvent.storages.global.playerCount) >= zombieEvent.config.minPlayers then
		for _, cid in pairs(players) do
			doCreatureSetNoMove(cid, true)
			doChangeSpeed(cid, -getCreatureSpeed(cid))
			doChangeSpeed(cid, zombieEvent.config.playerSpeed)
		end
		zombieEvent.countDown(zombieEvent.config.countDownTime, players)
	else
		doBroadcastMessage(zombieEvent.config.messages.notEnoughPlayers:format(getGlobalStorageValue(zombieEvent.storages.global.playerCount)), MESSAGE_EVENT_ADVANCE)
		setGlobalStorageValue(zombieEvent.storages.global.playerCount, 0)
		for _, cid in pairs(players) do
			zombieEvent.doRemovePlayer(cid)
		end
	end
end

zombieEvent.doSpawnZombies = function()
	local playerCount = getGlobalStorageValue(zombieEvent.storages.global.playerCount)
	local maxZombies = math.floor(playerCount * zombieEvent.config.zombieRatio)
	for i = 1, maxZombies do
		local position = {x = math.random(zombieEvent.config.area.fromPos.x, zombieEvent.config.area.toPos.x), y = math.random(zombieEvent.config.area.fromPos.y, zombieEvent.config.area.toPos.y), z = zombieEvent.config.area.z}
		while not isWalkable(position, true, true) do
			position = {x = math.random(zombieEvent.config.area.fromPos.x, zombieEvent.config.area.toPos.x), y = math.random(zombieEvent.config.area.fromPos.y, zombieEvent.config.area.toPos.y), z = zombieEvent.config.area.z}
		end
		local zombie = doCreateMonster("Event Zombie", position)
		registerCreatureEvent(zombie, "zombieEvent_attack")
		registerCreatureEvent(zombie, "zombieEvent_combat")
		doSendMagicEffect(position, CONST_ME_MORTAREA)
	end
end

zombieEvent.doRant = function(cid)
	if not isPlayer(cid) or getPlayerStorageValue(cid, zombieEvent.storages.playerState) ~= 2 then
		return
	end
	local rant = zombieEvent.config.messages.zombiesRant[math.random(#zombieEvent.config.messages.zombiesRant)]
	doCreatureSay(cid, rant, TALKTYPE_MONSTER_SAY)
	local randomDelay = math.random(2, 7)
	addEvent(zombieEvent.doRant, randomDelay * 1000, cid)
end

zombieEvent.tranformToZombie = function(cid, delay)
	if not isPlayer(cid) or getPlayerStorageValue(cid, zombieEvent.storages.playerState) ~= 2 then
		return
	end
	if delay > 0 then
		local screams = {"AAAAH!", "AAARRGH!", "SOCORRO!"}
		doCreatureSay(cid, screams[math.random(#screams)], TALKTYPE_SAY)
		doSendMagicEffect(getThingPos(cid), CONST_ME_EXPLOSIONAREA)
		addEvent(zombieEvent.tranformToZombie, 1000, cid, delay - 1)
	else
		local data = zombieEvent.config.zombiesRank[0]
		doSendMagicEffect(getThingPos(cid), CONST_ME_MORTAREA)
		doSetCreatureOutfit(cid, {lookType = data.lookType})
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, data.speed)
		doCreatureSetNoMove(cid, false)
		zombieEvent.doRant(cid)
	end
end

zombieEvent.zombieBite = function(cid, target)
	if getPlayerStorageValue(target, zombieEvent.storages.playerState) == 2 then
		return
	end
	setGlobalStorageValue(zombieEvent.storages.global.zombiePlayers, getGlobalStorageValue(zombieEvent.storages.global.zombiePlayers)+1)
	setPlayerStorageValue(target, zombieEvent.storages.playerState, 2)
	doCreatureSetNoMove(target, true)
	zombieEvent.tranformToZombie(target, zombieEvent.config.delayToTransform)
	doCreatureSay(cid, "Chomp..", TALKTYPE_MONSTER_SAY)
	for _, cid in pairs(getPlayersOnline()) do
		if getPlayerStorageValue(cid, zombieEvent.storages.playerState) > 0 then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, zombieEvent.config.messages.playerBitten:format(getPlayerName(target)))
		end
	end
	if isPlayer(cid) then
		setPlayerStorageValue(cid, zombieEvent.storages.zombieScore, math.max(1, getPlayerStorageValue(cid, zombieEvent.storages.zombieScore) + 1))
		local score = math.max(0, getPlayerStorageValue(cid, zombieEvent.storages.zombieScore))
		for k, v in pairs(zombieEvent.config.zombiesRank) do
			if type(k) == "table" and score >= k[1] and score <= k[2] then
				doChangeSpeed(cid, -getCreatureSpeed(cid))
				doChangeSpeed(cid, v.speed)
				doSetCreatureOutfit(cid, {lookType = v.lookType})
				doSendMagicEffect(getThingPos(cid), CONST_ME_INSECTS)
				break
			end
		end
	end
	setGlobalStorageValue(zombieEvent.storages.global.playerCount, getGlobalStorageValue(zombieEvent.storages.global.playerCount)-1)
	if getGlobalStorageValue(zombieEvent.storages.global.playerCount) < 2 then
		zombieEvent.finishEvent()
	end
end

zombieEvent.finishEvent = function()
	local winner
	local loser
	local zombieScore = {}
	
	for _, cid in pairs(getPlayersOnline()) do
		if getPlayerStorageValue(cid, zombieEvent.storages.playerState) > 0 then			
			if getPlayerStorageValue(cid, zombieEvent.storages.playerState) == 2 then
				zombieScore[#zombieScore+1] = {player = cid, score = tonumber(getPlayerStorageValue(cid, zombieEvent.storages.zombieScore))}
			else
				winner = cid
			end
			zombieEvent.doRemovePlayer(cid)
		end
	end
	table.sort(zombieScore, function(a, b) return a.score > b.score end)
	loser = zombieScore[1].score > 0 and zombieScore[1].player or false
	for _, v in pairs(zombieEvent.config.rewards.human) do
		doPlayerAddItem(winner, v[1], v[2])
	end
	if loser then
		for _, v in pairs(zombieEvent.config.rewards.zombie) do
			doPlayerAddItem(loser, v[1], v[2])
		end
	end
	doBroadcastMessage(zombieEvent.config.messages.endEvent:format(getPlayerName(winner)))
	setGlobalStorageValue(zombieEvent.storages.global.zombiePlayers, 0)
	setGlobalStorageValue(zombieEvent.storages.global.playerCount, 0)
	local pos
	for x = zombieEvent.config.area.fromPos.x, zombieEvent.config.area.toPos.x do
		for y = zombieEvent.config.area.fromPos.y, zombieEvent.config.area.toPos.y do
			pos = {x = x, y = y, z = zombieEvent.config.area.z}
			local zombie = isMonster(getTopCreature(pos).uid) and true or false
			if zombie then
				doRemoveCreature(getTopCreature(pos).uid)
			end
		end
	end
end