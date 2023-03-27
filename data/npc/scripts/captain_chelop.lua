local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)	npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()						npcHandler:onThink()						end

local travelNode = keywordHandler:addKeyword({'exit'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Posso te levar para o barco de thais de graça. Você quer ir? Diga: {yes}'})
        	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, level = 0, cost = 0, destination = {x=32311, y=32210, z=6} })
        	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Maybe another time, then.'})
			
local travelNode = keywordHandler:addKeyword({'upper'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Posso te levar para o norte de roshamuul de graça. Você quer ir? Diga: {yes}'})
        	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, level = 0, cost = 0, destination = {x = 33739, y = 32312, z = 6} })
        	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Maybe another time, then.'})
        
        keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'That is quite a long unprofitable travel. I\'ll bring you to Yalahar for 400 gold though. Is that ok with you?'})
        keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'I am the captain of this ship.'})
		keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'I am the captain of this ship.'})

npcHandler:addModule(FocusModule:new())

npcHandler:setMessage(MESSAGE_GREET, "Seja bem vindo, |PLAYERNAME|. Diga {exit} se quiser voltar para thais ou {upper} para eu te levar ao norte de roshamuul.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Adeus. Você é sempre bem vindo.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())