local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
 
function onCreatureAppear(cid)    npcHandler:onCreatureAppear(cid)   end
function onCreatureDisappear(cid)   npcHandler:onCreatureDisappear(cid)   end
function onCreatureSay(cid, type, msg)   npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()     npcHandler:onThink()     end
 
local items = {
          item1 = {6527, 2197}, -- item1 item que será pedido e que será dado na primeira troca
          item2 = {6527, 12673}, -- item2 item que será pedido e que será dado na segunda troca
          item3 = {6527, 12674}, -- item3 item que será pedido e que será dado na primeira troca
          item4 = {6527, 12675}, -- item3 item que será pedido e que será dado na primeira troca
          item5 = {6527, 2164}, -- item3 item que será pedido e que será dado na primeira troca
          item6 = {6527, 5903}, -- item3 item que será pedido e que será dado na primeira troca
          item7 = {6527, 10020}, -- item3 item que será pedido e que será dado na primeira troca
          item8 = {6527, 5015}, -- item3 item que será pedido e que será dado na primeira troca
          item9 = {6527, 5804}, -- item3 item que será pedido e que será dado na primeira troca
          item10 = {6527, 5809}, -- item3 item que será pedido e que será dado na primeira troca
          item11 = {6527, 6099}, -- item3 item que será pedido e que será dado na primeira troca
          item12 = {6527, 6102}, -- item3 item que será pedido e que será dado na primeira troca
          item13 = {6527, 6101}, -- item3 item que será pedido e que será dado na primeira troca
          item14 = {6527, 6100}, -- item3 item que será pedido e que será dado na primeira troca
          item15 = {6527, 11754}, -- item1 item que será pedido e que será dado na primeira troca
          item16 = {6527, 10063}, -- item2 item que será pedido e que será dado na segunda troca
          item17 = {6527, 6579}, -- item3 item que será pedido e que será dado na primeira troca
          item18 = {6527, 2108}, -- item3 item que será pedido e que será dado na primeira troca
          item19 = {6527, 3954}, -- item3 item que será pedido e que será dado na primeira troca
          item20 = {6527, 11144}, -- item3 item que será pedido e que será dado na primeira troca
          item21 = {6527, 5080}, -- item3 item que será pedido e que será dado na primeira troca
          item22 = {6527, 9019}, -- item3 item que será pedido e que será dado na primeira troca
          item23 = {6527, 6512}, -- item3 item que será pedido e que será dado na primeira troca
          item24 = {6527, 11256}, -- item3 item que será pedido e que será dado na primeira troca
          item25 = {6527, 12682} -- item3 item que será pedido e que será dado na primeira troca






}
local counts = {
          count1 = {5, 5}, -- count1 quantidade que será pedido e que será dado na primeira troca
          count2 = {350, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count3 = {350, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count4 = {350, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count5 = {10, 20}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count6 = {3000, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count7 = {450, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count8 = {380, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count9 = {250, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count10 = {500, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count11 = {200, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count12 = {200, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count13 = {200, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count14 = {200, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count15 = {100, 1}, -- count1 quantidade que será pedido e que será dado na primeira troca
          count16 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count17 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count18 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count19 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count20 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count21 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count22 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count23 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count24 = {100, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
          count25 = {400, 1} -- count2 quantidade que será pedido e que será dado na segunda troca





}
 
function creatureSayCallback(cid, type, msg)
          if(not npcHandler:isFocused(cid)) then
                    return false
          end
          local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

          if msgcontains(msg, 'stone skin amulet') then
                    if getPlayerItemCount(cid, items.item1[1]) >= counts.count1[1] then
                              doPlayerRemoveItem(cid, items.item1[1], counts.count1[1])
                              doPlayerAddItem(cid, items.item1[2], counts.count1[2])
                              selfSay('You just swap '.. counts.count1[1] ..' '.. getItemNameById(items.item1[1]) ..' for '.. counts.count1[2] ..' '.. getItemNameById(items.item1[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count1[1] ..' '.. getItemNameById(items.item1[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'vip moon backpack') then
                    if getPlayerItemCount(cid, items.item2[1]) >= counts.count2[1] then
                              doPlayerRemoveItem(cid, items.item2[1], counts.count2[1])
                              doPlayerAddItem(cid, items.item2[2], counts.count2[2])
                              selfSay('You just swap '.. counts.count2[1] ..' '.. getItemNameById(items.item2[1]) ..' for '.. counts.count2[2] ..' '.. getItemNameById(items.item2[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count2[1] ..' '.. getItemNameById(items.item2[1]) ..'.', cid)
                    end

         elseif msgcontains(msg, 'vip demon backpack') then
                    if getPlayerItemCount(cid, items.item3[1]) >= counts.count3[1] then
                              doPlayerRemoveItem(cid, items.item3[1], counts.count3[1])
                              doPlayerAddItem(cid, items.item3[2], counts.count3[2])
                              selfSay('You just swap '.. counts.count3[1] ..' '.. getItemNameById(items.item3[1]) ..' for '.. counts.count3[2] ..' '.. getItemNameById(items.item3[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count3[1] ..' '.. getItemNameById(items.item3[1]) ..'.', cid)
                    end

       elseif msgcontains(msg, 'vip minotaur backpack') then
                    if getPlayerItemCount(cid, items.item4[1]) >= counts.count4[1] then
                              doPlayerRemoveItem(cid, items.item4[1], counts.count3[1])
                              doPlayerAddItem(cid, items.item4[2], counts.count4[2])
                              selfSay('You just swap '.. counts.count4[1] ..' '.. getItemNameById(items.item4[1]) ..' for '.. counts.count4[2] ..' '.. getItemNameById(items.item4[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count4[1] ..' '.. getItemNameById(items.item4[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'might ring') then
                    if getPlayerItemCount(cid, items.item5[1]) >= counts.count5[1] then
                              doPlayerRemoveItem(cid, items.item5[1], counts.count5[1])
                              doPlayerAddItem(cid, items.item5[2], counts.count5[2])
                              selfSay('You just swap '.. counts.count5[1] ..' '.. getItemNameById(items.item5[1]) ..' for '.. counts.count5[2] ..' '.. getItemNameById(items.item5[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count5[1] ..' '.. getItemNameById(items.item5[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'ferumbras hat') then
                    if getPlayerItemCount(cid, items.item6[1]) >= counts.count6[1] then
                              doPlayerRemoveItem(cid, items.item6[1], counts.count6[1])
                              doPlayerAddItem(cid, items.item6[2], counts.count6[2])
                              selfSay('You just swap '.. counts.count6[1] ..' '.. getItemNameById(items.item6[1]) ..' for '.. counts.count6[2] ..' '.. getItemNameById(items.item6[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count6[1] ..' '.. getItemNameById(items.item6[1]) ..'.', cid)
                    end

           elseif msgcontains(msg, 'dragon claw') then
                    if getPlayerItemCount(cid, items.item7[1]) >= counts.count7[1] then
                              doPlayerRemoveItem(cid, items.item7[1], counts.count7[1])
                              doPlayerAddItem(cid, items.item7[2], counts.count7[2])
                              selfSay('You just swap '.. counts.count7[1] ..' '.. getItemNameById(items.item7[1]) ..' for '.. counts.count7[2] ..' '.. getItemNameById(items.item7[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count7[1] ..' '.. getItemNameById(items.item7[1]) ..'.', cid)
                    end

         elseif msgcontains(msg, 'mandrake') then
                    if getPlayerItemCount(cid, items.item8[1]) >= counts.count8[1] then
                              doPlayerRemoveItem(cid, items.item8[1], counts.count8[1])
                              doPlayerAddItem(cid, items.item8[2], counts.count8[2])
                              selfSay('You just swap '.. counts.count8[1] ..' '.. getItemNameById(items.item8[1]) ..' for '.. counts.count8[2] ..' '.. getItemNameById(items.item8[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count8[1] ..' '.. getItemNameById(items.item8[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'nose ring') then
                    if getPlayerItemCount(cid, items.item9[1]) >= counts.count9[1] then
                              doPlayerRemoveItem(cid, items.item9[1], counts.count9[1])
                              doPlayerAddItem(cid, items.item9[2], counts.count9[2])
                              selfSay('You just swap '.. counts.count9[1] ..' '.. getItemNameById(items.item9[1]) ..' for '.. counts.count9[2] ..' '.. getItemNameById(items.item9[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count9[1] ..' '.. getItemNameById(items.item9[1]) ..'.', cid)
                    end

           elseif msgcontains(msg, 'soul stone') then
                    if getPlayerItemCount(cid, items.item10[1]) >= counts.count10[1] then
                              doPlayerRemoveItem(cid, items.item10[1], counts.count10[1])
                              doPlayerAddItem(cid, items.item10[2], counts.count10[2])
                              selfSay('You just swap '.. counts.count10[1] ..' '.. getItemNameById(items.item10[1]) ..' for '.. counts.count10[2] ..' '.. getItemNameById(items.item10[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count10[1] ..' '.. getItemNameById(items.item10[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'deadeye devious eye patch') then
                    if getPlayerItemCount(cid, items.item11[1]) >= counts.count11[1] then
                              doPlayerRemoveItem(cid, items.item11[1], counts.count11[1])
                              doPlayerAddItem(cid, items.item11[2], counts.count11[2])
                              selfSay('You just swap '.. counts.count11[1] ..' '.. getItemNameById(items.item11[1]) ..' for '.. counts.count11[2] ..' '.. getItemNameById(items.item11[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count11[1] ..' '.. getItemNameById(items.item11[1]) ..'.', cid)
                    end

           elseif msgcontains(msg, 'brutus bloodbeards hat') then
                    if getPlayerItemCount(cid, items.item12[1]) >= counts.count12[1] then
                              doPlayerRemoveItem(cid, items.item12[1], counts.count12[1])
                              doPlayerAddItem(cid, items.item12[2], counts.count12[2])
                              selfSay('You just swap '.. counts.count12[1] ..' '.. getItemNameById(items.item12[1]) ..' for '.. counts.count12[2] ..' '.. getItemNameById(items.item12[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count12[1] ..' '.. getItemNameById(items.item12[1]) ..'.', cid)
                    end

            elseif msgcontains(msg, 'ron the rippers sabre') then
                    if getPlayerItemCount(cid, items.item13[1]) >= counts.count13[1] then
                              doPlayerRemoveItem(cid, items.item13[1], counts.count13[1])
                              doPlayerAddItem(cid, items.item13[2], counts.count13[2])
                              selfSay('You just swap '.. counts.count13[1] ..' '.. getItemNameById(items.item13[1]) ..' for '.. counts.count13[2] ..' '.. getItemNameById(items.item13[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count13[1] ..' '.. getItemNameById(items.item13[1]) ..'.', cid)
                    end

           elseif msgcontains(msg, 'lethal lissys shirt') then
                    if getPlayerItemCount(cid, items.item14[1]) >= counts.count14[1] then
                              doPlayerRemoveItem(cid, items.item14[1], counts.count14[1])
                              doPlayerAddItem(cid, items.item14[2], counts.count14[2])
                              selfSay('You just swap '.. counts.count14[1] ..' '.. getItemNameById(items.item14[1]) ..' for '.. counts.count14[2] ..' '.. getItemNameById(items.item14[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count14[1] ..' '.. getItemNameById(items.item14[1]) ..'.', cid)
            end

           elseif msgcontains(msg, 'ferumbras doll') then
                    if getPlayerItemCount(cid, items.item15[1]) >= counts.count15[1] then
                              doPlayerRemoveItem(cid, items.item15[1], counts.count15[1])
                              doPlayerAddItem(cid, items.item15[2], counts.count15[2])
                              selfSay('You just swap '.. counts.count15[1] ..' '.. getItemNameById(items.item15[1]) ..' for '.. counts.count15[2] ..' '.. getItemNameById(items.item15[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count15[1] ..' '.. getItemNameById(items.item15[1]) ..'.', cid)
                    end

         elseif msgcontains(msg, 'epaminondas doll') then
                    if getPlayerItemCount(cid, items.item16[1]) >= counts.count16[1] then
                              doPlayerRemoveItem(cid, items.item16[1], counts.count16[1])
                              doPlayerAddItem(cid, items.item16[2], counts.count16[2])
                              selfSay('You just swap '.. counts.count16[1] ..' '.. getItemNameById(items.item16[1]) ..' for '.. counts.count16[2] ..' '.. getItemNameById(items.item16[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count16[1] ..' '.. getItemNameById(items.item16[1]) ..'.', cid)
                    end

       elseif msgcontains(msg, 'tibia doll') then
                    if getPlayerItemCount(cid, items.item17[1]) >= counts.count17[1] then
                              doPlayerRemoveItem(cid, items.item17[1], counts.count17[1])
                              doPlayerAddItem(cid, items.item17[2], counts.count17[2])
                              selfSay('You just swap '.. counts.count17[1] ..' '.. getItemNameById(items.item17[1]) ..' for '.. counts.count17[2] ..' '.. getItemNameById(items.item17[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count17[1] ..' '.. getItemNameById(items.item17[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'wooden doll') then
                    if getPlayerItemCount(cid, items.item19[1]) >= counts.count18[1] then
                              doPlayerRemoveItem(cid, items.item18[1], counts.count18[1])
                              doPlayerAddItem(cid, items.item18[2], counts.count18[2])
                              selfSay('You just swap '.. counts.count18[1] ..' '.. getItemNameById(items.item18[1]) ..' for '.. counts.count18[2] ..' '.. getItemNameById(items.item18[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count18[1] ..' '.. getItemNameById(items.item18[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'bear doll') then
                    if getPlayerItemCount(cid, items.item19[1]) >= counts.count19[1] then
                              doPlayerRemoveItem(cid, items.item19[1], counts.count19[1])
                              doPlayerAddItem(cid, items.item19[2], counts.count19[2])
                              selfSay('You just swap '.. counts.count19[1] ..' '.. getItemNameById(items.item19[1]) ..' for '.. counts.count19[2] ..' '.. getItemNameById(items.item19[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count19[1] ..' '.. getItemNameById(items.item19[1]) ..'.', cid)
                    end

           elseif msgcontains(msg, 'nightmare doll') then
                    if getPlayerItemCount(cid, items.item20[1]) >= counts.count20[1] then
                              doPlayerRemoveItem(cid, items.item20[1], counts.count20[1])
                              doPlayerAddItem(cid, items.item20[2], counts.count20[2])
                              selfSay('You just swap '.. counts.count20[1] ..' '.. getItemNameById(items.item20[1]) ..' for '.. counts.count20[2] ..' '.. getItemNameById(items.item20[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count20[1] ..' '.. getItemNameById(items.item20[1]) ..'.', cid)
                    end

         elseif msgcontains(msg, 'panda teddy') then
                    if getPlayerItemCount(cid, items.item21[1]) >= counts.count21[1] then
                              doPlayerRemoveItem(cid, items.item21[1], counts.count21[1])
                              doPlayerAddItem(cid, items.item21[2], counts.count21[2])
                              selfSay('You just swap '.. counts.count21[1] ..' '.. getItemNameById(items.item21[1]) ..' for '.. counts.count21[2] ..' '.. getItemNameById(items.item21[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count21[1] ..' '.. getItemNameById(items.item21[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'snowman doll') then
                    if getPlayerItemCount(cid, items.item22[1]) >= counts.count22[1] then
                              doPlayerRemoveItem(cid, items.item22[1], counts.count22[1])
                              doPlayerAddItem(cid, items.item22[2], counts.count22[2])
                              selfSay('You just swap '.. counts.count22[1] ..' '.. getItemNameById(items.item22[1]) ..' for '.. counts.count22[2] ..' '.. getItemNameById(items.item22[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count22[1] ..' '.. getItemNameById(items.item22[1]) ..'.', cid)
                    end

           elseif msgcontains(msg, 'vampire doll') then
                    if getPlayerItemCount(cid, items.item23[1]) >= counts.count23[1] then
                              doPlayerRemoveItem(cid, items.item23[1], counts.count23[1])
                              doPlayerAddItem(cid, items.item23[2], counts.count23[2])
                              selfSay('You just swap '.. counts.count23[1] ..' '.. getItemNameById(items.item23[1]) ..' for '.. counts.count23[2] ..' '.. getItemNameById(items.item23[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count23[1] ..' '.. getItemNameById(items.item23[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'santa doll') then
                    if getPlayerItemCount(cid, items.item24[1]) >= counts.count24[1] then
                              doPlayerRemoveItem(cid, items.item24[1], counts.count24[1])
                              doPlayerAddItem(cid, items.item24[2], counts.count24[2])
                              selfSay('You just swap '.. counts.count24[1] ..' '.. getItemNameById(items.item24[1]) ..' for '.. counts.count24[2] ..' '.. getItemNameById(items.item24[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count24[1] ..' '.. getItemNameById(items.item24[1]) ..'.', cid)
                    end

          elseif msgcontains(msg, 'Mistery Box') then
                    if getPlayerItemCount(cid, items.item25[1]) >= counts.count25[1] then
                              doPlayerRemoveItem(cid, items.item25[1], counts.count25[1])
                              doPlayerAddItem(cid, items.item25[2], counts.count25[2])
                              selfSay('You just swap '.. counts.count25[1] ..' '.. getItemNameById(items.item25[1]) ..' for '.. counts.count25[2] ..' '.. getItemNameById(items.item25[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count25[1] ..' '.. getItemNameById(items.item25[1]) ..'.', cid)
                    end
          end
          return TRUE
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())