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
		if storage == 4 then
			npcHandler:say("Sou um antigo monge dessa cidade e estou trabalhando na minha fazendo agora.", cid)
			npcHandler:say("Existe uma caverna com uns monges malignos, dentro tem alguns livros com informações importantes, pode coletar pra mim ?", cid)
			talkState[talkUser] = 1
		else
			if storage == 5 or storage == 6 then
			npcHandler:say("Já encontrou os livros ?", cid)
			talkState[talkUser] = 2
			elseif storage == 7 then
			npcHandler:say("Procure pelo maestro Burald.", cid)
			else
			npcHandler:say("Fale com Charric primeiro.", cid)
			end
		end
	elseif msgcontains(msg, 'yes') or msgcontains(msg, 'sim')then	
		if talkState[talkUser] == 1 then
			npcHandler:say("Encontre essa caverna e recolha as informações pra mim.", cid)
			setPlayerStorageValue(cid, 58750, 5)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			if storage == 5 then
			npcHandler:say("Você ainda não achou todos os livros. São total de 5 livros.", cid)
			elseif storage == 6 then
			npcHandler:say("Obrigado por coletar as informações dos livros, agora vá encontre Burald na sua casa de música ao norte de Thais.", cid)
			setPlayerStorageValue(cid, 58750, 7)
			end
		end
		
		return TRUE	
	end
end
	

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())