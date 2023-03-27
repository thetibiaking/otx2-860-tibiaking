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
	
	if msgcontains(msg, 'mission') or msgcontains(msg, 'miss�o') then
		if storage == 1 then
			npcHandler:say("Lord Gun e suas miss�es. � sou um velho mesmo como ele vive dizendo, mas sou o respons�vel pela constru��o de Gundabad.", cid)
			npcHandler:say("Bom j� que est� conhecendo a cidade, v� falar com o {Charric} o respons�vel pelas colheitas da cidade.", cid)
			talkState[talkUser] = 1
		else
			if storage == 2 then
			npcHandler:say("Encontre Charric ele est� nas planta��es de Trigo a direita do Depot da cidade.", cid)
			else
			npcHandler:say("Fale com Lord Gun primeiro.", cid)
			end
		end
	elseif msgcontains(msg, 'charric') then	
		if talkState[talkUser] == 1 then
			npcHandler:say("Ele est� nas planta��es de Trigo a direita do Depot da cidade.", cid)
			setPlayerStorageValue(cid, 58750, 2)			
		end
		
		return TRUE	
	end
end
	

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())