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
	local storage = getPlayerStorageValue(cid, 87456)
	local storagetp = getPlayerStorageValue(cid, 87460)
	
	if msgcontains(msg, 'templo') or msgcontains(msg, 'temple') then
		if storage == -1 and getGlobalStorageValue(3652) < 4 then
			npcHandler:say("Preciso da ajuda de todos. Estou juntando informações para meu livro mágico, e preciso de 5000 {magic scrolls} para completar meu livro. Mas como preciso da contribuição de todos, cada um me trará 50.", cid)
			talkState[talkUser] = 1
		elseif storage == 1 and getGlobalStorageValue(3652) < 4 then
			npcHandler:say("Preciso de você 50 {magic scrolls}. ", cid)
			talkState[talkUser] = 2
		elseif storage == 2 and getGlobalStorageValue(3652) < 4 then
			npcHandler:say("Você já fez sua parte. Chame seus amigos agora pra me ajudar ", cid)
			talkState[talkUser] = 4
		elseif getGlobalStorageValue(3652) >= 4 then
			npcHandler:say("Obtive ajuda de muitos amigos para a contribuição de informações do meu livro. Agora lhe darei acesso aos meus teleports. ", cid)
			npcHandler:say("Mas para acessar cada um vou precisar que colete alguns itens. Está disposto a entregar ?", cid)
			talkState[talkUser] = 5
		end
		
	elseif msgcontains(msg, 'magic scrolls') then
		if talkState[talkUser] == 1 then
			npcHandler:say("Preciso que colete 50 magic scrolls.", cid)
			setPlayerStorageValue(cid, 87456, 1)
			talkState[talkUser] = 2
		elseif talkState[talkUser] == 2 then
			npcHandler:say("Você conseguiu os 50 magic scrolls ?", cid)
			talkState[talkUser] = 3
		end
	
	elseif msgcontains(msg, 'yes') or msgcontains(msg, 'sim') then	
		if talkState[talkUser] == 3 then
			if getPlayerItemCount(cid,12729) >= 50 then
				npcHandler:say("Agradeço por me ajudar a coletar as informações que preciso pro meu livro. Sua contribuição foi o suficiente, chame seus amigos para contribuirem.", cid)	
				doPlayerRemoveItem(cid, 12729, 50)
				setPlayerStorageValue(cid, 87456, 2)
				if getGlobalStorageValue(3652) == -1 then
					setGlobalStorageValue(3652, 1)
				else
					setGlobalStorageValue(3652, getGlobalStorageValue(3652)+1)
				end
			else
				npcHandler:say("Você não tem todos os magic scrolls que preciso.", cid)
				talkState[talkUser] = 2
			end		
		elseif talkState[talkUser] == 5 then
			npcHandler:say("Posso lhe dar acesso ao portais: {hells}, {magician}, {poison}, {mines}, {castle}, {zao}.", cid)
			talkState[talkUser] = 6
		elseif talkState[talkUser] == 7 then
				if getPlayerItemCount(cid,2151) >= 40 then
					doPlayerRemoveItem(cid, 2151, 40)
					setPlayerStorageValue(cid, 87460, 1)
					npcHandler:say("Agora lhe darei acesso ao teleport de Hells.", cid)
					talkState[talkUser] = 5
				else
					npcHandler:say("Você não tem a quantidade necessária de itens, volte e traga 40 Talons.", cid)
					talkState[talkUser] = 5
				end
		elseif talkState[talkUser] == 8 then
				if getPlayerItemCount(cid,5904) >= 25 then
					doPlayerRemoveItem(cid, 5904, 25)
					setPlayerStorageValue(cid, 87461, 1)
					npcHandler:say("Agora lhe darei acesso ao teleport de Magician.", cid)
					talkState[talkUser] = 5
				else
					npcHandler:say("Você não tem a quantidade necessária de itens, volte e traga 25 Magic Sulphur.", cid)
					talkState[talkUser] = 5
				end
		elseif talkState[talkUser] == 9 then
				if getPlayerItemCount(cid,7315) >= 40 or getPlayerItemCount(cid,2177) >= 40 then
					doPlayerRemoveItem(cid, 7315, 40)
					doPlayerRemoveItem(cid, 2177, 40)
					setPlayerStorageValue(cid, 87462, 1)
					npcHandler:say("Agora lhe darei acesso ao teleport de Poison.", cid)
					talkState[talkUser] = 5
				else
					npcHandler:say("Você não tem a quantidade necessária de itens, volte e traga 40 Life Crystal.", cid)
					talkState[talkUser] = 5
				end
		elseif talkState[talkUser] == 10 then
				if getPlayerItemCount(cid,6500) >= 100 then
					doPlayerRemoveItem(cid, 6500, 100)
					setPlayerStorageValue(cid, 87463, 1)
					npcHandler:say("Agora lhe darei acesso ao teleport de Minas.", cid)
					talkState[talkUser] = 5
				else
					npcHandler:say("Você não tem a quantidade necessária de itens, volte e traga 100 Demonic Essence.", cid)
					talkState[talkUser] = 5
				end
		elseif talkState[talkUser] == 11 then
				if getPlayerItemCount(cid,11301) >= 1 and getPlayerItemCount(cid,11302) >= 1 and getPlayerItemCount(cid,11303) >= 1 and getPlayerItemCount(cid,11304) >= 1 then
					doPlayerRemoveItem(cid, 11301, 1)
					doPlayerRemoveItem(cid, 11302, 1)
					doPlayerRemoveItem(cid, 11303, 1)
					doPlayerRemoveItem(cid, 11304, 1)
					setPlayerStorageValue(cid, 87464, 1)
					npcHandler:say("Agora lhe darei acesso ao teleport de Zao.", cid)
					talkState[talkUser] = 5
				else
					npcHandler:say("Você não tem a quantidade necessária de itens, volte e traga 1 zaoan helmet, 1 zaoan armor, 1 zaoan legs e 1 zaoan shoes.", cid)
					talkState[talkUser] = 5
				end
		elseif talkState[talkUser] == 12 then
				if getPlayerItemCount(cid,5944) >= 15 then
					doPlayerRemoveItem(cid, 5944, 15)
					setPlayerStorageValue(cid, 87465, 1)
					npcHandler:say("Agora lhe darei acesso ao teleport de Castle.", cid)
					talkState[talkUser] = 5
				else
					npcHandler:say("Você não tem a quantidade necessária de itens, volte e traga 15 Soul Orb.", cid)
					talkState[talkUser] = 5
				end
		end	
	elseif msgcontains(msg, 'hells') then
		if talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, 87460) == -1 then
				npcHandler:say("Para acessar o hell, preciso de 40 Talons, você trouxe ?", cid)
				talkState[talkUser] = 7
			else
				npcHandler:say("Você já tem acesso a hells.", cid)
				talkState[talkUser] = 5
				
			end
		end
	elseif msgcontains(msg, 'magician') then
		if talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, 87461) == -1 then
				npcHandler:say("Para acessar a magician, preciso de 25 Magic Sulphur, você trouxe ?", cid)
				talkState[talkUser] = 8
			else
				npcHandler:say("Você já tem acesso a magician.", cid)
				talkState[talkUser] = 5
				
			end
		end
	elseif msgcontains(msg, 'poison') then
		if talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, 87462) == -1 then
				npcHandler:say("Para acessar o poison, preciso de 40 life crystal, você trouxe ?", cid)
				talkState[talkUser] = 9
			else
				npcHandler:say("Você já tem acesso ao poison.", cid)
				talkState[talkUser] = 5
				
			end
		end
	elseif msgcontains(msg, 'minas') then
		if talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, 87463) == -1 then
				npcHandler:say("Para acessar a minas, preciso de 100 demonic essence, você trouxe ?", cid)
				talkState[talkUser] = 10
			else
				npcHandler:say("Você já tem acesso a minas.", cid)
				talkState[talkUser] = 5
				
			end
		end
	elseif msgcontains(msg, 'zao') then
		if talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, 87464) == -1 then
				npcHandler:say("Para acessar a Zao, preciso de 1 zaoan armor, 1 zaoan legs, 1 zaoan shoes e 1 zaoan helmet, você trouxe ?", cid)
				talkState[talkUser] = 11
			else
				npcHandler:say("Você já tem acesso a Zao.", cid)
				talkState[talkUser] = 5
				
			end
		end
	elseif msgcontains(msg, 'castle') then
		if talkState[talkUser] == 6 then
			if getPlayerStorageValue(cid, 87465) == -1 then
				npcHandler:say("Para acessar ao Castle de Vengoth, preciso de 15 soul orb, você trouxe ?", cid)
				talkState[talkUser] = 12
			else
				npcHandler:say("Você já tem acesso ao Castle de Vengoth.", cid)
				talkState[talkUser] = 5
				
			end
		end
	end
		return TRUE	
	end
	
	

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())



