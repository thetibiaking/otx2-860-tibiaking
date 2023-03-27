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
		if storage == 2 then
			npcHandler:say("J� conheceu o Dunlop, ele � o g�nio por tr�s da estrutura da cidade, mas j� est� velho. Voc� pode me ajudar coletando alguns {trigo} ?", cid)
			talkState[talkUser] = 1
		else		
			if getPlayerStorageValue(cid, 58750) == 3 then
			npcHandler:say("Eu preciso que recolha alguns {trigos} por favor.", cid)
			elseif storage < 4 then
			npcHandler:say("Conhe�a o meu amigo Dunlop primeiro.", cid)
			elseif storage > 3 then
			npcHandler:say("Voc� j� concluiu minha miss�o.", cid)
			end
		end
		
	elseif msgcontains(msg, 'trigo') or msgcontains(msg, 'trigos') then
		if talkState[talkUser] == 1 then
			if storage < 3 then
			npcHandler:say("Colha para mim 50 Trigos para terminar meu servi�o por favor.", cid)
			setPlayerStorageValue(cid, 58750, 3)
			talkState[talkUser] = 2
			end
		elseif talkState[talkUser] == 2 then
			if storage == 3 then
			npcHandler:say("Voc� tem os 50 Trigos que lhe pedi ?", cid)
			end
		end
	
	elseif msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then	
		if talkState[talkUser] == 2 then
			if storage == 3 and getPlayerItemCount(cid,2694) >= 50 then
				npcHandler:say("Agrade�o por me ajudar, sua bondade foi notada. Conhe�a tamb�m o monge Andry, pr�ximo da casa do Dunlop.", cid)	
				doPlayerRemoveItem(cid, 2694, 50)
				setPlayerStorageValue(cid, 58750, 4)
			else
				npcHandler:say("Voc� n�o tem todos os trigos que preciso.", cid)
			end
		end
	end	
		return TRUE	
	end
	
	

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())