local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end
function creatureSayCallback(cid, type, msg)
if(not npcHandler:isFocused(cid)) then
return false
end
local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
local MoedaVip = 6527 -- Id da MoedaVip
local shopWindow = {}
local t = {
		  [2390] = {price = 400}, -- [id do item] e em price qnto honor points vai custar
		  [8926] = {price = 125},
		  [8925] = {price = 125},
		  [8931] = {price = 125},
		  [8929] = {price = 125},
		  [6433] = {price = 50},
		  [6391] = {price = 50},
		  [2522] = {price = 60},
		  [2523] = {price = 150},
		  [2469] = {price = 50},
		  [2471] = {price = 150},
		  [2504] = {price = 30},
		  [8885] = {price = 45},
		  [8892] = {price = 50},
		  [8881] = {price = 50},
		  [8886] = {price = 50},
		  [2496] = {price = 70},
		  [2342] = {price = 60},
		  [8918] = {price = 125},
		  [8865] = {price = 50},		  		  
		  }
local onBuy = function(cid, item, subType, amount, ignoreCap, inBackpacks)
		if  t[item] and doPlayerRemoveItem(cid, MoedaVip, t[item].price) then
				doPlayerAddItem(cid, item, 1, false)            
				selfSay("Aqui esta o Item", cid)			 
				 else
			selfSay("Voce nao tem "..t[item].price.." blood event coin suficiente", cid)
		   end
		return true
end
if (msgcontains(msg, 'trade') or msgcontains(msg, 'TRADE'))then
						for var, ret in pairs(t) do
										table.insert(shopWindow, {id = var, subType = 0, buy = ret.price, sell = 0, name = getItemNameById(var)})
								end
						openShopWindow(cid, shopWindow, onBuy, onSell)
				end
return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())