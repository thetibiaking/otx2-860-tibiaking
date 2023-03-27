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
	
	if(msgcontains(msg, 'quest') and getPlayerStorageValue(cid, 5400) == -1) then
			npcHandler:say("Minha filha e eu exploramos esta ilha h� anos. Fizemos muitas descobertas, uma das mais importantes � sobre a {dragons cave}", cid)
		
		elseif(msgcontains(msg, 'dragons cave'))then	
			npcHandler:say("Em uma caverna quase derrotamos o grande drag�o Ranris, sua poderosa magia fortalece todos os drag�es da regi�o, de um final nisso e mate-o.", cid)	
			npcHandler:say("No quarto da minha filha, est� o mapa da localiza��o da entrada da caverna. V� com seus amigos, pois a batalha vai ser dif�cil", cid)
			setPlayerStorageValue(cid, 5400, 1)
			
	end

	
	if (msgcontains(msg, 'quest') and getPlayerStorageValue(cid, 5400) == 1 and getPlayerStorageValue(cid, 15411) == 1) then
		npcHandler:say("Voc� encontrou a caverna e derrotou o drag�o ?", cid)
			elseif(msgcontains(msg, 'yes') or msgcontains(msg, 'sim') and getPlayerStorageValue(cid, 15411) == 1  and getPlayerStorageValue(cid, 15412) == -1) then
			npcHandler:say("Vou recompensa-lo com um Blessed Shield e uma das mochilas que produzo, temos a {Expedition Backpack} e a {Dragon Backpack}", cid)
				elseif (msgcontains(msg, "expedition backpack") and getPlayerStorageValue(cid, 15411) == 1  and getPlayerStorageValue(cid, 15412) == -1) then
					doPlayerAddItem(cid, 12752, 1)
					doPlayerAddItem(cid, 2523, 1)
					setPlayerStorageValue(cid, 15412, 1)
					npcHandler:say("Agradecemos sua ajuda finalmente o drag�o foi derrotado.", cid)
				elseif (msgcontains(msg, "dragon backpack") and getPlayerStorageValue(cid, 15411) == 1  and getPlayerStorageValue(cid, 15412) == -1) then	
					doPlayerAddItem(cid, 12753, 1)
					doPlayerAddItem(cid, 2523, 1)
					setPlayerStorageValue(cid, 15412, 1)
					npcHandler:say("Agradecemos sua ajuda finalmente o drag�o foi derrotado.", cid)
					
		else
		npcHandler:say("Voc� precisa derrotar Ranris antes de ter sua recompensa ou j� conquistou seus items.", cid)
	end
				
		return TRUE	
	end
	
	

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())