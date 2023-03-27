local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid)                          npcHandler:onCreatureAppear(cid)                        end
function onCreatureDisappear(cid)                       npcHandler:onCreatureDisappear(cid)                     end
function onCreatureSay(cid, type, msg)                  npcHandler:onCreatureSay(cid, type, msg)                end
function onThink()                                      npcHandler:onThink()                                    end
function creatureSayCallback(cid, type, msg)
        if(not npcHandler:isFocused(cid)) then
                return false
        end
		
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	local storage = getPlayerStorageValue(cid, 58750)
	
	if msgcontains(msg, 'mission') or msgcontains(msg, 'missão') then
		if storage == 11 then
			npcHandler:say("A cidade de Darmax esconde muitos mistérios em suas redondezas.", cid)
			npcHandler:say("Eu sou um arquiológo da cidade de Darmax. Mas devido a muitas explorações estou exausto, poderia me ajudar a colhetar algumas que faltaram ?", cid)
			talkState[talkUser] = 1
		elseif storage >= 11 and storage <= 19 then
			npcHandler:say("Coletou todas as informações necessárias ?", cid)
			talkState[talkUser] = 2
		elseif storage < 10 then
			npcHandler:say("Precisa iniciar a missão com o Lord Gun, em Gundabad primeiro.", cid)
		elseif storage == 20 then
			npcHandler:say("Você já concluiu minha missão e tem acesso aos tapetes de Gundabad.", cid)
		end
		
	elseif msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then
		if talkState[talkUser] == 1 then
			npcHandler:say("Preciso que colete 9 amostras sobre os monstros ao redor da cidade. Eles são: Dragon Lord, Necromancer, Warlock, Fury, Elfs, Hydras, Sea Serpents, Medusas e Serpent Spawns", cid)
			setPlayerStorageValue(cid, 58750, 12)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			if storage == 12 then
			npcHandler:say("Ainda falta coletar 9 amostras dos monstros", cid)
			elseif storage == 13 then
			npcHandler:say("Ainda falta coletar 8 amostras dos monstros: Necromancer, Warlock, Fury, Elfs, Hydra, Sea Serpent, Medusa e Serpent Spawn.", cid)
			elseif storage == 14 then
			npcHandler:say("Ainda falta coletar 7 amostras dos monstros: Warlock, Fury, Elfs, Hydra, Sea Serpent, Medusa e Serpent Spawn.", cid)
			elseif storage == 15 then
			npcHandler:say("Ainda falta coletar 6 amostras dos monstros: Fury, Elfs, Hydra, Sea Serpent, Medusa e Serpent Spawn.", cid)
			elseif storage == 16 then
			npcHandler:say("Ainda falta coletar 5 amostras dos monstros: Elfs, Hydra, Sea Serpent, Medusa e Serpent Spawn.", cid)
			elseif storage == 17 then
			npcHandler:say("Ainda falta coletar 4 amostras dos monstros: Hydra, Sea Serpent, Medusa e Serpent Spawn.", cid)
			elseif storage == 18 then
			npcHandler:say("Ainda falta coletar 3 amostras dos monstros: Sea Serpent, Medusa e Serpent Spawn.", cid)
			elseif storage == 19 then
			npcHandler:say("Ainda falta coletar 2 amostras dos monstros: Medusa e Serpent Spawn.", cid)
			elseif storage == 20 then
			npcHandler:say("Ainda falta coletar 1 amostras dos monstros: Serpent Spawn.", cid)
			elseif storage == 21 then
			npcHandler:say("Obrigado por coletar as amostras de todos os monstros que solicitei a você.", cid)
			npcHandler:say("Direi ao Lord Gun que aqui sua missão acabou e poderá usar os tapetes dele.", cid)
			setPlayerStorageValue(cid, 58750, 22)
			end
		end
		return TRUE	
	end
	
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())