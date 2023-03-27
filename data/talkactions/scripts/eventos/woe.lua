dofile("./_woe.lua")

local config = woe_config

function onSay(cid, words, param)
if(not checkExhausted(cid, 666, 5)) then
	return true
end

	if words == "/castle" and param == "/!/SETUP" then
		Woe.setup()
		return true
	end
	
	Woe.getInfo()
	
	local myTable = {}
	
	for _, i in ipairs({"%d", "%B", "%Y", "%X"}) do
		table.insert(myTable, os.date(i, infoLua[4]))
	end
	
	if Woe.isStarted() then
		text = "Tempo restante: " ..  Woe.timeToEnd().mins .. " minutos e " .. Woe.timeToEnd().secs .. " segundos.\n\nA atual guild dominante do castelo é: " .. Woe.guildName() .. ".\nO jogador " .. Woe.breakerName() .. " derrotou o REI do castelo em "..myTable[1].." / "..myTable[2].." / "..myTable[3].." no tempo "..myTable[4].."."
	else
		text = "O último War Castle foi vencido pela guild: " .. Woe.guildName() .. ".\nO jogador " .. Woe.breakerName() .. " derrotou o REI do castelo em "..myTable[1].." / "..myTable[2].." / "..myTable[3].." no tempo "..myTable[4].."."
	end

	if words == "/castle" or words == "!castle" then
		if getPlayerAccess(cid) >= config.accessToStar then
			if param == "on" then
				if Woe.isTime() ~= true then
					doBroadcastMessage("[War Castle] O evento vai começar em 5 minutos. ...", config.bcType)
					doBroadcastMessage("[War Castle] O evento terá duração de " .. config.timeToEnd .. " minutos.", config.bcType)
					setGlobalStorageValue(stor.WoeTime, 1)
				else
					doPlayerSendCancel(cid, "[War Castle] Is already running.")
				end
			elseif param == "off" then
				if Woe.isTime() == true then
					doBroadcastMessage("War Castle was canceled...", config.bcType)
					setGlobalStorageValue(stor.WoeTime, 0)
					setGlobalStorageValue(stor.Started, 0)
					if isCreature(getThingFromPos(Castle.empePos).uid) == TRUE then
						doRemoveCreature(getThingFromPos(Castle.empePos).uid)
					end
					if getThingFromPos(Castle.desde).itemid > 0 then
						doRemoveItem(getThingFromPos(Castle.desde).uid)
					end
					Woe.removePre()
					Woe.removePortals()
				else
					doPlayerSendCancel(cid, "War Castle is not running.")
				end
			elseif param == "empe" then
				doSummonCreature("empe", Castle.empePos)
			elseif param == "go" then
				local newPos = Castle.empePos
				newPos.y = newPos.y + 1
				doTeleportThing(cid, newPos, FALSE)
			elseif param == "info" then
				doPlayerPopupFYI(cid, text)
			else
				doPlayerSendCancel(cid, "not valid param.")
			end
		elseif getPlayerAccess(cid) < config.accessToStar then
			if param == "info" then
				doPlayerPopupFYI(cid, text)
			end
		else
			doPlayerSendCancel(cid, "not possible.")
		end	
	elseif words == "!recall" or words == "/recall" then
		if Woe.isStarted() == true then
			if getPlayerGuildLevel(cid) == GUILDLEVEL_LEADER then
				if Woe.isInCastle(cid) == true then
					local members = Woe.getGuildMembers(getPlayerGuildId(cid), {x = 31785, y = 32602, z = 6}, {x = 31880, y = 32684, z = 8})
					if #members > 1 then
						if(exhaust(cid, stor.recall, config.recallTime) == 1) then
							for _, i in ipairs(members) do
								if getPlayerGuildLevel(i) ~= GUILDLEVEL_LEADER then
									local pos = getClosestFreeTile(cid, getCreaturePosition(cid), FALSE, TRUE)
									doTeleportThing(i, pos, FALSE)
								end
							end
							doCreatureSay(cid, "Emergency Recall!", TALKTYPE_SAY)
						else
							doPlayerSendCancel(cid, "Você só pode usar este comando a cada " .. config.recallTime / 60 .. " minutos.")
						end		
					else
						doPlayerSendCancel(cid, "Nenhum membro online ou no castle.")
					end
				else
					doPlayerSendCancel(cid, "Você só pode usar este comando dentro do castle.")
				end
			else
				doPlayerSendCancel(cid, "Você não é o lider da guild.")
			end
		else
			doPlayerSendCancel(cid, "War Castle não começou.")
		end
	end
	return true
end
