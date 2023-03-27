local male = {lookType = 801, lookHead = 20, lookBody = 132, lookLegs = 76, lookFeet = 132}
local female = {lookType = 794, lookHead = 20, lookBody = 132, lookLegs = 76, lookFeet = 132}

local config = {
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

function onLogin(cid)
registerCreatureEvent(cid, "PlayerKill")
    if (InitArenaScript ~= 0) then
    InitArenaScript = 1
    -- make arena rooms free
        for i = 42300, 42309 do
            setGlobalStorageValue(i, 0)
            setGlobalStorageValue(i+100, 0)
        end
    end
    -- if he did not make full arena 1 he must start from zero
    if getPlayerStorageValue(cid, 42309) < 1 then
        for i = 42300, 42309 do
            setPlayerStorageValue(cid, i, 0)
        end
    end
    -- if he did not make full arena 2 he must start from zero
    if getPlayerStorageValue(cid, 42319) < 1 then
        for i = 42310, 42319 do
            setPlayerStorageValue(cid, i, 0)
        end
    end
    -- if he did not make full arena 3 he must start from zero
    if getPlayerStorageValue(cid, 42329) < 1 then
        for i = 42320, 42329 do
            setPlayerStorageValue(cid, i, 0)
        end
    end
    if getPlayerStorageValue(cid, 42355) == -1 then
        setPlayerStorageValue(cid, 42355, 0) -- did not arena level
    end
    setPlayerStorageValue(cid, 42350, 0) -- time to kick 0
    setPlayerStorageValue(cid, 42352, 0) -- is not in arena
	
local text = "Welcome To The Blood-WAR! Type !info for more information."
local useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
local loss = getConfigValue('deathLostPercent')

	if(loss ~= nil) then
		doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, loss * 10)
	end

	local lastLogin = getPlayerLastLoginSaved(cid)
	if(lastLogin > 0) then
		doPlayerSendTextMessage(cid,MESSAGE_STATUS_CONSOLE_BLUE, text)
	else
		doPlayerSendOutfitWindow(cid)
	end
    
	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end
	
	registerCreatureEvent(cid, "Mail")
	registerCreatureEvent(cid, "GuildMotd")
       	registerCreatureEvent(cid, "KillingInTheNameOf")
		registerCreatureEvent(cid, "CTFDeath")
	registerCreatureEvent(cid, "Idle")
	if(config.useFragHandler) then
		registerCreatureEvent(cid, "SkullCheck")
	end
	if(getPlayerOperatingSystem(cid) >= CLIENTOS_OTCLIENT_LINUX) then
		registerCreatureEvent(cid, "ExtendedOpcode")
	end
	registerCreatureEvent(cid, "inquisitionPortals")
       	registerCreatureEvent(cid, "GuildEvents")
	registerCreatureEvent(cid, "countKill")
	registerCreatureEvent(cid, "SaveReportBug")
        registerCreatureEvent(cid, "VocReward")
	registerCreatureEvent(cid, "ReportBug")
	registerCreatureEvent(cid, "AdvanceSave")
	registerCreatureEvent(cid, "kill")
      	registerCreatureEvent(cid, "reward")
	registerCreatureEvent(cid, "ArenaKill")
	registerCreatureEvent(cid, "killbossesbroadcast")
	registerCreatureEvent(cid, "PythiusDead")
        registerCreatureEvent(cid, "Achievements")
        registerCreatureEvent(cid, "premcheck")
        registerCreatureEvent(cid, "Frags")
	registerCreatureEvent(cid, "demonOakLogout")
	registerCreatureEvent(cid, "demonOakDeath")
	registerCreatureEvent(cid, "demonOakComplete")
	registerCreatureEvent(cid, "PlayerDeath")
        registerCreatureEvent(cid, "Addons")
        registerCreatureEvent(cid, "NecroKillingInTheNameOf")
        registerCreatureEvent(cid, "Obliverator")
        registerCreatureEvent(cid, "fullhpmana")
        registerCreatureEvent(cid, "freebless")
        registerCreatureEvent(cid, "Bounty")
        registerCreatureEvent(cid, "FimVip")
        registerCreatureEvent(cid, "wardeath")
        registerCreatureEvent(cid, "VipReceive")
        registerCreatureEvent(cid, "BlessCheck")
        registerCreatureEvent(cid, "GuildLook")
	
	-- mount
	setPlayerStorageValue(cid, 13184, os.time() + 4)
    setPlayerStorageValue(cid, 65484, -1)
	setPlayerStorageValue(cid, 98478, -1)
	setPlayerStorageValue(cid, 5454, 1)
	setPlayerStorageValue(cid, 9755, 0)
	setPlayerStorageValue(cid, 101010, 5)

    if (InitArenaScript ~= 0) then
    InitArenaScript = 1

        for i = 42300, 42309 do
            setGlobalStorageValue(i, 0)
            setGlobalStorageValue(i+100, 0)
        end
    end

    if getPlayerStorageValue(cid, 42309) < 1 then
        for i = 42300, 42309 do
            setPlayerStorageValue(cid, i, 0)
        end
    end

    if getPlayerStorageValue(cid, 42319) < 1 then
        for i = 42310, 42319 do
            setPlayerStorageValue(cid, i, 0)
        end
    end

    if getPlayerStorageValue(cid, 42329) < 1 then
        for i = 42320, 42329 do
            setPlayerStorageValue(cid, i, 0)
        end
    end
    if getPlayerStorageValue(cid, 42355) == -1 then
        setPlayerStorageValue(cid, 42355, 0)
    end
    setPlayerStorageValue(cid, 42350, 0)
    setPlayerStorageValue(cid, 42352, 0)
return true
end