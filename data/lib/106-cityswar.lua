-- Sistema de Guild War Sem Intervencoes
-- Criado por: DU4RT3 
-- 07/04/2015
-- Versão 6.3 16/04/2016
-- Favor nao postar nem compartilhar este codigo
-- Favor manter os comentarios quando foi utilizar o codigo

WarConfigs =
{
	WarCitys = {"carlin", "liberty bay", "thais", "darashia1", "darashia2", "edron", "svargrond", "yalahar"},
	WarMinLevel = 50,
	WarMaxFrontLine = 2,
	WarGuildLeaderMinLevel = 70,
	WarMinPlayers = 1,
	WarMinPlayersInGuild = 1,
	WarNeedDiferentIps = 0,
	WarLimitTime = 2 * 60 * 60,
	WarAcceptTime = 2 * 60,
	WarWaitTimeToCancel = 3 * 60,
	WarFirstGuildPos = {{x = 30512, y = 31347, z = 7}, {x = 30253, y = 31283, z = 7}, {x = 30804, y = 31545, z = 7}, {x = 30232, y = 31555, z = 7}, {x = 30513, y = 31737, z = 7}, {x = 30759, y = 31271, z = 7}, {x = 30788, y = 31117, z = 7}, {x = 30411, y = 31543, z = 7}},
	WarSecondGuildPos = {{x = 30512, y = 31347, z = 7}, {x = 30253, y = 31283, z = 7}, {x = 30804, y = 31545, z = 7}, {x = 30232, y = 31555, z = 7}, {x = 30513, y = 31737, z = 7}, {x = 30759, y = 31271, z = 7}, {x = 30788, y = 31117, z = 7}, {x = 30411, y = 31543, z = 7}},
	-- Global Storages
	["WarArenaStorage"] = {720000, 720001, 720002, 720003, 720004, 720005},
	["WarAcceptTimeArena"] = {720010, 720011, 720012, 720013, 720014, 720015},
	["WarFirstGuildID"] = {720020, 720021, 720022, 720023, 720024, 720025},
	["WarSecondGuildID"] = {720030, 720031, 720032, 720033, 720034, 720035},
	["WarMaxPlayerValue"] = {720040, 720041, 720042, 720043, 720044, 720045},
	["WarFirstTeamPlayerCount"] = {720050, 720051, 720052, 720053, 720054, 720055},
	["WarSecondTeamPlayerCount"] = {720060, 720061, 720062, 720063, 720064, 720065},
	["WarFragsToFinish"] = {720070, 720071, 720072, 720073, 720074, 720075},
	["WarMaxLevel"] = {735094, 735095, 735096, 735097, 735098, 735099},
	["WarUltimateExplosion"] = {720080, 720081, 720082, 720083, 720084, 720085},
	["WarAreaRunes"] = {720090, 720091, 720092, 720093, 720094, 720095},
	["WarFirstTeamPlayerDeathsCount"] = {721000, 721001, 721002, 721003, 721004, 721005},
	["WarSecondTeamPlayerDeathsCount"] = {721010, 721011, 721012, 721013, 721014, 721015},
	["WarMinutesInactive"] = {721020, 721021, 721022, 721023, 721024, 721025},
	["WarTeamInactive"] = {721030, 721031, 721032, 721033, 721034, 721035},
	["WarCanceledCity"] = {721040, 721041, 721042, 721043, 721044, 721045},
	["WarDontSSAMight"] = {725080, 725081, 725082, 725083, 725084, 725085},
	["WarDontSummonCreature"] = {735082, 735083, 735084, 735085, 735086, 735087},
	["WarLimitFrontLine"] = {735040, 735041, 735042, 735043, 7350434, 735045},
	["WarFirstTeamFrontCount"] = {745040, 745041, 745042, 745043, 745044, 745045},
	["WarSecondTeamFrontCount"] = {755040, 755041, 755042, 755043, 755044, 755045},
	-- Players Storages
	WarPlayerJoined = 730000,
	WarUrgentExit = 730002,
	WarUEDisabled = 730003,
	WarAreaRunesDisabled = 730004,
	WarSSAMight = 732015,
	WarSummonCreature = 732016,
	WarFrontLine = 732020
}

function getHavePlayersInGuildByGuildID(GuildID)
	local RanksIDS = {}
	Query1 = db.getResult("SELECT `id` FROM `guild_ranks` WHERE guild_id = '".. GuildID .."'")
	if(Query1:getID() == -1) then
		return 0
	end
	for i = 1, Query1:getRows() do
		table.insert(RanksIDS, Query1:getDataInt("id"))
		Query1:next()
	end
	Query1:free()
	Query2 = db.getResult("SELECT `account_id` FROM `players` WHERE `rank_id` IN (".. table.concat(RanksIDS, ', ') ..") AND `level` >= ".. WarConfigs.WarMinLevel .."")
	if(Query2:getID() == -1) then
		return 0
	end
	local Result = Query2:getRows()
	Query2:free()
	return Result
end

function getGuildNameByID(GuildID)
	Query = db.getResult("SELECT `name` FROM `guilds` WHERE id = '".. GuildID .."'")
	if(Query:getID() == -1) then
		return nil
	end
	local Result = Query:getDataString("name")
	Query:free()
	return Result
end

function seachGuildInStorages(FirstGuildID, SecondGuildID)
	for i = 1, #WarConfigs["WarFirstGuildID"] do
		if getGlobalStorageValue(WarConfigs["WarFirstGuildID"][i]) > 0 then
			if FirstGuildID == getGlobalStorageValue(WarConfigs["WarFirstGuildID"][i]) and SecondGuildID == getGlobalStorageValue(WarConfigs["WarSecondGuildID"][i]) then
				return i
			end
		end
	end
	return false
end

function getCountPlayesHaveInWar(EntryID)
	return {getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerCount"][EntryID]), getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerCount"][EntryID])}
end

function getOnlineGuildMembers(GuildID, RankIDS)
	if not RankIDS then
		RankIDS = {1, 2, 3}
	end
	local GuildMembers = {}
	for _, pid in pairs(getPlayersOnline()) do
		if getPlayerGuildId(pid) == GuildID then
			if isInArray(RankIDS, getPlayerGuildLevel(pid)) then
				table.insert(GuildMembers, pid)
			end
		end
	end
	return GuildMembers
end

function checkWarCitysIps(GuildID)
	local IPS = {}
	for i, pid in ipairs(getOnlineGuildMembers(GuildID)) do
		local PlayerIP = getPlayerIp(pid)
		if #IPS > 0 then
			for k = 1, #IPS do
				if PlayerIP == IPS[k] then
					AddIPList = false
					break
				end
				AddIPList = true
			end
			if AddIPList then
				table.insert(IPS, PlayerIP)
			end
		else
			table.insert(IPS, PlayerIP)
		end
	end
	if WarConfigs.WarNeedDiferentIps > #IPS then
		return false
	else
		return true
	end
end

function resetArenaAllStats(EntryID)
	local Configs = {"WarArenaStorage", "WarAcceptTimeArena", "WarFirstGuildID", "WarSecondGuildID", "WarMaxPlayerValue", "WarFirstTeamPlayerCount", "WarSecondTeamPlayerCount", "WarFragsToFinish", "WarMaxLevel", "WarUltimateExplosion", "WarAreaRunes", "WarFirstTeamPlayerDeathsCount", "WarSecondTeamPlayerDeathsCount", "WarMinutesInactive", "WarTeamInactive", "WarCanceledCity", "WarDontSSAMight", "WarDontSummonCreature", "WarLimitFrontLine", "WarFirstTeamFrontCount", "WarSecondTeamFrontCount"}
	for i = 1, #Configs do
		setGlobalStorageValue(WarConfigs[Configs[i]][EntryID], 0)
	end
end

function resetAllCityWarStats()
	for i = 1, #WarConfigs["WarArenaStorage"] do
		resetArenaAllStats(i)
	end
end

function warBroadcastGuild(GuildID, MSGTYPE, MSG, GuildRankIDs)
	for _, pid in pairs(getOnlineGuildMembers(GuildID, GuildRankIDs)) do
		doPlayerSendTextMessage(pid, MSGTYPE, MSG)
	end
end

function checkActiveWarInGuildAndEntryID(GuildID)
	for i = 1, #WarConfigs["WarArenaStorage"] do
		if getGlobalStorageValue(WarConfigs["WarArenaStorage"][i]) > 0 then
			if getGlobalStorageValue(WarConfigs["WarFirstGuildID"][i]) == GuildID then
				return {i, 1}
			elseif getGlobalStorageValue(WarConfigs["WarSecondGuildID"][i]) == GuildID then
				return {i, 2}
			end
		end
	end
	return false
end

function checkActiveWarInGuild(GuildID)
	for i = 1, #WarConfigs["WarArenaStorage"] do
		if getGlobalStorageValue(WarConfigs["WarArenaStorage"][i]) > 0 then
			if getGlobalStorageValue(WarConfigs["WarFirstGuildID"][i]) == GuildID or getGlobalStorageValue(WarConfigs["WarSecondGuildID"][i]) == GuildID then
				return true
			end
		end
	end
	return false
end

function checkActiveInviteInGuild(GuildID)
	for i = 1, #WarConfigs["WarAcceptTimeArena"] do
		if getGlobalStorageValue(WarConfigs["WarAcceptTimeArena"][i]) > os.time() then
			if getGlobalStorageValue(WarConfigs["WarFirstGuildID"][i]) == GuildID then
				return true
			end
		end
	end
	return false
end

function warSetOptions(EntryID, Param1, Param2, Param3, Param4, Param5, Param6, Param7, Param8, Param9, Param10, Param11, Param12)
	if not ResetStats then
		ResetStats = false
	end
	setGlobalStorageValue(WarConfigs["WarArenaStorage"][EntryID], Param1)
	setGlobalStorageValue(WarConfigs["WarAcceptTimeArena"][EntryID], Param2)
	setGlobalStorageValue(WarConfigs["WarFragsToFinish"][EntryID], Param3)
	if Param4 == "disabled" then
		setGlobalStorageValue(WarConfigs["WarMaxLevel"][EntryID], 1)
	else
		setGlobalStorageValue(WarConfigs["WarMaxLevel"][EntryID], tonumber(Param4))
	end
	if Param5 == "disabled" then
		setGlobalStorageValue(WarConfigs["WarUltimateExplosion"][EntryID], 1)
	end
	if Param6 == "disabled" then
		setGlobalStorageValue(WarConfigs["WarAreaRunes"][EntryID], 1)
	end
	if Param7 == "enabled" then
		setGlobalStorageValue(WarConfigs["WarDontSSAMight"][EntryID], 1)
	end
	if Param8 == "disabled" then
		setGlobalStorageValue(WarConfigs["WarDontSummonCreature"][EntryID], 1)
	end
	if Param9 == "enabled" then
		setGlobalStorageValue(WarConfigs["WarLimitFrontLine"][EntryID], 1)
	end
	setGlobalStorageValue(WarConfigs["WarMaxPlayerValue"][EntryID], Param10)
	setGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID], Param11)
	setGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID], Param12)
end

function checkInvitationsAccepted()
	for i = 1, #WarConfigs["WarArenaStorage"] do
		if getGlobalStorageValue(WarConfigs["WarArenaStorage"][i]) == 0 and getGlobalStorageValue(WarConfigs["WarAcceptTimeArena"][i]) < os.time() then
			resetArenaAllStats(i)
		end
	end
end

function removeStoragesToShutDown()
	for _, pid in pairs(getPlayersOnline()) do
		if getPlayerStorageValue(pid, WarConfigs.WarPlayerJoined) == 1 then
			doPlayerSetStorageValue(pid, WarConfigs.WarPlayerJoined)
			doPlayerSetStorageValue(pid, WarConfigs.WarSSAMight)
			doPlayerSetStorageValue(pid, WarConfigs.WarSummonCreature)
			doPlayerSetStorageValue(pid, WarConfigs.WarAreaRunesDisabled)
			doPlayerSetStorageValue(pid, WarConfigs.WarUrgentExit, 1)
		end
	end
end

function checkToEnterWarArena(TeamID, EntryID)
	if getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerCount"][EntryID]) < getGlobalStorageValue(WarConfigs["WarMaxPlayerValue"][EntryID]) and TeamID == 1 or getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerCount"][EntryID]) < getGlobalStorageValue(WarConfigs["WarMaxPlayerValue"][EntryID]) and TeamID == 2 then
		return true
	else
		return false
	end
end

function checkFrontLine(cid, TeamID, EntryID)
	if getGlobalStorageValue(WarConfigs["WarLimitFrontLine"][EntryID]) < 1 or isInArray({1, 2, 5, 6}, getPlayerVocation(cid)) then
		return true
	else
		if getGlobalStorageValue(WarConfigs["WarFirstTeamFrontCount"][EntryID]) <= WarConfigs.WarMaxFrontLine and TeamID == 1 or getGlobalStorageValue(WarConfigs["WarSecondTeamFrontCount"][EntryID]) <= WarConfigs.WarMaxFrontLine and TeamID == 2 then
			return true
		else
			return false
		end	
	end
end

function doAddPlayersCountInArena(TeamID, EntryID)
	if TeamID == 1 then
		setGlobalStorageValue(WarConfigs["WarFirstTeamPlayerCount"][EntryID], getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerCount"][EntryID]) + 1)
	else
		setGlobalStorageValue(WarConfigs["WarSecondTeamPlayerCount"][EntryID], getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerCount"][EntryID]) + 1)
	end
end

function doRemovePlayersCountInArena(TeamID, EntryID)
	if TeamID == 1 then
		setGlobalStorageValue(WarConfigs["WarFirstTeamPlayerCount"][EntryID], getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerCount"][EntryID]) - 1)
	else
		setGlobalStorageValue(WarConfigs["WarSecondTeamPlayerCount"][EntryID], getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerCount"][EntryID]) - 1)
	end
end

function doAddFrontCountInArena(TeamID, EntryID)
	if TeamID == 1 then
		setGlobalStorageValue(WarConfigs["WarFirstTeamFrontCount"][EntryID], getGlobalStorageValue(WarConfigs["WarFirstTeamFrontCount"][EntryID]) + 1)
	else
		setGlobalStorageValue(WarConfigs["WarSecondTeamFrontCount"][EntryID], getGlobalStorageValue(WarConfigs["WarSecondTeamFrontCount"][EntryID]) + 1)
	end
end

function doRemoveFrontCountInArena(TeamID, EntryID)
	if TeamID == 1 then
		setGlobalStorageValue(WarConfigs["WarFirstTeamFrontCount"][EntryID], getGlobalStorageValue(WarConfigs["WarFirstTeamFrontCount"][EntryID]) - 1)
	else
		setGlobalStorageValue(WarConfigs["WarSecondTeamFrontCount"][EntryID], getGlobalStorageValue(WarConfigs["WarSecondTeamFrontCount"][EntryID]) - 1)
	end
end

function sendWarFinishResults(EntryID)
	if getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) < getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) then
		warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]), MESSAGE_INFO_DESCR, "Your guild has win his team killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." times, and the guild opponent killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." times.")
		warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]), MESSAGE_INFO_DESCR, "Your guild has lost his team killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." times, and the guild opponent killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." times.")
	elseif getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) > getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) then
		warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]), MESSAGE_INFO_DESCR, "Your guild has win his team killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." times, and the guild opponent killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." times.")
		warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]), MESSAGE_INFO_DESCR, "Your guild has lost his team killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." times, and the guild opponent killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." times.")
	else
		warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]), MESSAGE_INFO_DESCR, "No team won this war because there was a tie, his team killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." times, and the guild opponent killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." times.")
		warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]), MESSAGE_INFO_DESCR, "No team won this war because there was a tie, his team killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." times, and the guild opponent killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." times.")
	end
end

function executeFinishWar(EntryID, ForTime)
	if getGlobalStorageValue(WarConfigs["WarArenaStorage"][EntryID]) ~= 0 then
		if not ForTime then
			ForTime = false
		end
		if ForTime then
			if getGlobalStorageValue(WarConfigs["WarArenaStorage"][EntryID]) > os.time() then
				return true
			end
		end
		for _, pid in pairs(getPlayersOnline()) do
			if getPlayerStorageValue(pid, WarConfigs.WarPlayerJoined) == 1 then
				if getPlayerGuildId(pid) == getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]) or getPlayerGuildId(pid) == getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]) then
					doPlayerSetStorageValue(pid, WarConfigs.WarPlayerJoined)
					doPlayerSetStorageValue(pid, WarConfigs.WarUEDisabled)
					doPlayerSetStorageValue(pid, WarConfigs.WarAreaRunesDisabled)
					doPlayerSetStorageValue(pid, WarConfigs.WarSSAMight)
					doPlayerSetStorageValue(pid, WarConfigs.WarSummonCreature)
					doPlayerSetPzLocked(pid, false)
					if getCreatureSkullType(pid) == 3 then
						doCreatureSetSkullType(pid, 0)
					end
					doSendMagicEffect(getCreaturePosition(pid), CONST_ME_POFF)
					doTeleportThing(pid, getTownTemplePosition(getPlayerTown(pid)))
					doSendMagicEffect(getTownTemplePosition(getPlayerTown(pid)), CONST_ME_TELEPORT)
				end
			end
		end
		sendWarFinishResults(EntryID)
		resetArenaAllStats(EntryID)
	end
end

function doInitWar(EntryID)
	setGlobalStorageValue(WarConfigs["WarArenaStorage"][EntryID], WarConfigs.WarLimitTime + os.time())
	warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]), MESSAGE_INFO_DESCR, "Your guild is at war with the guild ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID])) ..", To participate in this war type /citywar go")
	warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]), MESSAGE_INFO_DESCR, "Your guild is at war with the guild ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID])) ..", To participate in this war type /citywar go")
	addEvent(executeFinishWar, WarConfigs.WarLimitTime * 1000, EntryID, true)
end

function checkActiveWars()
	for i = 1, #WarConfigs["WarArenaStorage"] do
		if getGlobalStorageValue(WarConfigs["WarArenaStorage"][i]) ~= 0 then
			ArenaOnline = getCountPlayesHaveInWar(i)
			if getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) == 0 then
				if ArenaOnline[1] == 0 and ArenaOnline[2] == 0 then
					setGlobalStorageValue(WarConfigs["WarTeamInactive"][i], 3)
					setGlobalStorageValue(WarConfigs["WarMinutesInactive"][i], getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) + 1)
				elseif ArenaOnline[1] == 0 and ArenaOnline[2] > 0 then
					setGlobalStorageValue(WarConfigs["WarTeamInactive"][i], 1)
					setGlobalStorageValue(WarConfigs["WarMinutesInactive"][i], getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) + 1)
				elseif ArenaOnline[1] > 0 and ArenaOnline[2] == 0 then
					setGlobalStorageValue(WarConfigs["WarTeamInactive"][i], 2)
					setGlobalStorageValue(WarConfigs["WarMinutesInactive"][i], getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) + 1)
				end
			elseif getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) == 5 and getGlobalStorageValue(WarConfigs["WarTeamInactive"][i]) == 3 then
				executeFinishWar(i)
			elseif getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) > 0 and getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) < 10 then
				setGlobalStorageValue(WarConfigs["WarMinutesInactive"][i], getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) + 1)
			elseif getGlobalStorageValue(WarConfigs["WarMinutesInactive"][i]) == 10 then
				executeFinishWar(i)
			end
		end
	end
end

function deathInWarAntientrosa(cid)
	if getPlayerStorageValue(cid, WarConfigs.WarPlayerJoined) == 1 then
		doPlayerSetStorageValue(cid, WarConfigs.WarPlayerJoined)
		doPlayerSetStorageValue(cid, WarConfigs.WarUEDisabled)
		doPlayerSetStorageValue(cid, WarConfigs.WarAreaRunesDisabled)
		doPlayerSetStorageValue(cid, WarConfigs.WarSSAMight)
		doPlayerSetStorageValue(cid, WarConfigs.WarSummonCreature)
		GetGuildAndEntryID = checkActiveWarInGuildAndEntryID(getPlayerGuildId(cid))
		EntryID = GetGuildAndEntryID[1]
		GuildTeam = GetGuildAndEntryID[2]
		doRemovePlayersCountInArena(GuildTeam, EntryID)
		if getGlobalStorageValue(WarConfigs["WarLimitFrontLine"][EntryID]) == 1 and isInArray({3, 4, 7, 8}, getPlayerVocation(cid)) then
			doRemoveFrontCountInArena(GuildTeam, EntryID)
		end
		if GuildTeam == 1 then
			setGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID], getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) + 1)
			warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]), MESSAGE_STATUS_CONSOLE_BLUE, "Another participant of his guild was killed, current results ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." players, ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." player.")
			warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]), MESSAGE_STATUS_CONSOLE_BLUE, "Another guild opponent participant was killed, current results ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." players, ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." players.")
		else
			setGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID], getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) + 1)
			warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]), MESSAGE_STATUS_CONSOLE_BLUE, "Another guild opponent participant was killed, current results ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." players, ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." players.")
			warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]), MESSAGE_STATUS_CONSOLE_BLUE, "Another participant of his guild was killed, current results ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) .." players, ".. getGuildNameByID(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID])) .." killed ".. getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) .." players.")
		end
		if getGlobalStorageValue(WarConfigs["WarFirstTeamPlayerDeathsCount"][EntryID]) == getGlobalStorageValue(WarConfigs["WarFragsToFinish"][EntryID]) or getGlobalStorageValue(WarConfigs["WarSecondTeamPlayerDeathsCount"][EntryID]) == getGlobalStorageValue(WarConfigs["WarFragsToFinish"][EntryID]) then
			executeFinishWar(EntryID)
		end
	end
end

function doPlayerWarUrgentExit(cid)
	doPlayerSetStorageValue(cid, WarConfigs.WarPlayerJoined)
	doPlayerSetStorageValue(cid, WarConfigs.WarUrgentExit)
	doPlayerSetStorageValue(cid, WarConfigs.WarUEDisabled)
	doPlayerSetStorageValue(cid, WarConfigs.WarAreaRunesDisabled)
	doPlayerSetStorageValue(cid, WarConfigs.WarSSAMight)
	doPlayerSetStorageValue(cid, WarConfigs.WarSummonCreature)
	doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
	doSendMagicEffect(getTownTemplePosition(getPlayerTown(cid)), CONST_ME_TELEPORT)
end

function doPlayerExitArena(cid)
	if getPlayerStorageValue(cid, WarConfigs.WarPlayerJoined) == 1 then
		doPlayerSetStorageValue(cid, WarConfigs.WarPlayerJoined)
		doPlayerSetStorageValue(cid, WarConfigs.WarUEDisabled)
		doPlayerSetStorageValue(cid, WarConfigs.WarAreaRunesDisabled)
		doPlayerSetStorageValue(cid, WarConfigs.WarSSAMight)
		doPlayerSetStorageValue(cid, WarConfigs.WarSummonCreature)
		GetGuildAndEntryID = checkActiveWarInGuildAndEntryID(getPlayerGuildId(cid))
		if not GetGuildAndEntryID then
			doPlayerWarUrgentExit(cid)
		end
		EntryID = GetGuildAndEntryID[1]
		GuildTeam = GetGuildAndEntryID[2]
		doRemovePlayersCountInArena(GuildTeam, EntryID)
		if getGlobalStorageValue(WarConfigs["WarLimitFrontLine"][EntryID]) == 1 and isInArray({3, 4, 7, 8}, getPlayerVocation(cid)) then
			doRemoveFrontCountInArena(GuildTeam, EntryID)
		end
		doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
		doSendMagicEffect(getTownTemplePosition(getPlayerTown(cid)), CONST_ME_TELEPORT)
	else
		doPlayerWarUrgentExit(cid)
	end
end

function doTeleportToArena(cid, TeamID, EntryID)
	local frontLineVocations = {3, 4, 7, 8}
	if getGlobalStorageValue(WarConfigs["WarUltimateExplosion"][EntryID]) == 1 then
		doPlayerSetStorageValue(cid, WarConfigs.WarUEDisabled, 1)
	end
	if getGlobalStorageValue(WarConfigs["WarAreaRunes"][EntryID]) == 1 then
		doPlayerSetStorageValue(cid, WarConfigs.WarAreaRunesDisabled, 1)
	end
	if getGlobalStorageValue(WarConfigs["WarDontSSAMight"][EntryID]) == 1 then
		doPlayerSetStorageValue(cid, WarConfigs.WarSSAMight, 1)
	end
	if getGlobalStorageValue(WarConfigs["WarDontSummonCreature"][EntryID]) == 1 then
		doPlayerSetStorageValue(cid, WarConfigs.WarSummonCreature, 1)
	end
	if getGlobalStorageValue(WarConfigs["WarLimitFrontLine"][EntryID]) == 1 and isInArray(frontLineVocations, getPlayerVocation(cid)) then
		doAddFrontCountInArena(TeamID, EntryID)
	end
	doPlayerSetStorageValue(cid, WarConfigs.WarPlayerJoined, 1)
	doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
	doAddPlayersCountInArena(TeamID, EntryID)
	if getGlobalStorageValue(WarConfigs["WarTeamInactive"][EntryID]) == 3 then
		setGlobalStorageValue(WarConfigs["WarMinutesInactive"][EntryID], 0)
		setGlobalStorageValue(WarConfigs["WarTeamInactive"][EntryID], 0)
	end
	if TeamID == 1 then
		if getGlobalStorageValue(WarConfigs["WarTeamInactive"][EntryID]) == 1 then
			setGlobalStorageValue(WarConfigs["WarMinutesInactive"][EntryID], 0)
			setGlobalStorageValue(WarConfigs["WarTeamInactive"][EntryID], 0)
		end
		doTeleportThing(cid, WarConfigs.WarFirstGuildPos[EntryID])
		doSendMagicEffect(WarConfigs.WarFirstGuildPos[EntryID], CONST_ME_TELEPORT)
	else
		if getGlobalStorageValue(WarConfigs["WarTeamInactive"][EntryID]) == 2 then
			setGlobalStorageValue(WarConfigs["WarMinutesInactive"][EntryID], 0)
			setGlobalStorageValue(WarConfigs["WarTeamInactive"][EntryID], 0)
		end
		doTeleportThing(cid, WarConfigs.WarSecondGuildPos[EntryID])
		doSendMagicEffect(WarConfigs.WarSecondGuildPos[EntryID], CONST_ME_TELEPORT)
	end
	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You are participating in the war, good luck.")
end

function executeEnterArena(cid, TeamID, EntryID)
	if not checkToEnterWarArena(TeamID, EntryID) then
		doPlayerSendCancel(cid, "Your team is full at the time try again later.")
	elseif not checkFrontLine(cid, TeamID, EntryID) then
		doPlayerSendCancel(cid, "Your team is full of Front Line, try again later.")
	else
		doTeleportToArena(cid, TeamID, EntryID)
	end
end

function executeCancelWarCity(PlayerName, EntryID, First, Minutes)
	if not Minutes then
		Minutes = WarConfigs.WarWaitTimeToCancel / 60
	end
	if First then
		setGlobalStorageValue(WarConfigs["WarCanceledCity"][EntryID], 1)
	end
	if getGlobalStorageValue(WarConfigs["WarArenaStorage"][EntryID]) ~= 0 and getGlobalStorageValue(WarConfigs["WarCanceledCity"][EntryID]) == 1 then
		if Minutes > 0 then
			warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarFirstGuildID"][EntryID]), MESSAGE_STATUS_WARNING, "This war was canceled by ".. PlayerName ..", and will end in ".. Minutes .." minutes")
			warBroadcastGuild(getGlobalStorageValue(WarConfigs["WarSecondGuildID"][EntryID]), MESSAGE_STATUS_WARNING, "This war was canceled by ".. PlayerName ..", and will end in ".. Minutes .." minutes")
			addEvent(executeCancelWarCity, 60 * 1000, PlayerName, EntryID, false, Minutes - 1)
		else
			executeFinishWar(EntryID)
		end
	end
end