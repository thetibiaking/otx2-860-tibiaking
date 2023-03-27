function onAdvance(cid, skill, oldlevel, newlevel)
    if(skill == SKILL__LEVEL and getPlayerStorageValue(cid, 41020) ~= 1 and newlevel >= 20) then
        setPlayerStorageValue(cid, 41020, 1)
        doPlayerAddItem(cid, 2160, 2)
        doCreatureSay(cid, "Congratulations " .. getCreatureName(cid) .. ", you have reached level 20, you will now be rewarded 2 crystal coins. Enjoy your hunting!", TALKTYPE_ORANGE_1)
    elseif(skill == SKILL__LEVEL and getPlayerStorageValue(cid, 41021) ~= 1 and newlevel >= 45) then
        setPlayerStorageValue(cid, 41021, 1)
        doPlayerAddItem(cid, 2160, 5)
        doCreatureSay(cid, "Congratulations " .. getCreatureName(cid) .. ", you have reached level 45, you will now be rewarded 5 crystal coins. Enjoy your hunting!", TALKTYPE_ORANGE_1)
	elseif(skill == SKILL__LEVEL and getPlayerStorageValue(cid, 41022) ~= 1 and newlevel >= 80) then
        setPlayerStorageValue(cid, 41022, 1)
        doPlayerAddItem(cid, 2160, 8)
        doCreatureSay(cid, "Congratulations " .. getCreatureName(cid) .. ", you have reached level 80, you will now be rewarded 8 crystal coins. Enjoy your hunting!", TALKTYPE_ORANGE_1)
	elseif(skill == SKILL__LEVEL and getPlayerStorageValue(cid, 41023) ~= 1 and newlevel >= 100) then
        setPlayerStorageValue(cid, 41023, 1)
        doPlayerAddItem(cid, 2160, 10)
        doCreatureSay(cid, "Congratulations " .. getCreatureName(cid) .. ", you have reached level 100, you will now be rewarded 10 crystal coins. Enjoy your hunting!", TALKTYPE_ORANGE_1)
    end
return true
end