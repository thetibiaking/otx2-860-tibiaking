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
						doPlayerSendCancel(cid, "[War Castle] Voc� se registrou para o War Castle.")
					else
						doPlayerSendTextMessage(cid,25,"ERROR! Please contact the administrator.")
					end
				else
					doPlayerSendCancel(cid, "Voc� n�o tem dinheiro suficiente. Taxa de incri��o: 250k")
				end
			else
				doPlayerSendCancel(cid, "Voc� precisa ser level 100+ para se registrar.")
			end
		else
			doPlayerSendCancel(cid, "Voc� n�o tem guild.")
		end
	else
		doPlayerSendCancel(cid, "Voc� j� est� registrado.")
	end
	return true
end