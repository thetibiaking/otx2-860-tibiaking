local config = {
	storage = 67542,
	exausted = 5
}

local cache = {}

function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, config.storage) >= os.time() then
		doPlayerSendCancel(cid, "Aguarde ".. getPlayerStorageValue(cid, config.storage) - os.time() .. " segundos para utilizar novamente.")
		return true
	end
	setPlayerStorageValue(cid, config.storage, os.time()+config.exausted)

	if(not getBooleanFromString(getConfigValue('useFragHandler'))) then
		return false
	end
	

	local time = os.time()
	local times = {today = (time - 86400), week = (time - (7 * 86400))}

	local data = {}
	if not cache[cid] or getPlayerStorageValue(cid, 94310) > 0 then
		cache[cid] = {day = {}, week = {}, month = {}}
		local result = db.getResult("SELECT `pd`.`date`, `pd`.`level`, `p`.`name` FROM `player_killers` pk LEFT JOIN `killers` k ON `pk`.`kill_id` = `k`.`id` LEFT JOIN `player_deaths` pd ON `k`.`death_id` = `pd`.`id` LEFT JOIN `players` p ON `pd`.`player_id` = `p`.`id` WHERE `pk`.`player_id` = " .. getPlayerGUID(cid) .. " AND `k`.`unjustified` = 1 AND `k`.`war` = 0 AND `pd`.`date` >= " .. (time - (30 * 86400)) .. " ORDER BY `pd`.`date` DESC")
		if(result:getID() ~= -1) then
			repeat
				local content = {
					name = result:getDataString("name"),
					level = result:getDataInt("level"),
					date = result:getDataInt("date")
				}
				if(content.date > times.today) then
					table.insert(cache[cid].day, content)
				elseif(content.date > times.week) then
					table.insert(cache[cid].week, content)
				else
					table.insert(cache[cid].month, content)
				end
			until not result:next()
			result:free()
			setPlayerStorageValue(cid, 94310, 0)
		end
	end
	data = cache[cid]

	local size = {
		day = table.maxn(data.day),
		week = table.maxn(data.week),
		month = table.maxn(data.month)
	}

	if(getBooleanFromString(getConfigValue('advancedFragList'))) then
		local result = "Frags gained today: " .. size.day .. "."
		if(size.day > 0) then
			for _, content in ipairs(data.day) do
				result = result .. "\n* " .. os.date("%d %B %Y %X at ", content.date) .. content.name .. " on level " .. content.level
			end

			result = result .. "\n"
		end

		result = result .. "\nFrags gained this week: " .. (size.day + size.week) .. "."
		if(size.week > 0) then
			for _, content in ipairs(data.week) do
				result = result .. "\n* " .. os.date("%d %B %Y %X at ", content.date) .. content.name .. " on level " .. content.level
			end

			result = result .. "\n"
		end

		result = result .. "\nFrags gained this month: " .. (size.day + size.week + size.month) .. "."
		if(size.month > 0) then
			for _, content in ipairs(data.month) do
				result = result .. "\n* " .. os.date("%d %B %Y %X at ", content.date) .. content.name .. " on level " .. content.level
			end

			result = result .. "\n"
		end

		local skullEnd = getPlayerSkullEnd(cid)
		if(skullEnd > 0) then
			result = result .. "\nYour " .. (getCreatureSkullType(cid) == SKULL_RED and "red" or "black") .. " skull will expire at " .. os.date("%d %B %Y %X", skullEnd)
		end

		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You currently have " .. size.day .. " frags today, " .. (size.day + size.week) .. " this week and " .. (size.day + size.week + size.month) .. " this month.")
		if(size.day > 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Last frag at " .. os.date("%d %B %Y %X", data.day[1].date) .. " on level " .. data.day[1].level .. " (" .. data.day[1].name .. ").")
		end

		local skullEnd = getPlayerSkullEnd(cid)
		if(skullEnd > 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your " .. (getCreatureSkullType(cid) == SKULL_RED and "red" or "black") .. " skull will expire at " .. os.date("%d %B %Y %X", skullEnd))
		end
	end
	return true
end
