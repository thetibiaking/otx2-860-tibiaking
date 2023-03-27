function onSay(cid, words, param)
if(param == "") then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[Bounty System]: Usage: \"!bounty [gold],[nick]\" where gold is at least 10000.")
        return TRUE
    end
    local t = string.explode(param, ",")
    if(not t[2]) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[Bounty System]: Usage: \"!bounty [gold],[nick]\" where gold is at least 10000.")
        return TRUE
    end
   
    local sp_id = getPlayerGUIDByName(t[2])
    if sp_id == nil then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[Bounty System]: You cant put a bounty on imaginary people, your target doesn't exist.")
        return TRUE
    end local result_plr = db.getResult("SELECT * FROM `bounty_hunters` WHERE `sp_id` = "..sp_id.." AND `killed` = 0;")
    if(result_plr:getID() ~= -1) then
        is = tonumber(result_plr:getDataInt("sp_id"))
        result_plr:free()
    else
        is = 0
    end
    prize = tonumber(t[1])
    if(prize == nil or prize < 10000) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "[Bounty System]: Usage: \"!bounty [gold],[nick]\" where gold is at least 10000.")
        return TRUE
    end
   
    if(prize >= 999999999) then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "[Bounty System]: Sorry, bounty limit is at 999.9 million gold!")
        return TRUE
    end if is ~= 0 then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "[Bounty System]: "..t[2].." has already got a bounty on his/her head.")
        return TRUE
    end
   
        if doPlayerRemoveMoney(cid, prize) == TRUE then
            db.executeQuery("INSERT INTO `bounty_hunters` VALUES (NULL,"..getPlayerGUID(cid)..","..sp_id..",0," .. os.time() .. ","..prize..",0,0);")
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, "[Bounty System]: Bounty on "..t[2].."s head has been added successfully!")
            doBroadcastMessage("[Bounty System]: A bounty of "..prize.." gold for "..t[2].."s head has been submitted by "..getPlayerName(cid)..". The first one to kill "..t[2].." will get the gold!", MESSAGE_EVENT_ADVANCE)
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "[Bounty System]: You dont have enough gold!")
        end
   
   
    return 1
end