-- Sistema de Guild War Sem Intervencoes
-- Criado por: Luke Skywalker
-- 07/04/2015
-- VersÃ£o 6.3 16/04/2016
-- Favor nao postar nem compartilhar este codigo
-- Favor manter os comentarios quando foi utilizar o codigo

local function getTopLevel()
    local Query = db.getResult("SELECT `level` FROM `players` WHERE `group_id` < 2 ORDER BY `level` DESC LIMIT 1")
	if (Query:getID() ~= -1) then
		return Query:getDataInt("level")
	end
	Query:free()
end
local config = {
	storage = 42931,
	exausted = 10
}
function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, config.storage) >= os.time() then
		doPlayerSendCancel(cid, "Aguarde ".. getPlayerStorageValue(cid, config.storage) - os.time() .. " segundos para utilizar novamente.")
		return true
	end
	setPlayerStorageValue(cid, config.storage, os.time()+config.exausted)
	local CommandParam = string.explode(param, ",")
	if getPlayerGuildId(cid) == 0 then
		doPlayerSendCancel(cid, "You need to join any guild to use this feature.")
	elseif getPlayerLevel(cid) < WarConfigs.WarMinLevel then
		doPlayerSendCancel(cid, "You don\'t have level to participate this event.")
	elseif not CommandParam[1] and CommandParam[1] ~= "" then
		doPlayerSendCancel(cid, "Insert the first parameters invite, accept, cancel or go.")
	else
		if string.lower(CommandParam[1]) == "invite" then
			if CommandParam[2] then
				GetStorageCaseID = table.find(WarConfigs.WarCitys, string.lower(CommandParam[2]))
			end
			if getPlayerGuildLevel(cid) < 3 then
				doPlayerSendCancel(cid, "Only guild leaders can use this command.")
			elseif getPlayerLevel(cid) < WarConfigs.WarGuildLeaderMinLevel then
				doPlayerSendCancel(cid, "Only guild leaders level ".. WarConfigs.WarGuildLeaderMinLevel .." or more can use this command.")
			elseif not CommandParam[2] or CommandParam[2] == "" then
				doPlayerSendCancel(cid, "Insert the second parameters, select city.")
			elseif not isInArray(WarConfigs.WarCitys, CommandParam[2]) then
				doPlayerSendCancel(cid, "Select a valid city.")
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cities available to war ".. table.concat(WarConfigs.WarCitys, ', ') ..".")
			elseif not CommandParam[3] or CommandParam[3] == "" or not tonumber(CommandParam[3]) then
				doPlayerSendCancel(cid, "Insert the third parameter, select amount frags to finish war, insert only numbers.")
			elseif not CommandParam[4] or CommandParam[4] == "" or (not tonumber(CommandParam[4]) and string.lower(CommandParam[4]) ~= "disabled") then
				doPlayerSendCancel(cid, "Insert the fourth parameter, select max level to enter war, number between ".. WarConfigs.WarMinLevel .."-".. getTopLevel() .." disabled.")
			elseif not CommandParam[5] or CommandParam[5] == "" or string.lower(CommandParam[5]) ~= "enabled" and string.lower(CommandParam[5]) ~= "disabled" then
				doPlayerSendCancel(cid, "Insert the fifth parameter, select if ultimate explosion, enabled or disabled.")
			elseif not CommandParam[6] or CommandParam[6] == "" or string.lower(CommandParam[6]) ~= "enabled" and string.lower(CommandParam[6]) ~= "disabled" then
				doPlayerSendCancel(cid, "Insert the sixth parameter, select if area runes, enabled or disabled.")
			elseif not CommandParam[7] or CommandParam[7] == "" or string.lower(CommandParam[7]) ~= "enabled" and string.lower(CommandParam[7]) ~= "disabled" then
				doPlayerSendCancel(cid, "Insert the seventh parameter, select whether the amulet block stone skin and stealth ring, enabled or disabled.")
			elseif not CommandParam[8] or CommandParam[8] == "" or string.lower(CommandParam[8]) ~= "enabled" and string.lower(CommandParam[8]) ~= "disabled" then
				doPlayerSendCancel(cid, "Insert the eight parameter, select whether the block summon creatures, enabled or disabled.")
			elseif not CommandParam[9] or CommandParam[9] == "" or string.lower(CommandParam[9]) ~= "enabled" and string.lower(CommandParam[8]) ~= "disabled" then
				doPlayerSendCancel(cid, "Insert the ninth parameter, whether or not to limit the number of front lines in the war.")		
			elseif not CommandParam[10] or CommandParam[10] == "" or not tonumber(CommandParam[10]) then
				doPlayerSendCancel(cid, "Insert the tenth parameter, select limit of players for each guild, insert only numbers.")
			elseif tonumber(CommandParam[10]) < WarConfigs.WarMinPlayers then
				doPlayerSendCancel(cid, "Minimum players for each guild is ".. WarConfigs.WarMinPlayers ..".")
			elseif not CommandParam[11] or CommandParam[11] == "" then
				doPlayerSendCancel(cid, "Insert the eleventh parameter, select guild name you want war.")
			elseif not getGuildId(CommandParam[11]) then
				doPlayerSendCancel(cid, "This guild does not exist.")
			elseif getGuildId(CommandParam[11]) == getPlayerGuildId(cid) then
				doPlayerSendCancel(cid, "You can not call your own guild to war.")
			elseif getHavePlayersInGuildByGuildID(getPlayerGuildId(cid)) < WarConfigs.WarMinPlayersInGuild then
				doPlayerSendCancel(cid, "To invite any guild your guild must have the minimum of ".. WarConfigs.WarMinPlayersInGuild .." members")
			elseif getHavePlayersInGuildByGuildID(getGuildId(CommandParam[11])) < WarConfigs.WarMinPlayersInGuild then
				doPlayerSendCancel(cid, "The guild is inviting you to a war does not have the minimum of ".. WarConfigs.WarMinPlayersInGuild .." members to start a war.")
			elseif not checkWarCitysIps(getPlayerGuildId(cid)) then
				doPlayerSendCancel(cid, "Your guild does not meet the requirements of ".. WarConfigs.WarNeedDiferentIps .." different ips.")
			elseif not checkWarCitysIps(getPlayerGuildId(cid)) then
				doPlayerSendCancel(cid, "The guild that you invited him to war does not comply with the requirements of ".. WarConfigs.WarNeedDiferentIps .." different ips to start a war")
			elseif checkActiveWarInGuild(getPlayerGuildId(cid)) then
				doPlayerSendCancel(cid, "Your guild is already in war.")
			elseif checkActiveWarInGuild(getGuildId(CommandParam[11])) then
				doPlayerSendCancel(cid, "The guild ".. CommandParam[11] .." already in war.")
			elseif checkActiveInviteInGuild(getPlayerGuildId(cid)) then
				doPlayerSendCancel(cid, "Your guild already has an invitation in active, wait finish invitation.")
			elseif checkActiveInviteInGuild(getGuildId(CommandParam[11])) then
				doPlayerSendCancel(cid, "The guild ".. CommandParam[11] .." already have an invite active, wait for the end call.")
			elseif getGlobalStorageValue(WarConfigs["WarAcceptTimeArena"][GetStorageCaseID]) > os.time() then
				doPlayerSendCancel(cid, "There is a call in progress is to arena, wait for the call to end if the invitation is accepted wait until the end of the war.")
			elseif getGlobalStorageValue(WarConfigs["WarArenaStorage"][GetStorageCaseID]) > 0 then
				doPlayerSendCancel(cid, "Arena is already in use, wait war finish.")
			elseif #getOnlineGuildMembers(getGuildId(CommandParam[11]), {3}) == 0 then
				doPlayerSendCancel(cid, "None of the leaders of the invited guild is online.")
			else
				if tonumber(CommandParam[4]) then
					if tonumber(CommandParam[4]) > getTopLevel() or tonumber(CommandParam[4]) < WarConfigs.WarMinLevel then
						doPlayerSendCancel(cid, "Insert the fourth parameter, select max level to enter war, number between ".. WarConfigs.WarMinLevel .."-".. getTopLevel() .." disabled.")
						return true
					end
				end
				warSetOptions(GetStorageCaseID, 0, os.time() + WarConfigs.WarAcceptTime, CommandParam[3], CommandParam[4], CommandParam[5], CommandParam[6], CommandParam[7], CommandParam[8], CommandParam[9], CommandParam[10],getPlayerGuildId(cid), getGuildId(CommandParam[11]))
				warBroadcastGuild(getPlayerGuildId(cid), MESSAGE_EVENT_ADVANCE, "Your guild leader invited the guild, ".. CommandParam[11] .." for a war in ".. CommandParam[2] .."!", {3})
				warBroadcastGuild(getGuildId(CommandParam[11]), MESSAGE_EVENT_ADVANCE, "".. getCreatureName(cid) .." the ".. getPlayerGuildName(cid) .." guild invited your guild for a war in ".. CommandParam[2] ..", to accept type /citywar accept, ".. getPlayerGuildName(cid) .."", {3})
				warBroadcastGuild(getGuildId(CommandParam[11]), MESSAGE_STATUS_CONSOLE_BLUE, "War Options: City ".. CommandParam[2] ..", frags to finish war ".. CommandParam[3] ..", min level to enter war ".. CommandParam[4] ..", ultimate explosion ".. CommandParam[5] ..", area runes ".. CommandParam[6] ..", stone skin amulet and stealth ring block ".. CommandParam[7] ..", summon creatures block ".. CommandParam[8] ..", ".. CommandParam[9] ..", ".. CommandParam[10] .." Players each per guild.", {3})
			end
		elseif string.lower(CommandParam[1]) == "accept" then
			if CommandParam[2] then
				getStorageEntry = seachGuildInStorages(getGuildId(CommandParam[2]), getPlayerGuildId(cid))
			end
			if getPlayerGuildLevel(cid) < 3 then
				doPlayerSendCancel(cid, "Only guild leaders can use this command.")
			elseif not CommandParam[2] or CommandParam[2] == "" then
				doPlayerSendCancel(cid, "Insert the second parameter, select guild invited you.")
			elseif not getGuildId(CommandParam[2]) then
				doPlayerSendCancel(cid, "This guild does not exist.")
			elseif getGuildId(CommandParam[2]) == getPlayerGuildId(cid) then
				doPlayerSendCancel(cid, "It is not possible to accept a war call of your own guild.")
			elseif getGlobalStorageValue(WarConfigs["WarSecondGuildID"][getStorageEntry]) ~= getPlayerGuildId(cid) then
				doPlayerSendCancel(cid, "There is no invitation ".. CommandParam[2] .." to fight with your guild.")
			elseif getGlobalStorageValue(WarConfigs["WarAcceptTimeArena"][getStorageEntry]) < os.time() then
				doPlayerSendCancel(cid, "The time to accept war invitation it expired.")
			else
				doInitWar(getStorageEntry)
			end
		elseif string.lower(CommandParam[1]) == "cancel" then
			local GetGuildAndEntryID = checkActiveWarInGuildAndEntryID(getPlayerGuildId(cid))
			if getPlayerGuildLevel(cid) < 3 then
				doPlayerSendCancel(cid, "Only guild leaders can use this command.")
			elseif not GetGuildAndEntryID then
				doPlayerSendCancel(cid, "Your guild is not in war to execute this command.")
			elseif getPlayerStorageValue(cid, WarConfigs.WarPlayerJoined) ~= 1 then
				doPlayerSendCancel(cid, "Only active leaders in war can perform a cancellation.")
			elseif getGlobalStorageValue(WarConfigs["WarArenaStorage"][GetGuildAndEntryID[1]]) < WarConfigs.WarWaitTimeToCancel + os.time() then
				doPlayerSendCancel(cid, "The cancellation of time is greater than the time remaining to end the war, wait for the end of the war.")
			elseif getGlobalStorageValue(WarConfigs["WarCanceledCity"][GetGuildAndEntryID[1]]) == 1 then
				doPlayerSendCancel(cid, "Already there is a cancellation in progress in this war.")
			else
				executeCancelWarCity(getPlayerNameByGUID(getPlayerGUID(cid)), GetGuildAndEntryID[1], true)
			end
		elseif string.lower(CommandParam[1]) == "go" then
			local GetGuildAndEntryID = checkActiveWarInGuildAndEntryID(getPlayerGuildId(cid))
			if not getTilePzInfo(getThingPos(cid)) then
				doPlayerSendCancel(cid, "You must be in a protected area, to go to war zone.")
			elseif not GetGuildAndEntryID then
				doPlayerSendCancel(cid, "Your guild is not in war.")
			elseif getGlobalStorageValue(WarConfigs["WarMaxLevel"][GetGuildAndEntryID[1]]) ~= 1 and getPlayerLevel(cid) > getGlobalStorageValue(WarConfigs["WarMaxLevel"][GetGuildAndEntryID[1]]) then
				doPlayerSendCancel(cid, "The maximum level to enter the war is ".. getGlobalStorageValue(WarConfigs["WarMaxLevel"][GetGuildAndEntryID[1]]) ..".")
			elseif getPlayerStorageValue(cid, WarConfigs.WarPlayerJoined) == 1 then
				doPlayerSendCancel(cid, "You are already fighting in the war.")
			elseif getPlayerSlotItem(cid, CONST_SLOT_RING).itemid == 12751 and getGlobalStorageValue(WarConfigs["WarDontSSAMight"][GetGuildAndEntryID[1]]) == 1 then
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Remove your might ring first.")
			elseif getPlayerSlotItem(cid, CONST_SLOT_NECKLACE).itemid == 12750 and getGlobalStorageValue(WarConfigs["WarDontSSAMight"][GetGuildAndEntryID[1]]) == 1 then
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Remove your stone skin amulet first.")
			else
				executeEnterArena(cid, GetGuildAndEntryID[2], GetGuildAndEntryID[1])
			end
		else
			doPlayerSendCancel(cid, "Insert correct first param invite, accept or go.")
		end
	end
	return true
end