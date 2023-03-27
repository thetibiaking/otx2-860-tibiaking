ZB_GLOBAL_STORAGE_STATUS = 99900
ZB_GLOBAL_STORAGE_LIMITE_PARTICIPANTES = 99901
ZB_GLOBAL_STORAGE_TOTAL_ZOMBIES_SUMMONAR = 99902
ZB_GLOBAL_STORAGE_TOTAL_ZOMBIES_ARENA = 99903

ZB_STORAGE_STATUS_PLAYER = 99900

ZB_TOTAL_PARTICIPANTES = 20
ZB_TEMPO_FORCAR_EVENTO = 1*60*1000

ZB_ID_TELEPORTE = 1387
ZB_LOCAL_TELEPORTE = {x=32359, y=32239, z=7}
ZB_LOCAL_SALA_ESPERA = {x=32151, y=32257, z=7}

ZB_LOCAL_ARENA_TE = {x = 32120, y = 32198, z = 7}
ZB_LOCAL_ARENA_BD = {x = 32190, y = 32200, z = 7}

ZB_IGNORAR_ACESSO = 3

-- PREMIOS
local ZB_PREMIOS = {
	trofeu = 5805,
	itens = {8889,8821,8865},
	dinheiro = {2160, 10, true}
}

function getStatusZombieEvent()
	return getGlobalStorageValue(ZB_GLOBAL_STORAGE_STATUS)
end

function setStatusZombieEvent(estagio)
	setGlobalStorageValue(ZB_GLOBAL_STORAGE_STATUS, estagio)
end

function getLimiteParticipantesZombieEvent()
	return getGlobalStorageValue(ZB_GLOBAL_STORAGE_LIMITE_PARTICIPANTES)
end

function setLimiteParticipantesZombieEvent(total)
	setGlobalStorageValue(ZB_GLOBAL_STORAGE_LIMITE_PARTICIPANTES, total)
end

function abreTeleporteZombieEvent()
	 if(getTileItemById(ZB_LOCAL_TELEPORTE, ZB_ID_TELEPORTE).uid == 0) then
		local teleporte = doCreateTeleport(ZB_ID_TELEPORTE, ZB_LOCAL_SALA_ESPERA, ZB_LOCAL_TELEPORTE)
		doItemSetAttribute(teleporte, "aid", "9990")
	 end
end

function fechaTeleporteZombieEvent()
	local item = getTileItemById(ZB_LOCAL_TELEPORTE, ZB_ID_TELEPORTE)
	if(item.uid ~= 0) then
		doRemoveItem(item.uid)
	end
end

function getStatusJogadorZombieEvent(cid)
	return getCreatureStorage(cid, ZB_STORAGE_STATUS_PLAYER)
end

function setStatusJogadorZombieEvent(cid, status)
	doCreatureSetStorage(cid, ZB_STORAGE_STATUS_PLAYER, status)
end

function getJogadoresSalaEsperaZombieEvent()
	local jogadoresSalaEspera = {}
	for i, cid in pairs(getPlayersOnline()) do
		if(getStatusJogadorZombieEvent(cid) == 1) then
			table.insert(jogadoresSalaEspera, cid)
		end
	end
	return jogadoresSalaEspera
end

function getJogadoresZombieEvent()
	local jogadores = {}
	for i, cid in pairs(getPlayersOnline()) do
		if(getStatusJogadorZombieEvent(cid) > 1) then
			table.insert(jogadores, cid)
		end
	end
	return jogadores
end

function resetaStorageZombieEvent()
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `key` = " .. ZB_STORAGE_STATUS_PLAYER .. ";")

	setStatusZombieEvent(0)
	setTotalZombiesSummonar(0)
	setTotalZombiesArena(0)

	setLimiteParticipantesZombieEvent(ZB_TOTAL_PARTICIPANTES)
end

function forcarInicioZombieEvent()
	local statusZombieEvent = getStatusZombieEvent()
	if(statusZombieEvent == 1) then
		local estagio = statusZombieEvent+1
		local jogadoresSalaEspera = getJogadoresSalaEsperaZombieEvent()
		if(#jogadoresSalaEspera > 0) then
			iniciarZombieEvent(estagio, #jogadoresSalaEspera)
		else
			resetaStorageZombieEvent()
		end
		fechaTeleporteZombieEvent()
	end
end

function teleportaJogadorSalaEspera(cid)
	local acessoJogador = getPlayerAccess(cid)
	if(acessoJogador < ZB_IGNORAR_ACESSO) then
		setStatusJogadorZombieEvent(cid, 1)
		
		local totalJogadoresSalaEspera = #getJogadoresSalaEsperaZombieEvent()
		local limiteJogadoresZombieEvent = getLimiteParticipantesZombieEvent()
		
		local vagasDisponivel = limiteJogadoresZombieEvent - totalJogadoresSalaEspera
		if(vagasDisponivel > 0) then
			doBroadcastMessage(getCreatureName(cid) .. " esta participando do evento Zombie. Ainda resta " .. vagasDisponivel .. " vaga(s) para o evento.")
		end
	end
	doSendMagicEffect(getThingPosition(cid), CONST_ME_TELEPORT)
	doTeleportThing(cid, ZB_LOCAL_SALA_ESPERA, true)
	doSendMagicEffect(getThingPosition(cid), CONST_ME_TELEPORT)
end

function isWalkable(pos)
	if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0
		then return false
	elseif getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 4620
		then return false
	elseif getTopCreature(pos).uid > 0 then
		return false
	elseif isCreature(getTopCreature(pos).uid) then
		return false
	elseif getTileInfo(pos).protection then
		return false
	elseif hasProperty(getThingFromPos(pos).uid, 3) or hasProperty(getThingFromPos(pos).uid, 7) then
		return false
	end
	return true
end

function getLocalArenaZombieEvent()
	local pos
	local ehPosicaoValida = false
	while(ehPosicaoValida == false)do
		local posx = {}
		local posy = {}
		local posz = {}
		local pir = {}
		for i=1, 5 do
			local posx_tmp = math.random(ZB_LOCAL_ARENA_TE.x ,ZB_LOCAL_ARENA_BD.x)
			local posy_tmp = math.random(ZB_LOCAL_ARENA_TE.y ,ZB_LOCAL_ARENA_BD.y)
			local posz_tmp = math.random(ZB_LOCAL_ARENA_TE.z ,ZB_LOCAL_ARENA_BD.z)
			local pir_tmp = 0
			local spec = getSpectators({x=posx_tmp, y=posy_tmp, z=posz_tmp}, 3, 3, false)
			if(spec and #spec > 0) then
				for z, pid in pairs(spec) do
					if(isPlayer(pid)) then
						pir_tmp = pir_tmp + 1
					end
				end
			end
			posx[i] = posx_tmp
			posy[i] = posy_tmp
			posz[i] = posz_tmp
			pir[i] = pir_tmp
		end
		local lowest_i = 1
		for i=2, 5 do
			if(pir[i] < pir[lowest_i]) then
				lowest_i = i
			end
		end
		pos = {x=posx[lowest_i], y=posy[lowest_i], z=posz[lowest_i]}
		if(isWalkable(pos))then
			ehPosicaoValida = true
		end
	end
	return pos
end

function teleportaJogadoresArenaZombie()
	for i, cid in pairs(getJogadoresSalaEsperaZombieEvent()) do
		setStatusJogadorZombieEvent(cid, os.time())

		local localArenaZombie = getLocalArenaZombieEvent()
		doTeleportThing(cid, localArenaZombie, true)
		doSendMagicEffect(getThingPosition(cid), CONST_ME_TELEPORT)
	end
end

function getTotalZombiesSummonar()
	return getGlobalStorageValue(ZB_GLOBAL_STORAGE_TOTAL_ZOMBIES_SUMMONAR)
end

function setTotalZombiesSummonar(total)
	setGlobalStorageValue(ZB_GLOBAL_STORAGE_TOTAL_ZOMBIES_SUMMONAR, total)
end

function getTotalZombiesArena()
	return getGlobalStorageValue(ZB_GLOBAL_STORAGE_TOTAL_ZOMBIES_ARENA)
end

function setTotalZombiesArena(total)
	setGlobalStorageValue(ZB_GLOBAL_STORAGE_TOTAL_ZOMBIES_ARENA, total)
end

function summonaZombie()
	local localArenaZombie = getLocalArenaZombieEvent()
	
	doCreateMonster("Zumbie", localArenaZombie)
	doSendMagicEffect(localArenaZombie, 34)
	
	setTotalZombiesArena(getTotalZombiesArena()+1)
end

function iniciarZombieEvent(estagio, totalParticipantes)
	setStatusZombieEvent(estagio)
	setLimiteParticipantesZombieEvent(totalParticipantes)
	if(estagio == 1)then
		abreTeleporteZombieEvent()
		addEvent(forcarInicioZombieEvent,ZB_TEMPO_FORCAR_EVENTO)

		doBroadcastMessage("Evento Zombie foi iniciado. O evento esta limitado a " .. getLimiteParticipantesZombieEvent() .. " jogadores, o teleporte vai fechar em ".. (ZB_TEMPO_FORCAR_EVENTO/60/1000) .." minutos ou quando atingir o limite de jogadores.")
	elseif(estagio == 2)then
		fechaTeleporteZombieEvent()
		teleportaJogadoresArenaZombie()
		
		doBroadcastMessage("Evento Zombie Comecou.")
	end
end

function criaCorpoMorto(jogador)
	local nomeJogador = getCreatureName(jogador)
	local sexoJogador = getPlayerSex(jogador)
	
	local corpoID = (sexoJogador == 0 and 6560 or 3058)
	local localCorpo = getThingPosition(jogador)
	
	doSendMagicEffect(localCorpo, 68)
	local corpoChao = doCreateItem(corpoID, 1, localCorpo)
	doItemSetAttribute(corpoChao, "description", "You recognize "..nomeJogador..". "..(sexoJogador == 0 and 'She' or 'He').." was killed by a zumbie or player in " .. os.date("%d/%m/%Y %X", os.time())..".")
	
	doPlayerSendTextMessage(jogador, MESSAGE_STATUS_CONSOLE_BLUE, "BOOM! Voce foi infectado por um zombie e perdeu o evento.")
end

function teleportaJogadorCidadeNatal(jogador)
	local idCidadeNatal = getPlayerTown(jogador)
	local posicaoTemploCidadeNatal = getTownTemplePosition(idCidadeNatal)
	doTeleportThing(jogador, posicaoTemploCidadeNatal, true)
	doSendMagicEffect(getThingPosition(jogador), CONST_ME_TELEPORT)
end

function anunciaMorteJogador(jogador, participantes)
	local nomeJogador = getCreatureName(jogador)
	
	local totalParticipantes = #participantes-1
	if(totalParticipantes > 1) then
		doBroadcastMessage("O jogador "..nomeJogador.." foi pego por um zombie, ainda restam "..totalParticipantes.." no evento.")
	elseif(totalParticipantes == 1) then
		doBroadcastMessage("Ja temos um vencedor do evento zombie arena, vamos ver quanto tempo que ele vai durar dentro da arena zombie.")
	end
end

function salvaGanhadorZombieEvent(ganhador, dataInicio, dataFim, segundos, totalZombies)
	db.query("INSERT INTO `zombie_event`(`player_id`, `data_inicio`, `data_fim`, `segundos`, `total_zombies`) VALUES ('".. getPlayerName(ganhador).."', ".. dataInicio ..", ".. dataFim ..", ".. segundos ..", ".. totalZombies ..");");
end

function presentarGanhador(ganhador)
	if(ganhador) then
		local nomeJogador = getPlayerName(ganhador)
		local trofeu = doPlayerAddItem(ganhador, ZB_PREMIOS.trofeu, 1)
		doItemSetAttribute(trofeu, "name", "trofeu evento zombie "..os.date("%d/%m/%Y", os.time()))
		doItemSetAttribute(trofeu, "description", "Awarded to " .. nomeJogador .. " for winning the zombie event.")
		
		--for _,item in ipairs(ZB_PREMIOS.itens) do
			--doPlayerAddItem(ganhador, item, 1)
		--end
		
		local itemSortiado = math.random(#ZB_PREMIOS.itens)
		doPlayerAddItem(ganhador, ZB_PREMIOS.itens[itemSortiado], 1)
		
		if ZB_PREMIOS.dinheiro[3] then
			doPlayerAddItem(ganhador, ZB_PREMIOS.dinheiro[1], ZB_PREMIOS.dinheiro[2])
		end
		doPlayerSave(ganhador, true)
		doPlayerSendTextMessage(ganhador, MESSAGE_STATUS_CONSOLE_BLUE, "Voce ganhou o evento Arena Zombie.")
		
		local dataInicio = getStatusJogadorZombieEvent(ganhador)
		local dataFim = os.time()
		local segundos = dataFim-dataInicio
		local totalZombies = getTotalZombiesArena()
		
		salvaGanhadorZombieEvent(ganhador, dataInicio, dataFim, segundos, totalZombies)
		
		doBroadcastMessage("Apos " .. segundos .. " segundos dentro da arena zombie o " .. nomeJogador .. " ganhou o evento, lutando contra " .. totalZombies .. " zombies!")
	else
		doBroadcastMessage("Evento Zombie Acabou! Nao teve ganhador?!?!?! WTF!")
	end
end

function removerZombiesArena()
	local largura = (math.max(ZB_LOCAL_ARENA_TE.x, ZB_LOCAL_ARENA_BD.x) - math.min(ZB_LOCAL_ARENA_TE.x, ZB_LOCAL_ARENA_BD.x)) / 2 + 1
	local altura = (math.max(ZB_LOCAL_ARENA_TE.y, ZB_LOCAL_ARENA_BD.y) - math.min(ZB_LOCAL_ARENA_TE.y, ZB_LOCAL_ARENA_BD.y)) / 2 + 1
	local centro = {x=math.min(ZB_LOCAL_ARENA_TE.x, ZB_LOCAL_ARENA_BD.x)+largura,y=math.min(ZB_LOCAL_ARENA_TE.y, ZB_LOCAL_ARENA_BD.y)+altura,z=ZB_LOCAL_ARENA_TE.z}
	for z = math.min(ZB_LOCAL_ARENA_TE.z, ZB_LOCAL_ARENA_BD.z), math.max(ZB_LOCAL_ARENA_TE.z, ZB_LOCAL_ARENA_BD.z) do
		centro.z = z
		for i, uid in pairs(getSpectators(centro, largura, altura, false)) do
			if(isMonster(uid)) then
				doRemoveCreature(uid)
			end
		end
	end
end

function levouDanoZombie(jogador)
	if(getStatusJogadorZombieEvent(jogador) > 1) then
		criaCorpoMorto(jogador)
		teleportaJogadorCidadeNatal(jogador)

		local participantes = getJogadoresZombieEvent()
		anunciaMorteJogador(jogador, participantes)
		
		local totalParticipantes = #participantes-1
		if totalParticipantes == 0 then
			presentarGanhador(participantes[1])
			resetaStorageZombieEvent()
			removerZombiesArena()
		end
		setStatusJogadorZombieEvent(jogador, 0)
	end
end