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
		if storage == 7 then
			npcHandler:say("Eu estava caminhando pelas redondezas da cidade, levando música para todos. Mas diversas vezes fui atacado ou roubado.", cid)
			npcHandler:say("Gostaria da sua ajuda para recuperar meus instrumentos perdidos, poderia me ajudar ?", cid)
			talkState[talkUser] = 1
		elseif storage == 8 or storage == 9 then
			npcHandler:say("Já encontrou os livros ?", cid)
			talkState[talkUser] = 2
			else
			npcHandler:say("Fale com Andry primeiro.", cid)
			
		end
	elseif msgcontains(msg, 'yes') or msgcontains(msg, 'sim')then	
		if talkState[talkUser] == 1 then
			npcHandler:say("Obrigado por me ajudar, minha Lira foi roubada pelos Heros, meu alaúde perdi correndo de vampiros, a flauta em um depósito antigo, o drum roubado pelos piratas e a corneta numa fazenda abandonada.", cid)
			setPlayerStorageValue(cid, 58750, 8)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			if storage == 8 then
			npcHandler:say("Você ainda não achou todos meus instrumentos.", cid)
			elseif storage == 9 then
			npcHandler:say("Muito obrigado pela ajuda, volte ao Lord Gun e diga que sua missão acabou.", cid)
			setPlayerStorageValue(cid, 58750, 10)
			end
		end
		
		return TRUE	
	end
end
	

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())