local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end
function onPlayerEndTrade(cid)              npcHandler:onPlayerEndTrade(cid)            end
function onPlayerCloseChannel(cid)          npcHandler:onPlayerCloseChannel(cid)        end

function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
	end
	
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid
	if(msgcontains(msg, 'first rod') or msgcontains(msg, 'first wand')) then
		if(isSorcerer(cid) or isDruid(cid)) then
			if(getPlayerStorageValue(cid, 10002) <= 0) then
				npcHandler:say("So you ask me for a {" .. getItemNameById(items[getPlayerVocation(cid)]) .. "} to begin your advanture?", cid)
				talkState[talkUser] = 1
			else
				npcHandler:say("What? I have already gave you one {" .. getItemNameById(items[getPlayerVocation(cid)]) .. "}!", cid)
				talkState[talkUser] = 0
			end
		else
			npcHandler:say("Sorry, you aren't a druid either a sorcerer.", cid)
			talkState[talkUser] = 0
		end
		
	elseif (msgcontains(msg, 'winning lottery ticket') or msgcontains(msg, 'lottery ticket') or msgcontains(msg, 'ticket') or msgcontains(msg, 'lottery')) then
		npcHandler:say("Você quer trocar 100 vials ou flasks vazios por 1 Lottery Ticket? {OBS:} Você pode comprar os vials ou flasks comigo ou com 'Bezil', o comerciantes de ferramentas.",cid)
		talkState[talkUser] = 2
		
	elseif(msgcontains(msg, 'yes')) then
		if(talkState[talkUser] == 1) then
			doPlayerAddItem(cid, items[getPlayerVocation(cid)], 1)
			npcHandler:say("Here you are young adept, take care yourself.", cid)
			setPlayerStorageValue(cid, 10002, 1)
			talkState[talkUser] = 0
		
		elseif(talkState[talkUser] == 2) then
			if getPlayerItemCount(cid, 2006) >= 100 then
				if doPlayerRemoveItem(cid, 2006, 100) then
					npcHandler:say("Muito Bom! Um prazer negociar com você!", cid)
					doPlayerAddItem(cid, 5957, 1)
					talkState[talkUser] = 0
				else
					doPlayerSendTextMessage(cid,25,"ERROR! Please contact the administrator.")
					talkState[talkUser] = 0
				end
			elseif getPlayerItemCount(cid, 7636) >= 100 then
				if doPlayerRemoveItem(cid, 7636, 100) then
					npcHandler:say("Muito Bom! Um prazer negociar com você!", cid)
					doPlayerAddItem(cid, 5957, 1)
					talkState[talkUser] = 0
				else
					doPlayerSendTextMessage(cid,25,"ERROR! Please contact the administrator.")
					talkState[talkUser] = 0
				end
			elseif getPlayerItemCount(cid, 7634) >= 100 then
				if doPlayerRemoveItem(cid, 7634, 100) then
					npcHandler:say("Muito Bom! Um prazer negociar com você!", cid)
					doPlayerAddItem(cid, 5957, 1)
					talkState[talkUser] = 0
				else
					doPlayerSendTextMessage(cid,25,"ERROR! Please contact the administrator.")
					talkState[talkUser] = 0
				end
			elseif getPlayerItemCount(cid, 7635) >= 100 then
				if doPlayerRemoveItem(cid, 7635, 100) then
					npcHandler:say("Muito Bom! Um prazer negociar com você!", cid)
					doPlayerAddItem(cid, 5957, 1)
					talkState[talkUser] = 0
				else
					doPlayerSendTextMessage(cid,25,"ERROR! Please contact the administrator.")
					talkState[talkUser] = 0
				end
			else
				npcHandler:say("Você não tem todos os itens.", cid)
				talkState[talkUser] = 0
			end
		end
		
	elseif(msgcontains(msg, 'no') and isInArray({1,2}, talkState[talkUser])) then
		npcHandler:say("Ok then.", cid)
		talkState[talkUser] = 0
	end
	return true
end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

shopModule:addBuyableItem({'empty potion flask'}, 7636, 100, 'empty potion flask')
shopModule:addBuyableItem({'avalanche rune'}, 2274, 45, 'avalanche rune')
shopModule:addBuyableItem({'animate dead rune'}, 2316, 375, 'animate dead rune')
shopModule:addBuyableItem({'blank rune'}, 2260, 10, 'blank rune')
shopModule:addBuyableItem({'chameleon rune'}, 2291, 210, 'chameleon rune')
shopModule:addBuyableItem({'convince creature rune'}, 2290, 80, 'convince creature rune')
shopModule:addBuyableItem({'cure poison rune'}, 2266, 65, 'cure poison rune')
shopModule:addBuyableItem({'destroy field rune'}, 2261, 15, 'destroy field rune')
shopModule:addBuyableItem({'disintegrate rune'}, 2310, 26, 'disintegrate rune')
shopModule:addBuyableItem({'energy bomb rune'}, 2262, 162, 'energy bomb rune')
shopModule:addBuyableItem({'energy field rune'}, 2277, 38, 'energy field rune')
shopModule:addBuyableItem({'energy wall rune'}, 2279, 85, 'energy wall rune')
shopModule:addBuyableItem({'explosion rune'}, 2313, 31, 'explosion rune')
shopModule:addBuyableItem({'fireball rune'}, 2302, 30, 'fireball rune')
shopModule:addBuyableItem({'fire bomb rune'}, 2305, 117, 'fire bomb rune')
shopModule:addBuyableItem({'fire field rune'}, 2301, 28, 'fire field rune')
shopModule:addBuyableItem({'fire wall rune'}, 2303, 61, 'fire wall rune')
shopModule:addBuyableItem({'great fireball rune'}, 2304, 45, 'great fireball rune')
shopModule:addBuyableItem({'great health potion'}, 7591, 190, 'great health potion')
shopModule:addBuyableItem({'great mana potion'}, 7590, 120, 'great mana potion')
shopModule:addBuyableItem({'great spirit potion'}, 8472, 190, 'great spirit potion')
shopModule:addBuyableItem({'health potion'}, 7618, 45, 'health potion')
shopModule:addBuyableItem({'heavy magic missile rune'}, 2311, 12, 'heavy magic missile rune')
shopModule:addBuyableItem({'holy missile rune'}, 2295, 16, 'holy missile rune')
shopModule:addBuyableItem({'great holy rune'}, 2297, 45, 'great holy rune')
shopModule:addBuyableItem({'icicle rune'}, 2271, 30, 'icicle rune')
shopModule:addBuyableItem({'intense healing rune'}, 2265, 95, 'intense healing rune')
shopModule:addBuyableItem({'light magic missile rune'}, 2287, 4, 'light magic missile rune')
shopModule:addBuyableItem({'magic wall rune'}, 2293, 116, 'magic wall rune')
-- shopModule:addBuyableItem({'mana rune'}, 2270, 210, 'mana rune')
shopModule:addBuyableItem({'paralyze rune'}, 2278, 700, 'paralyze rune')
shopModule:addBuyableItem({'mana potion'}, 7620, 50, 'mana potion')
shopModule:addBuyableItem({'moonlight rod'}, 2186, 1000, 'moonlight rod')
shopModule:addBuyableItem({'necrotic rod'}, 2185, 5000, 'necrotic rod')
shopModule:addBuyableItem({'poison bomb rune'}, 2286, 85, 'poison bomb rune')
shopModule:addBuyableItem({'poison field rune'}, 2285, 21, 'poison field rune')
shopModule:addBuyableItem({'poison wall rune'}, 2289, 52, 'poison wall rune')
shopModule:addBuyableItem({'snakebite rod'}, 2182, 500, 'snakebite rod')
shopModule:addBuyableItem({'spellbook'}, 2175, 150, 'spellbook')
shopModule:addBuyableItem({'stalagmite rune'}, 2292, 12, 'stalagmite rune')
shopModule:addBuyableItem({'soulfire rune'}, 2308, 46, 'soulfire rune')
shopModule:addBuyableItem({'stone shower rune'}, 2288, 37, 'stone shower rune')
shopModule:addBuyableItem({'strong health potion'}, 7588, 100, 'strong health potion')
shopModule:addBuyableItem({'strong mana potion'}, 7589, 80, 'strong mana potion')
shopModule:addBuyableItem({'sudden death rune'}, 2268, 108, 'sudden death rune')
shopModule:addBuyableItem({'terra rod'}, 2181, 10000, 'terra rod')
shopModule:addBuyableItem({'thunderstorm rune'}, 2315, 37, 'thunderstorm rune')
shopModule:addBuyableItem({'ultimate healing rune'}, 2273, 175, 'ultimate healing rune')
shopModule:addBuyableItem({'ultimate health potion'}, 8473, 310, 'ultimate health potion')
shopModule:addBuyableItem({'wand of cosmic energy'}, 2189, 10000, 'wand of cosmic energy')
shopModule:addBuyableItem({'wand of decay'}, 2188, 5000, 'wand of decay')
shopModule:addBuyableItem({'wand of dragonbreath'}, 2191, 1000, 'wand of dragonbreath')
shopModule:addBuyableItem({'wand of vortex'}, 2190, 500, 'wand of vortex')
shopModule:addBuyableItem({'wild growth rune'}, 2269, 160, 'wild growth rune')
shopModule:addBuyableItem({'wand of draconia'}, 8921, 7500, 'wand of draconia')
shopModule:addBuyableItem({'wand of inferno'}, 2187, 15000, 'wand of inferno')
shopModule:addBuyableItem({'wand of starstorm'}, 8920, 18000, 'wand of starstorm')
shopModule:addBuyableItem({'wand of voodoo'}, 8922, 22000, 'wand of voodoo')
shopModule:addBuyableItem({'northwind rod'}, 8911, 7500, 'northwind rod')
shopModule:addBuyableItem({'hailstorm rod'}, 2183, 15000, 'hailstorm rod')
shopModule:addBuyableItem({'springsprout rod'}, 8912, 18000, 'springsprout rod')
shopModule:addBuyableItem({'underworld rod'}, 8910, 22000, 'underworld rod')

shopModule:addSellableItem({'vial'}, 2006, 5, 'vial')
shopModule:addSellableItem({'empty potion flask small'}, 7636, 5, 'empty potion flask small')
shopModule:addSellableItem({'empty potion flask medium'}, 7634, 5, 'empty potion flask medium')
shopModule:addSellableItem({'empty potion flask large'}, 7635, 5, 'empty potion flask large')
shopModule:addSellableItem({'spellwand'}, 7735, 299, 'spellwand')
shopModule:addSellableItem({'wand of vortex'}, 2190, 100, 'wand of vortex')
shopModule:addSellableItem({'wand of dragonbreath'}, 2191, 200, 'wand of dragonbreath')
shopModule:addSellableItem({'wand of decay'}, 2188, 1000, 'wand of decay')
shopModule:addSellableItem({'wand of draconia'}, 8921, 1500, 'wand of draconia')
shopModule:addSellableItem({'wand of cosmic energy'}, 2189, 2000, 'wand of cosmic energy')
shopModule:addSellableItem({'wand of inferno'}, 2187, 3000, 'wand of inferno')
shopModule:addSellableItem({'wand of starstorm'}, 8920, 3600, 'wand of starstorm')
shopModule:addSellableItem({'wand of voodoo'}, 8922, 4400, 'wand of voodoo')
shopModule:addSellableItem({'snakebite rod'}, 2182, 100, 'snakebite rod')
shopModule:addSellableItem({'moonlight rod'}, 2186, 200, 'moonlight rod')
shopModule:addSellableItem({'necrotic rod'}, 2185, 1000, 'necrotic rod')
shopModule:addSellableItem({'northwind rod'}, 8911, 1500, 'northwind rod')
shopModule:addSellableItem({'terra rod'}, 2181, 2000, 'terra rod')
shopModule:addSellableItem({'hailstorm rod'}, 2183, 3000, 'hailstorm rod')
shopModule:addSellableItem({'springsprout rod'}, 8912, 3600, 'springsprout rod')
shopModule:addSellableItem({'underworld rod'}, 8910, 4400, 'underworld rod')
 
npcHandler:setMessage(MESSAGE_GREET, "Oh, por favor, |PLAYERNAME|. Se você precisar de equipamentos mágicos como runas ou varinhas, é só dizer {trade}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Adeus e volte.") 
npcHandler:setMessage(MESSAGE_WALKAWAY, "Volte logo!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Claro, basta procurar minhas mercadorias. Ou você quer olhar apenas para poções, varinhas ou runas?")

keywordHandler:addKeyword({"eclesius"}, StdModule.say, {npcHandler = npcHandler, text = "Eclesius is a good old friend of mine."})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I'm a sorcerer and trade all kinds of magic items."})
keywordHandler:addKeyword({"eclesius"}, StdModule.say, {npcHandler = npcHandler, text = "I heard that he left the city because he couldn't bear the shame of being rejected as courtmage. But that's just a gossip."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = " I'm Xodet, the owner of this shop."})
keywordHandler:addKeyword({"potions"}, StdModule.say, {npcHandler = npcHandler, text = "We offer health, spirit and mana potions in up to four sizes: normal, strong, great and ultimate. Ask me for a {trade} to see my offers."})
keywordHandler:addKeyword({"runes"}, StdModule.say, {npcHandler = npcHandler, text = "I'm selling spirit, health and mana potions, runes, wands, rods and spellbooks. If you'd like to see all of my offers, ask me for a {trade}."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())