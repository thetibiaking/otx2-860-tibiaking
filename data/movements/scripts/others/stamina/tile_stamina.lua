eventsId = {}

local function rechargeStamina(cid)
if not isPlayer(cid) then
	eventsId[cid] = nil
	return
end
	doPlayerAddStamina(cid, 3)
	local horas = getPlayerStamina(cid) / 60
	local minutos = string.format("%.2f", getPlayerStamina(cid) % 60)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Você recebeu 3 minutos de stamina. Sua stamina é de : ".. math.floor(horas) ..":"..minutos.." ")
    eventsId[cid] = addEvent(rechargeStamina, 5 * 60 * 1000, cid)
	
end

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
	local horas = getPlayerStamina(cid) / 60
	local minutos
	if (getPlayerStamina(cid) % 60) == 0 then
		minutos = "horas"
	else
		minutos = ":"..(getPlayerStamina(cid) % 60)
	end
	
    if isPlayer(cid) then
        eventsId[cid] = addEvent(rechargeStamina, 5 * 60 * 1000, cid)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Bem vindo aos trainers " .. getCreatureName(cid) .."! Você receberá 3 minuto de stamina a cada 5 minutos nos trainers. Sua stamina é de : ".. math.floor(horas) ..""..minutos..".")
    end

    return true
end

function onStepOut(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    if isPlayer(cid) then
        stopEvent(eventsId[cid])
        eventsId[cid] = nil
    end

    return true
end