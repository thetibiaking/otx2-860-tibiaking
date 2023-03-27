local questArea = {from = {x = 34471, y = 57769, z = 6}, to = {x =34484, y = 57779, z = 6}} -- area do evento...
local levelAccess = 81


local function isMC(uid)
    for _, pid in ipairs(getPlayersOnline()) do
        if uid ~= pid and getPlayerIp(uid) == getPlayerIp(pid) and getPlayerStorageValue(pid, 484960) > 0 then
            return true
        end
    end
    return false
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local cidPosition = getCreaturePosition(cid)
	if getPlayerLevel(cid) >= levelAccess then
		if isMC(cid) then
			doPlayerSendCancel(cid, "É proibido a entrada de MCs neste Evento.")
		else
			
			if cidPosition.x < toPosition.x then
				doTeleportThing(cid, {x=toPosition.x+1,y=toPosition.y,z=toPosition.z}, TRUE)
				doCreatureSay(cid, "Bem Vindo ao Castle!!", TALKTYPE_ORANGE_1)
				setPlayerStorageValue(cid, 484960, 0)
			else
				doTeleportThing(cid, {x=toPosition.x-1,y=toPosition.y,z=toPosition.z}, TRUE)
				doCreatureSay(cid, "Você saiu do Castle!!", TALKTYPE_ORANGE_1)
                setPlayerStorageValue(cid, 484960, 1)
			end
		end
		return true
	else
		doPlayerSendCancel(cid, "Seu level é menor que " .. levelAccess .. ".")
	end
    return true
end