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
	local storage = getPlayerStorageValue(cid, 16051)
	local talkstor = getPlayerStorageValue(cid, 26050)
	local storagefim = getPlayerStorageValue(cid, 16053)
	
	
	if(msgcontains(msg, 'mission')) then
			if storage == -1 then	
				npcHandler:say("Procure por meu pai primeiro, em Kazordoon !", cid)
				talkState[talkUser] = 1
			else
				npcHandler:say("Já que meu pai te mandou aqui, vou lhe pedir pra fazer uma {tarefa}.", cid)
				talkState[talkUser] = 0
			end
	elseif (msgcontains(msg, 'tarefa') or msgcontains(msg, 'task')) then		
		if storage == 1 then
			npcHandler:say("Preciso que colhete informações de 5 plantas. Elas estão próximas as guilds houses fora da cidade de Thais.", cid)
			setPlayerStorageValue(cid, 16051, 2)
			setPlayerStorageValue(cid, 16053, 1)
		else
			if ( storage >= 2 and storage <= 7 and getPlayerStorageValue(cid, 16053) == 1) then
			npcHandler:say("Voce ainda nao encontrou todas as ervas, analise elas pra mim.", cid)
			else
			npcHandler:say("Obrigado, avisarei ao meu pai da sua ajuda.", cid)
			setPlayerStorageValue(cid, 16054, 1)
			end
		end
	end
	return TRUE
end




npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())