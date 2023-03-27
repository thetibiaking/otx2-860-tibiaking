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
		if storage == -1 then
			npcHandler:say("Eu sou o Lord dessa cidade, tenho alguns mistérios nelas que ninguém desvendeu ainda. Posso lhe conceder acesso aos meus tapetes para explorar melhor.", cid)
			npcHandler:say("Quer iniciar esse desafio ?", cid)
			talkState[talkUser] = 1
		elseif storage == 1 then
			npcHandler:say("Encontre Dunlop.", cid)
		elseif storage == 2 or storage == 3 then
			npcHandler:say("Encontre Charric.", cid)
		elseif storage >= 4 and storage <= 6 then
			npcHandler:say("Encontre Andry.", cid)
		elseif storage == 7 then
			npcHandler:say("Encontre Burald.", cid)
		elseif storage == 10 or storage == 11 then
			npcHandler:say("Bom trabalho , sua missão em Gundabad foi finalizada. Agora vá para Darmax e encontre o Lord Max acima do depot da cidade na biblioteca.", cid)
			setPlayerStorageValue(cid, 58750, 11)
		end
		
	elseif msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then
		if talkState[talkUser] == 1 then
			npcHandler:say("Conheça primeiro um velho amigo meu, o Dunlop.", cid)
			setPlayerStorageValue(cid, 58750, 1)
			talkState[talkUser] = 2
		end
		return TRUE	
	end
	
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())