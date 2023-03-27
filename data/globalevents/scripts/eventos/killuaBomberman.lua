local function announce(message, times)
	if times == 0 then return true end
	doBroadcastMessage(message)
	addEvent(announce,5*60000,message,times - 1)
end

local function getPlayersInArea(fromPos, toPos)
local players = {}
    for _, pid in ipairs(getPlayersOnline()) do
        if isInRange(getPlayerPosition(pid), fromPos, toPos) then
            table.insert(players, pid)
        end
    end
   
	return players
end

function onTime()
	local players_tp = getPlayersInArea({x=32365,y=32236,z=7}, {x=32365,y=32236,z=7})
	if getGlobalStorageValue(722641) == -1 then
		if players_tp then
			for _, v in next, players_tp do
				doTeleportThing(v, getTownTemplePosition(1))
				doPlayerSendTextMessage(v, MESSAGE_STATUS_CONSOLE_BLUE, "Não pode ficar no local onde o TP abriu. Você foi teleportado para o templo.")
			end
		end
		
		doCreateTeleport(1387, {x=32539,y=33558,z=9}, bomberman.tpPos)
		setGlobalStorageValue(722641, 1)
		setGlobalStorageValue(722642, os.time()+120*60) -- EVITAR BUG COM DTT
		announce("O teleport para as arenas de Bomberman está aberto até as 17:00!", 10)
	else
		local tp = getTileItemById(bomberman.tpPos, 1387)
		if tp and tp.uid > 0 then
			doRemoveItem(tp.uid)
		end
		local players = getPlayersInArea({x=462,y=103,z=9}, {x=490,y=117,z=9})
		if players then
			for _, pid in next, players do
				doTeleportThing(pid, getTownTemplePosition(1))
				doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "O tempo de jogo de bomberman acabou.")
			end
		end
		doBroadcastMessage"O tempo para jogar bomberman acabou e volta amanhã!"
	end
    return true
end
