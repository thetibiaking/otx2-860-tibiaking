local tpId = 1387

local tps = {
        ["Ranris"] = {pos = {x = 33698, y = 32778, z = 10}, toPos = {x = 33698, y = 32778, z = 9}, time = 300},

  }

 

function removeTp(tp)

        local t = getTileItemById(tp.pos, tpId)

        if t then

                doRemoveItem(t.uid, 1)

                doSendMagicEffect(tp.pos, CONST_ME_POFF)

        end

end

 

function onDeath(cid)

        local tp = tps[getCreatureName(cid)]

        if tp then

                doCreateTeleport(tpId, tp.toPos, tp.pos)

                doCreatureSay(cid, "Entre no teleporte! ele ira sumir em "..tp.time.." segundos.", TALKTYPE_ORANGE_1)

                addEvent(removeTp, tp.time*1000, tp)

        end

        return TRUE

end