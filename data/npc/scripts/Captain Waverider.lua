local keywordHandler = KeywordHandler:new()
        local npcHandler = NpcHandler:new(keywordHandler)
        NpcSystem.parseParameters(npcHandler)
        
        
        
        -- OTServ event handling functions start
        function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid) end
        function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid) end
        function onCreatureSay(cid, type, msg) 	npcHandler:onCreatureSay(cid, type, msg) end
        function onThink() 						npcHandler:onThink() end
        -- OTServ event handling functions end
        
        
        -- Don't forget npcHandler = npcHandler in the parameters. It is required for all StdModule functions!
        local travelNode = keywordHandler:addKeyword({'peg leg'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Ohhhh. So... <lowers his voice> you know who sent you so I sail you to you know where. <wink> <wink> It will cost 0 gold to cover my expenses. Is it that what you wish?'})
        	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, level = 0, cost = 0, destination = {x=32346, y=32625, z=7} })
        	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'I have to admit this leaves me a bit puzzled.'})

        local travelNode = keywordHandler:addKeyword({'treasure island'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Ohhhh. So... u are go to treasure island?'})
        	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 0, destination = {x=32129, y=32913, z=7} })
        	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'I have to admit this leaves me a bit puzzled.'})
    
        npcHandler:addModule(FocusModule:new())