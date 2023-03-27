local storage = 6557 -- Storage eu registra os 10 minutos entre as mensagens
local storage2 = 6558 -- Storage que proibe o player de falar fora do prazo

function onThink(interval, lastExecution, thinkInterval)
		if #getPlayersOnline() > 0 then
		for _, cid in ipairs(getPlayersOnline()) do
            if getPlayerStorageValue(cid, storage2) == 1 and getPlayerStorageValue(cid, storage) - os.time() < 1 then
                setPlayerStorageValue(cid, storage2, 0)
            end
		end
		end
		return true
end