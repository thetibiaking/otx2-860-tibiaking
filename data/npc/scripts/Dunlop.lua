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
		if storage == 1 then
			npcHandler:say("Lord Gun e suas missões. É sou um velho mesmo como ele vive dizendo, mas sou o responsável pela construção de Gundabad.", cid)
			npcHandler:say("Bom já que está conhecendo a cidade, vá falar com o {Charric} o responsável pelas colheitas da cidade.", cid)
			talkState[talkUser] = 1
		else
			if storage == 2 then
			npcHandler:say("Encontre Charric ele está nas plantações de Trigo a direita do Depot da cidade.", cid)
			else
			npcHandler:say("Fale com Lord Gun primeiro.", cid)
			end
		end
	elseif msgcontains(msg, 'charric') then	
		if talkState[talkUser] == 1 then
			npcHandler:say("Ele está nas plantações de Trigo a direita do Depot da cidade.", cid)
			setPlayerStorageValue(cid, 58750, 2)			
		end
		
		return TRUE	
	end
end
	

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())