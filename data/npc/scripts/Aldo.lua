local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local Topic = {}
 
local stuff = {
   [1] = {name = 'soft', price = 1000, worn = 10021, ID = 6132},
   [2] = {name = 'firewalker', price = 1000, worn = 10022, ID = 9932}
}
 
function onCreatureAppear(cid)            npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)         npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)         npcHandler:onCreatureSay(cid, type, msg) end
function onThink()               npcHandler:onThink() end
 
function greetCallback(cid)
   Topic[cid] = 0
   return true
end
 
function creatureSayCallback(cid, type, msg)
   if not npcHandler:isFocused(cid) then
      return false
   elseif Topic[cid] ~= 0 then
      if msgcontains(msg, 'yes') then
         local v = stuff[Topic[cid]]
         if getPlayerItemCount(cid, v.worn) > 0 then
            if doPlayerRemoveMoney(cid, v.price) then
               doPlayerRemoveItem(cid, v.worn, 1)
               doPlayerAddItem(cid, v.ID, 1)
               npcHandler:say('Aqui tienes.', cid)
            else
               npcHandler:say('No dispones de suficiente dinero.',cid)
            end
         else
            npcHandler:say('No tienes unas worn ' .. v.name .. '.',cid)
         end
      else
         npcHandler:say('En otra ocasion entonces.', cid)
      end
      Topic[cid] = 0
   else
      for i = 1, #stuff do
         if msgcontains(msg, stuff[i].name) then
            npcHandler:say('Estas seguro que quieres reaparar tus ' .. stuff[i].name .. '?',cid)
            Topic[cid] = i
            break
         end
      end
   end
   return true
end
 
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())