function getMembersOnline(GuildId)
local players = {}
for _, pid in pairs(getPlayersOnline()) do
	if getPlayerGuildId(pid) == tonumber(GuildId) then
		table.insert(players, pid)
	end
end
return #players > 0 and #players or 0
end

function getMembersOfGuild(GuildId)
local players,query = {},db.getResult("SELECT `name` FROM `players` WHERE `rank_id` IN (SELECT `id` FROM `guild_ranks` WHERE `guild_id` = " .. GuildId .. ");")
if (query:getID() ~= -1) then
	repeat
		table.insert(players,query:getDataString("name"))
	until not query:next()
	query:free()
end
return #players > 0 and #players or 0
end

function onLook(cid, thing, position, lookDistance)
	if isPlayer(thing.uid) and getPlayerGuildId(thing.uid) > 0 then
		doPlayerSetSpecialDescription(thing.uid, "\nGuild has " .. getMembersOfGuild(getPlayerGuildId(thing.uid)) .. " members, and " .. getMembersOnline(getPlayerGuildId(thing.uid)) .. " of them online.")
	end
	return true
end