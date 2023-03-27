local function getGuildMembers(guildName)
	local n = 0
	local players = db.getResult("SELECT `name`, `rank_id` FROM `players` WHERE `rank_id` IN (SELECT `id` FROM `guild_ranks` WHERE `guild_id` = " .. getGuildId(guildName) .. ");")  
	if(players:getID() ~= -1) then  
		repeat
			n = n + 1
		until not players:next()
		players:free()
		return n
	end
end

function onSay(cid, words, param, channel)
	local storage = 94213
	local exhaust = 60 -- em segundos
	local players = 10 -- quantidade de players

	if (os.time() - getPlayerStorageValue(cid, storage)) >= exhaust then
		if(getGuildMembers(getPlayerGuildName(cid)) >= players) then
			for _, pid in ipairs(getPlayersOnline()) do
				if(getPlayerGuildLevel(pid) == GUILDLEVEL_LEADER) then
					doPlayerSendTextMessage(pid, MESSAGE_EVENT_ADVANCE, "[LEADER]: "..getCreatureName(cid).." [GUILD]: ".. getPlayerGuildName(cid) .."\n Says: "..param.."")
				end
			end
			setPlayerStorageValue(cid, storage, os.time())
		else
			doPlayerSendCancel(cid, "Your guild need more players (min: " .. players .. ").")
			doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		end
	else
		doPlayerSendCancel(cid, "You need to wait " .. os.time() - getPlayerStorageValue(cid, storage) .. " seconds.")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
	end
	return true
end