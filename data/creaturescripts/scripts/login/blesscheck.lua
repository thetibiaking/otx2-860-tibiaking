function onThink(cid, lastExecution, thinkInterval)
for _, cid in ipairs(getPlayersOnline()) do
    if(getTilePzInfo(getCreaturePosition(cid))) == false and getPlayerStorageValue(cid, 23333) <= 0 then
        for b = 1,5 do
            if getPlayerBlessing(cid, b) == false then
               setPlayerStorageValue(cid, 23333, 1)
			   doPlayerSendTextMessage(cid, 25, "[WARNING] You are not blessed, type !bless")
               return false
            end
        end
    elseif (getTilePzInfo(getCreaturePosition(cid))) == true and getPlayerStorageValue(cid, 23333) == 1 then
        setPlayerStorageValue(cid, 23333, -1)
    end
end
return true
end