dofile("./_woe.lua")

function onSay(cid, words, param)
if(not checkExhausted(cid, 666, 5)) then
	return true
end

	if not Woe.isRegistered(cid) then
		if getPlayerGuildId(cid) > 0 then
			if getPlayerLevel(cid) >= 100 then
				if getPlayerMoney(cid) >= 250000 then -- gold coin
					if doPlayerRemoveMoney(cid, 250000) then -- gold coin
						setPlayerStorageValue(cid, stor.register, 1)
						doPlayerSendCancel(cid, "[War Castle] Você se registrou para o War Castle.")
					else
						doPlayerSendTextMessage(cid,25,"ERROR! Please contact the administrator.")
					end
				else
					doPlayerSendCancel(cid, "Você não tem dinheiro suficiente. Taxa de incrição: 250k")
				end
			else
				doPlayerSendCancel(cid, "Você precisa ser level 100+ para se registrar.")
			end
		else
			doPlayerSendCancel(cid, "Você não tem guild.")
		end
	else
		doPlayerSendCancel(cid, "Você já está registrado.")
	end
	return true
end