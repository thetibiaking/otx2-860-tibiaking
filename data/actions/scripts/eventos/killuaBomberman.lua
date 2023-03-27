local aids = {	
	[61520] = 1,
	[61521] = 2,
	[61522] = 3,
	[61523] = 4,
	[61524] = 5,
	[61525] = 6,
	[61526] = 7,
	[61527] = 8
}

local function getPlayersInArea(fromPos, toPos)
local players = {}
    for _, pid in ipairs(getPlayersOnline()) do
        if isInRange(getPlayerPosition(pid), fromPos, toPos) then
            table.insert(players, pid)
        end
    end
   
	return players
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if tonumber(os.date("%H")) ~= 16 then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "O horário de bomberman já terminou.")
		doTeleportThing(cid, getTownTemplePosition(1))
		return true
	end
	local arenaNumber = aids[item.actionid]
	if arenaNumber then
		if bomberman.isArenaFree(arenaNumber) then
			local arena = bomberman.arenas[arenaNumber]
			local players = getPlayersInArea(arena.fromPosLeaver, arena.toPosLeaver)
			if players then
				if #players == 4 then
					local corner, ips  = 1, {}
					for _, pid in next, players do
						local ip = getPlayerIp(pid)
						if bomberman.ips[ip] then
							if bomberman.ips[ip] >= os.time() then
								doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "O IP de "..getCreatureName(pid).." já foi usado para jogar nos últimos 5 minutos. Ele deve aguardar "..timeString(bomberman.ips[ip] - os.time()).." para jogar novamente.")
								doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_ORANGE, "Seu IP já foi usado para jogar nos últimos 5 minutos. Você deve esperar "..timeString(bomberman.ips[ip] - os.time()).." para jogar novamente.")
								return;
							end
						 end
						if isInArray(ips, ip) then
							return doPlayerSendCancel(cid, "jogadores com o mesmo IP não podem participar juntos.")
						end
						table.insert(ips, ip)
					end
					for _, pid in next, players do
						local ip = getPlayerIp(pid)
						bomberman.ips[ip] = (os.time() + (5*60))
						if corner == 1 then
							doTeleportThing(pid, arena.fromPos)
						elseif corner == 2 then
							doTeleportThing(pid, arena.rightTopCorner)
						elseif corner == 3 then
							doTeleportThing(pid, arena.toPos)
						elseif corner == 4 then
							doTeleportThing(pid, arena.leftBottomCorner)
						end
						doCreatureSetStorage(pid, bomberman.oldSpeedStorage, getCreatureSpeed(pid))
						doCreatureSetStorage(pid, bomberman.bombLimitStorage, 1)
						doCreatureSetStorage(pid, bomberman.bombStorage, 1000)
						doCreatureSetStorage(pid, bomberman.radiusStorage, 1)
						doCreatureSetStorage(pid, bomberman.inGameStorage, arenaNumber)
						doRemoveCondition(pid, CONDITION_HASTE)
						Events:enter(pid, false)
						doChangeSpeed(pid, 220 - getCreatureSpeed(pid))
						doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Você entrou no bomberman, use !bomb para colocar bombas e boa sorte!")
						corner = corner + 1
					end
					setGlobalStorageValue(arena.storage, 1)
					-- Adicionar as pedras explodíveis
					local currentPosition
					local create = true
					local unavailables = {{x = arena.fromPos.x, y = arena.fromPos.y}, {x = arena.rightTopCorner.x, y = arena.rightTopCorner.y}, {x = arena.leftBottomCorner.x, y = arena.leftBottomCorner.y}, {x = arena.toPos.x, y = arena.toPos.y}, {x = arena.fromPos.x + 1, y = arena.fromPos.y}, {x = arena.fromPos.x, y = arena.fromPos.y + 1}, {x = arena.rightTopCorner.x - 1, y = arena.rightTopCorner.y}, {x = arena.rightTopCorner.x, y = arena.rightTopCorner.y + 1}, {x = arena.toPos.x - 1, y = arena.toPos.y}, {x = arena.toPos.x, y = arena.toPos.y - 1}, {x = arena.leftBottomCorner.x + 1, y = arena.leftBottomCorner.y}, {x = arena.leftBottomCorner.x, y = arena.leftBottomCorner.y - 1}}
					for xx = arena.fromPos.x, arena.toPos.x do
						for yy = arena.fromPos.y, arena.toPos.y do
							create = true
							currentPosition = {x = xx, y = yy, z = arena.fromPos.z}
							for _, pair in next, unavailables do
								if pair.x == xx and pair.y == yy then
									create = false
									break;
								end
							end
							if create then
								local block = getTileItemById(currentPosition, bomberman.blockId)
								if block and block.uid and block.uid > 0 then
									create = false
								end
								if create then
									local stone = getTileItemById(currentPosition, bomberman.stoneId)
									if stone and stone.uid and stone.uid > 0 then
										create = false
									end
									if create then
										if math.random(100) < 70 then
											doCreateItem(bomberman.stoneId, 1, currentPosition)
										end
									end
								end
							end
						end
					end
					-- Pedras adicionadas

				else
					doPlayerSendCancel(cid, "São necessários 4 jogadores para iniciar o bomberman.")
				end
			else
				doPlayerSendCancel(cid, "São necessários 4 jogadores para iniciar o bomberman.")
			end
		else
			doPlayerSendCancel(cid, "Esta arena de bomberman já está ocupada. Aguarde até que o jogo termine.")
		end
	end
	return true
end