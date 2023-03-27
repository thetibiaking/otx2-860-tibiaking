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
	
	if(msgcontains(msg, 'yes')) then
		if getPlayerStorageValue(cid, 16051) == -1 then
			npcHandler:say("Minha filha saiu para uma {missão} pelas redondezas de Thais a dias, mas ainda não voltou !", cid)
			elseif (msgcontains(msg, 'mission') or msgcontains(msg,'missão')) then
			npcHandler:say("Traga-me notícias sobre ela e em troca te darei acesso ao meu submarino !", cid)
			setPlayerStorageValue(cid, 16051, 1)
		else
			if getPlayerStorageValue(cid, 16054) == 1 then
			npcHandler:say("Finalmente você voltou ! Conseguiu encontra-lá ? ", cid)
				elseif (msgcontains(msg, 'yes')) then
				npcHandler:say("Ufa, que alívio saber que Annavoig está bem. Obrigado por me ajudar, como prometido poderá usar o meu submarino !", cid)
				setPlayerStorageValue(cid, 16055, 1)
			else
			npcHandler:say("Ela estava em uma caverna de lobos. !", cid)
			end
		end
	end
	return TRUE
end




npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())