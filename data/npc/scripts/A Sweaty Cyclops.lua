local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)            npcHandler:onCreatureAppear(cid)        end
function onCreatureDisappear(cid)        npcHandler:onCreatureDisappear(cid)        end
function onCreatureSay(cid, type, msg)        npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                npcHandler:onThink()                end

-- XVX FORGER START --

function amulet(cid, message, keywords, parameters, node)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
        if getPlayerItemCount(cid,8262) >= 1 and getPlayerItemCount(cid,8263) >= 1 and getPlayerItemCount(cid,8264) >= 1 and  getPlayerItemCount(cid,8265) >= 1 then
        if doPlayerRemoveItem(cid,8262,1) and doPlayerRemoveItem(cid,8263,1) and doPlayerRemoveItem(cid,8264,1) and  doPlayerRemoveItem(cid,8265,1) == TRUE then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,8266,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function obsidian(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2516) >= 1 and getPlayerItemCount(cid,2425) >= 1 then
        if doPlayerRemoveItem(cid,2516,1) and doPlayerRemoveItem(cid,2425,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5908,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end	

function crude(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2393) >= 1 then
        if doPlayerRemoveItem(cid,2393,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5892,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function spool(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,5879) >= 10 then
        if doPlayerRemoveItem(cid,5879,10) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5886,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function ticket(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2160) >= 5 then
        if doPlayerRemoveItem(cid,2160,5) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5958,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function warrior(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2475) >= 4 then
        if doPlayerRemoveItem(cid,2475,4) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5885,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function sulphur(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2392) >= 3 then
        if doPlayerRemoveItem(cid,2392,3) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5904,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function chicken(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2195) >= 1 then
        if doPlayerRemoveItem(cid,2195,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5891,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function royal(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2487) >= 1 then
        if doPlayerRemoveItem(cid,2487,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5887,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function hell(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2462) >= 1 then
        if doPlayerRemoveItem(cid,2462,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5888,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function crossbow(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,5954) >= 15 then
        if doPlayerRemoveItem(cid,5954,15) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5947,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function fighting(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2498) >= 2 then
        if doPlayerRemoveItem(cid,2498,2) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5884,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function bolt(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,5944) >= 1 then
        if doPlayerRemoveItem(cid,5944,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,6529,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function bluepieceofcloth(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2663) >= 1 then
        if doPlayerRemoveItem(cid,2663,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5912,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function greenpieceofcloth(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2652) >= 1 then
        if doPlayerRemoveItem(cid,2652,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5910,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function redpieceofcloth(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2655) >= 1 then
        if doPlayerRemoveItem(cid,2655,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5911,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
    end
end

function draconian(cid, message, keywords, parameters, node)
    if not npcHandler:isFocused(cid) then
        return false
    end
        if getPlayerItemCount(cid,2516) >= 1 then
        if doPlayerRemoveItem(cid,2516,1) then
            npcHandler:say('Here is your item!', cid)
            doPlayerAddItem(cid,5889,1)
        end
        else
            npcHandler:say('You don\'t have these items!', cid)
   end   
end

-- XVX FORGER END --

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can forge Amulet, Obsidian Knife, Huge Chunk of Crude Iron, Piece of Draconian Steel, spool of yarn, ticket, warrior sweat, magic sulphur, enchanted chicken wing, royal steel, hell steel, crossbow, fighting spirit, infernal bolt, blue piece of cloth, green piece of cloth and red piece of cloth!"})

local node1 = keywordHandler:addKeyword({'amulet'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Hum Humm! Welcume lil. Me can do unbroken but Big Ben need a lil time to make it unbroken. Yes or no??'})
    node1:addChildKeyword({'yes'}, amulet, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node2 = keywordHandler:addKeyword({'obsidian'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a Dragon Shield and an Obsidian Lance for a Obsidian Knife?'})
    node2:addChildKeyword({'yes'}, obsidian, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node2:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node3 = keywordHandler:addKeyword({'crude'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a Giant Sword for a Huge Chunk of Crude Iron?'})
    node3:addChildKeyword({'yes'}, crude, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node3:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node4 = keywordHandler:addKeyword({'spool'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a Dragon Shield for a Piece of Draconian Steel?'})
    node4:addChildKeyword({'yes'}, spool, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node4:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node5 = keywordHandler:addKeyword({'ticket'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a 50k for a ticket?'})
    node5:addChildKeyword({'yes'}, ticket, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node5:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})
	
local node6 = keywordHandler:addKeyword({'warrior'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a 4 warrior helmet for a warrior sweat?'})
    node6:addChildKeyword({'yes'}, warrior, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node6:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node7 = keywordHandler:addKeyword({'sulphur'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a 3 fire sword for a magic sulphur?'})
    node7:addChildKeyword({'yes'}, sulphur, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node7:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node8 = keywordHandler:addKeyword({'chicken'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a boots of haste for a enchanted chicken wing?'})
    node8:addChildKeyword({'yes'}, chicken, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node8:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})
	
local node9 = keywordHandler:addKeyword({'royal'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a crown armor for a royal steel?'})
    node9:addChildKeyword({'yes'}, royal, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node9:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node10 = keywordHandler:addKeyword({'hell'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a devil helmet for a hell steel?'})
    node10:addChildKeyword({'yes'}, hell, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node10:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node11 = keywordHandler:addKeyword({'crossbow'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a 15 demon horn for a elane crossbow?'})
    node11:addChildKeyword({'yes'}, crossbow, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node11:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})
	
local node12 = keywordHandler:addKeyword({'fighting'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a royal helmet for a fighting spirit?'})
    node12:addChildKeyword({'yes'}, fighting, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node12:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node13 = keywordHandler:addKeyword({'bolt'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a soul orb for a 1 infernal bolt?'})
    node13:addChildKeyword({'yes'}, bolt, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node13:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node14 = keywordHandler:addKeyword({'bluepieceofcloth'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a mystic turban for a blue piece of cloth?'})
    node14:addChildKeyword({'yes'}, bluepieceofcloth, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node14:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node15 = keywordHandler:addKeyword({'greenpieceofcloth'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a green tunic for a green piece of cloth?'})
    node15:addChildKeyword({'yes'}, greenpieceofcloth, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node15:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node16 = keywordHandler:addKeyword({'redpieceofcloth'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a red robe for a red piece of cloth?'})
    node16:addChildKeyword({'yes'}, redpieceofcloth, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node16:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})

local node17 = keywordHandler:addKeyword({'draconian'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to trade a Dragon Shield for a Piece of Draconian Steel?'})
    node17:addChildKeyword({'yes'}, draconian, {npcHandler = npcHandler, onlyFocus = true, reset = true})
    node17:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got the neccessary items.', reset = true})
 
npcHandler:addModule(FocusModule:new())