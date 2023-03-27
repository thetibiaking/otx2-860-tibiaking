local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)                          npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)                       npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)                  npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                                      npcHandler:onThink() end



function greetCallback(cid)
    msg = 'Hello visitor! I may be dealing with you with some matters about {Oramond} ...'
    npcHandler:setMessage(MESSAGE_GREET, msg)
    return true
end

local talkstate = {} 
local taskGloothsDone = {}
local taskGolemsDone = {}
local choicedSpawn = {} 
local choicedNotification = {}
local globalStorageTimeTroca = 65417
function creatureSayCallback(cid, type, msg)   	
	if msgcontains(msg, "oramond") then
		if getPlayerStorageValue(cid, 32148749) ~= 1 then
			npcHandler:say('Esta cidade, possui uma mecânica muito interessante. Investimos milhoes de ouro em tecnologia avançada e hoje podemos fazer praticamente o que quisermos ...', cid) 
			delaySay("Bom, o que quisermos, desde que haja mais ouro envolvido! ...", 3000, cid)
			delaySay("Mas vamos ao que interessa... Sobre o que você quer tratar? Posso te ajudar com assuntos referentes a {raids}, {tasks}, {shortcut}, {notifications} ou podemos conversar um pouco sobre as {catacombs}.", 7000, cid)
			setPlayerStorageValue(cid, 32148749, 1)
		else
			npcHandler:say('Sobre o que você quer tratar? Posso te ajudar com assuntos referentes a {raids}, {tasks}, {shortcut}, {notifications} ou podemos conversar um pouco sobre as {catacombs}.', cid) 
		end
		talkstate[cid] = 1
	end

	--- Verificando Storages de Tasks ---
	taskGloothsDone[cid] = false
	local storageGloothsTask = getPlayerStorageValue(cid, 28716)
	if not tonumber(storageGloothsTask) and tonumber(doCutText(storageGloothsTask, "/")[2]) > 0 then
		taskGloothsDone[cid] = true
	end
	taskGolemsDone[cid] = false
	local storageGolemsTask = getPlayerStorageValue(cid, 28717)
	if not tonumber(storageGolemsTask) and tonumber(doCutText(storageGolemsTask, "/")[2]) > 0 then
		taskGolemsDone[cid] = true
	end

	local minosTime = getGlobalStorageValue(6546404)
	local golemsTime = getGlobalStorageValue(6546405)
	local demonsTime = getGlobalStorageValue(6546406)
	----------------------------------------------------------------

	
	if msgcontains(msg, 'raids') then
		npcHandler:say('Aqui na cidade, há diversas raids que ocorrem durante todo o dia! Uma das principais é a invasão de {quaras} que acontecem no entorno da cidade... Também acontece alguns experimentos com {Golems}, {Glooths} e outras {criaturas}!', cid) 
		delaySay("Se você quiser posso te {notificar} sempre que elas forem ocorrer... Podemos negociar!", 7000, cid)
	elseif msgcontains(msg, 'quara') then
		npcHandler:say('A raid das quaras ocorre na saida Oeste da cidade, perto de uma cave de Hydras. Não sabemos bem a hora que elas estarão por la... Sabemos que estarão! Tome cuidado ao passar por la.', cid) 
	elseif msgcontains(msg, 'golems') or msgcontains(msg, 'glooth') or msgcontains(msg, 'criatura') or msgcontains(msg, 'experimentos') then
		delaySay("Bom como eu ia dizendo, há alguns experimentos realizados com algumas criaturas... Esses, ocorrem no subsolo de Oramond, o seu acesso se da por um teleport proximo a ponte no Leste da cidade. ...", 100, cid)
		delaySay("Lá, há 3 áreas que são testadas para experimentos a cada 2 horas, tome cuidado pois o respawn é triplicado durante os experimentos...", 3000, cid)
		delaySay("Bom, se preferir, eu posso estar te {notificando} quando essas invasões ocorrem...", 7000, cid)
	elseif msgcontains(msg, 'notif') then
		if taskGloothsDone[cid] and taskGolemsDone[cid] then
			npcHandler:say('Sobre qual raid você quer receber notificação: {Golems}, {Glooths}, {Minotaurs} ou {Quaras}?', cid)
			talkstate[cid] = 5
		else
			npcHandler:say('Para que eu possa te notificar sobre as {raids}, você terá de cumprir algumas tarefas. Primeiramente você deverá concluir as {tasks} de Glooths e Golems ao menos uma vez.', cid) 
		end
	elseif msgcontains(msg, 'task') then
		npcHandler:say('Você pode iniciar uma task falando com o Grizzly Adams, ele deve estar em Thais... Peça a ele para fazer a task dos Glooths, concluindo ela volte até mim e então trataremos sobre as {notificações} e {shortcuts}.', cid) 
	elseif msgcontains(msg, 'shortcut') then
		if taskGloothsDone[cid] and taskGolemsDone[cid] then
			npcHandler:say('Você gostaria que eu trocasse o seu atalho para o acesso de Oramond por {300.000} gold coins?',cid)
			talkstate[cid] = 4
		else
			npcHandler:say('Eu posso alterar o seu transporte do barco direto para o centro da cidade... Mas antes, será necessário realizar a {task} de Glooths e Golems.',cid)
		end
	elseif msgcontains(msg, 'catacombs') then
		npcHandler:say('As Catacombs são acessadas por aquele teleport na entrada dessa sala. La também são realizados {experimentos}, porém, um pouco mais complexos...',cid)
		delaySay("Lá, estamos aceitando a colaboração dos players para testar as criaturas, então possibilitamos a {troca} manual do respawn.", 3000, cid)
	elseif msgcontains(msg, 'troca') then
		if taskGloothsDone[cid] and taskGolemsDone[cid] or  getPlayerGroupId(cid) > 4 then
			local respAtual = ''
			local respDisponivel = ''
			

			if minosTime>os.time() then respAtual = "Minotaurs" 					
			elseif golemsTime>os.time() then respAtual = "Golems" 					
			elseif demonsTime>os.time() then respAtual = "Demons" 
			end

			if respAtual ~= "Minotaurs" then if respDisponivel == '' then respDisponivel = '{Minotaurs}' else	respDisponivel = respDisponivel .. ' and {Minotaurs}' end end				
			if respAtual ~= "Golems" then if respDisponivel == '' then respDisponivel = '{Golems}' else	respDisponivel = respDisponivel .. ' and {Golems}' end end
			if respAtual ~= "Demons" then if respDisponivel == '' then respDisponivel = '{Demons}' else	respDisponivel = respDisponivel .. ' and {Demons}' end end

			npcHandler:say('O respawn atual é de ' .. respAtual .. ' e você pode trocar para: ' .. respDisponivel, cid)
			talkstate[cid] = 2
		else
			npcHandler:say('Para trocar os respawns, é necessário concluir a {task} de Glooths e Golems.', cid)
		end
	end
	if talkstate[cid] == 2 then
		if msgcontains(msg, "Minotaurs") then
			if getGlobalStorageValue(6546404) > os.time() then
				npcHandler:say('Atualmente esse é o respawn ativo, você deve escolher outra opção.', cid)
			elseif os.time() - getGlobalStorageValue(globalStorageTimeTroca) < 120 then
				npcHandler:say('O spawn foi trocado a pouco tempo, e você deve aguardar para trocar novamente.', cid)
			else
				npcHandler:say('Você tem certeza que quer trocar o spawn das Catacombs para Minotaurs? O custo é de {1.000.000} gps.', cid)
				choicedSpawn[cid] = "catacombsMinos"
				talkstate[cid] = 3
			end
		elseif msgcontains(msg, "Golem") then
			if getGlobalStorageValue(6546405) > os.time() then
				npcHandler:say('Atualmente esse é o respawn ativo, você deve escolher outra opção.', cid)
			elseif os.time() - getGlobalStorageValue(globalStorageTimeTroca) < 120 then
				npcHandler:say('O spawn foi trocado a pouco tempo, e você deve aguardar para trocar novamente.', cid)
			else
				npcHandler:say('Você tem certeza que quer trocar o spawn das Catacombs para Golems? O custo é de {1.000.000} gps.', cid)
				choicedSpawn[cid] = "catacombsGolems"
				talkstate[cid] = 3
			end
		elseif msgcontains(msg, "Demon") then
			if getGlobalStorageValue(6546406) > os.time() then
				npcHandler:say('Atualmente esse é o respawn ativo, você deve escolher outra opção.', cid)
			elseif os.time() - getGlobalStorageValue(globalStorageTimeTroca) < 120 then
				npcHandler:say('O spawn foi trocado a pouco tempo, e você deve aguardar para trocar novamente.', cid)
			else
				npcHandler:say('Você tem certeza que quer trocar o spawn das Catacombs para Demons? O custo é de {1.000.000} gps.', cid)
				choicedSpawn[cid] = "catacombsDemons"
				talkstate[cid] = 3
			end
		end
	elseif talkstate[cid] == 3 then
		if msgcontains(msg, "yes") then		
			if getGlobalStorageValue(1212341) > os.time() then
				npcHandler:say('O respawn foi trocado recentemente, é necessário aguardar algum tempo até que se possa trocar novamente!', cid)
				talkstate[cid] = 0
			else
				if doPlayerRemoveMoney(cid, 10000000) then
					npcHandler:say('Ok, o novo spawn deverá iniciar em alguns minutos...', cid)
					talkstate[cid] = 0
					if minosTime>os.time() then setGlobalStorageValue(6546404, 1) 					
					elseif golemsTime>os.time() then setGlobalStorageValue(6546405, 1)					
					elseif demonsTime>os.time() then setGlobalStorageValue(6546406, 1)
					end

					addEvent(function()
						 start_OramondRaids(choicedSpawn[cid])
					end, 45*1000)
					setGlobalStorageValue(1212341, os.time()+math.random(2600,7200))
				else
					npcHandler:say('Você não possui dinheiro suficiente...', cid)
				end
			end
		end
	elseif talkstate[cid] == 4 then
		if msgcontains(msg, "yes") then
			if doPlayerRemoveMoney(cid, 300000) then
				if getPlayerStorageValue(cid, 465470) == 1 then
					setPlayerStorageValue(cid, 465470, -1)
				else
					setPlayerStorageValue(cid, 465470, 1)
				end
				npcHandler:say('Ok, seu acesso foi alterado!')
				talkstate[cid] = 0
			else
				npcHandler:say('Você não possui dinheiro suficiente!')
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say('Ok...')
			talkstate[cid] = 0
		end
	elseif talkstate[cid] == 5 then
		if msgcontains (msg,'golem') then
			if getPlayerStorageValue(cid, 6546400) == -1 then
				npcHandler:say('Você tem certeza que quer receber notificação das raids de {Golems}? As invasões ocorrem na Glooth Factory, e sempre que rolar eu vou te enviar uma mensagem!', cid)
				npcHandler:say('Para isso, cobro um valor de {200.000} gold coins, você está disposto a pagar?', cid)
				choicedNotification[cid] = "golem"
				talkstate[cid] = 6
			elseif (getPlayerStorageValue(cid, 6546400) == 0) then
				npcHandler:say('Você deseja retornar as notificações de {Golems}?', cid)
				choicedNotification[cid] = "return golem"
				talkstate[cid] = 6
			else
				npcHandler:say('Você já recebe notificação quando há invasão dos Golems, deseja cancelar? Você poderá retornar a qualquer momento, gratuitamente.', cid)
				choicedNotification[cid] = "cancel golem"
				talkstate[cid] = 6
			end
		elseif msgcontains (msg, 'glooth') then
			if getPlayerStorageValue(cid, 6546401) == -1 then
				npcHandler:say('Você tem certeza que quer receber notificação das raids de {Glooths}? As invasões ocorrem na Glooth Factory, e sempre que rolar eu vou te enviar uma mensagem!', cid)
				npcHandler:say('Para isso, cobro um valor de {200.000} gold coins, você está disposto a pagar?', cid)
				choicedNotification[cid] = "glooth"
				talkstate[cid] = 6
			elseif (getPlayerStorageValue(cid, 6546401) == 0) then
				npcHandler:say('Você deseja retornar as notificações de {Glooths}?', cid)
				choicedNotification[cid] = "return glooth"
				talkstate[cid] = 6
			else
				npcHandler:say('Você já recebe notificação quando há invasão dos Glooths, deseja cancelar? Você poderá retornar a qualquer momento, gratuitamente.', cid)
				choicedNotification[cid] = "cancel glooth"
				talkstate[cid] = 6
			end
		elseif msgcontains (msg, 'minotaur') then
			if getPlayerStorageValue(cid, 6546402) == -1 then
				npcHandler:say('Você tem certeza que quer receber notificação das raids de {Minotaurs}? As invasões ocorrem na Glooth Factory, e sempre que rolar eu vou te enviar uma mensagem!', cid)
				npcHandler:say('Para isso, cobro um valor de {200.000} gold coins, você está disposto a pagar?', cid)
				choicedNotification[cid] = "minotaur"
				talkstate[cid] = 6
			elseif (getPlayerStorageValue(cid, 6546402) == 0) then
				npcHandler:say('Você deseja retornar as notificações de {Minotaurs}?', cid)
				choicedNotification[cid] = "return minotaur"
				talkstate[cid] = 6
			else
				npcHandler:say('Você já recebe notificação quando há invasão dos Minotaurs, deseja cancelar? Você poderá retornar a qualquer momento, gratuitamente.', cid)
				choicedNotification[cid] = "cancel minotaur"
				talkstate[cid] = 6
			end
		elseif msgcontains (msg, 'quara') then
			if getPlayerStorageValue(cid, 6546403) == -1 then
				npcHandler:say('Você tem certeza que quer receber notificação das raids de {Quaras}? As invasões ocorrem na Glooth Factory, e sempre que rolar eu vou te enviar uma mensagem!', cid)
				npcHandler:say('Para isso, cobro um valor de {100.000} gold coins, você está disposto a pagar?', cid)
				choicedNotification[cid] = "quara"
				talkstate[cid] = 6
			elseif (getPlayerStorageValue(cid, 6546403) == 0) then
				npcHandler:say('Você deseja retornar as notificações de {Quaras}?', cid)
				choicedNotification[cid] = "return quara"
				talkstate[cid] = 6
			else
				npcHandler:say('Você já recebe notificação quando há invasão dos Quaras, deseja cancelar? Você poderá retornar a qualquer momento, gratuitamente.', cid)
				choicedNotification[cid] = "cancel quara"
				talkstate[cid] = 6
			end
		end
	elseif talkstate[cid] == 6 then
		if msgcontains(msg, 'yes') then
			if (choicedNotification[cid] == "golem" and doPlayerRemoveMoney(cid, 200000)) or choicedNotification[cid] == "return golem" then
				setPlayerStorageValue(cid, 6546400, 1)
				npcHandler:say('Ok, agora você será notificado sempre que se iniciar uma invasão de Golems na Glooth Factory.', cid)
				talkstate[cid] = 0
			elseif (choicedNotification[cid] == "glooth" and doPlayerRemoveMoney(cid, 200000)) or choicedNotification[cid] == "return glooth" then
				setPlayerStorageValue(cid, 6546401, 1)
				npcHandler:say('Ok, agora você será notificado sempre que se iniciar uma invasão de Glooths na Glooth Factory.', cid)
				talkstate[cid] = 0
			elseif (choicedNotification[cid] == "minotaur" and doPlayerRemoveMoney(cid, 200000)) or choicedNotification[cid] == "return minotaur" then
				setPlayerStorageValue(cid, 6546402, 1)
				npcHandler:say('Ok, agora você será notificado sempre que se iniciar uma invasão de Minotaurs na Glooth Factory.', cid)
				talkstate[cid] = 0
			elseif (choicedNotification[cid] == "quara" and doPlayerRemoveMoney(cid, 100000)) or choicedNotification[cid] == "return quara" then
				setPlayerStorageValue(cid, 6546403, 1)
				npcHandler:say('Ok, agora você será notificado sempre que se iniciar uma invasão de Quaras no Oeste de Oramond.', cid)
				talkstate[cid] = 0

			-- Cancel:
			elseif choicedNotification[cid] == "cancel golem" then
				setPlayerStorageValue(cid, 6546400, 0)
				npcHandler:say('Certo, você não receberá mais essas notificações! A qualquer momento pode retorna-las se preferir!', cid)
				talkstate[cid] = 0
			elseif choicedNotification[cid] == "cancel glooth" then
				setPlayerStorageValue(cid, 6546401, 0)
				npcHandler:say('Certo, você não receberá mais essas notificações! A qualquer momento pode retorna-las se preferir!', cid)
				talkstate[cid] = 0
			elseif choicedNotification[cid] == "cancel minotaur" then
				setPlayerStorageValue(cid, 6546402, 0)
				npcHandler:say('Certo, você não receberá mais essas notificações! A qualquer momento pode retorna-las se preferir!', cid)
				talkstate[cid] = 0
			elseif choicedNotification[cid] == "cancel quara" then
				setPlayerStorageValue(cid, 6546403, 0)
				npcHandler:say('Certo, você não receberá mais essas notificações! A qualquer momento pode retorna-las se preferir!', cid)
				talkstate[cid] = 0
			else
				npcHandler:say('Você não possui dinheiro suficiente para receber notificação dessa raid.', cid)
			end
		end
	end

    return true
end      


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
npcHandler:setCallback(CALLBACK_GREET, greetCallback)


--[[
if item.itemid == 20720 then
	local waitTime = getPlayerStorageValue(cid, config.storage) + config.time
	if waitTime < os.time() then 
		doPlayerSendCancel(cid,"You must wait "..SecondsToClock(waitTime - os.time()).." to rotate again.")
		return true
	end
	if getPlayerLevel(cid) >= config.level then		
	    if random < 50 then
	        PokestopGive(common[math.random(0, #common)], math.random(1,10), "Common")
	    elseif random >= 50 and random < 80  then
	        PokestopGive(unusual[math.random(0, #unusual)], math.random(1,6), "Unusual")
	    elseif random >= 80 and random < 95  then
	        PokestopGive(rare[math.random(0, #rare)], math.random(1,6), "Rare")
	    elseif random >= 95 and random < 100  then
	        PokestopGive(epic[math.random(0, #epic)], math.random(1,2), "Epic")
	    elseif random == 100  then
	        PokestopGive(legendary[math.random(0, #legendary)], 1, "Legendary")
	    end

	else
		doPlayerSendCancel(cid,"You must be at least level "..level.."")
	end
end]]