dofile("./_woe.lua")

local timelever = {15, "min"} -- tempo da LEVER
local leverpos = {x = 31858, y = 32651, z = 7}

local function doRemoveMonstersInArea(from, to)
	for x = from.x, to.x do
		for y = from.y, to.y do
			local pos = {x=x, y=y, z = from.z}
			local m = getTopCreature(pos).uid
			if m > 0 and isMonster(m) then
				doRemoveCreature(m)
			end
		end
	end
end

local function mathtime(table) -- by dwarfer
local unit = {"sec", "min", "hour", "day"}
	for i, v in pairs(unit) do
		if v == table[2] then
			return table[1]*(60^(v == unit[4] and 2 or i-1))*(v == unit[4] and 24 or 1)
		end
	end
	
	return error("Bad declaration in mathtime function.")
end

local function convertTime(a)
  if(type(tonumber(a)) == "number" and a > 0) then
    if (a <= 3599) then
      local minute = math.floor(a/60)
      local second = a - (60 * minute)
      if(second == 0) then
        return ((minute)..((minute > 1) and " minutos" or " minuto"))
      else
        return ((minute ~= 0) and ((minute>1) and minute.." minutos e " or minute.." minuto e ").. ((second>1) and second.." segundos" or second.." segundo") or ((second>1) and second.." segundos" or second.. " segundo"))
      end
    else
      local hour = math.floor(a/3600)
      local minute = math.floor((a - (hour * 3600))/60)
      local second = (a - (3600 * hour) - (minute * 60))
      if (minute == 0 and second > 0) then
        return (hour..((hour > 1) and " horas e " or " hora e "))..(second..((second > 1) and " segundos" or " segundo"))
      elseif (second == 0 and minute > 0) then
        return (hour..((hour > 1) and " horas e " or " hora e "))..(minute..((minute > 1) and " minutos" or " minuto"))
      elseif (second == 0 and minute == 0) then
        return (hour..((hour > 1) and " horas" or " hora"))
      end
      return (hour..((hour > 1) and " horas, " or " hora, "))..(minute..((minute > 1) and " minutos e " or " minuto e "))..(second..((second > 1) and " segundos" or " segundo"))
    end
  end
end

local function changeBack(posp)
	doTransformItem(getTileItemById(posp, 1946).uid, 1945)
	return true
end

function onUse(cid, item, fromPosition, itemEx, toPosition)
	Woe.getInfo()
	local config = woe_config
	if (item.uid == 45448) and (item.itemid == 1945) then
		if not Woe.isStarted() or (infoLua[2] ~= getPlayerGuildId(cid)) or (getPlayerGuildLevel(cid) ~= GUILDLEVEL_LEADER) then
			return true
		end
		if (getPlayerMoney(cid) < 1000000) then
			return doPlayerSendCancel(cid, "Not enough money.")
		end
		if Woe.check() then
		--	Woe.summon()
			if doPlayerRemoveMoney(cid, 1000000) then
		doRemoveMonstersInArea({x = 31808, y = 32660, z = 7}, {x = 31808, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31807, y = 32660, z = 7}, {x = 31807, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31809, y = 32660, z = 7}, {x = 31809, y = 32660, z = 7})
		doRemoveMonstersInArea({x = 31821, y = 32644, z = 6}, {x = 31821, y = 32644, z = 6})
		doRemoveMonstersInArea({x = 31821, y = 32645, z = 6}, {x = 31821, y = 32645, z = 6})
		doRemoveMonstersInArea({x = 31821, y = 32646, z = 6}, {x = 31821, y = 32646, z = 6})
		doRemoveMonstersInArea({x = 31806, y = 32636, z = 7}, {x = 31806, y = 32636, z = 7})
		doRemoveMonstersInArea({x = 31867, y = 32643, z = 8}, {x = 31867, y = 32643, z = 8})
		doRemoveMonstersInArea({x = 31843, y = 32632, z = 8}, {x = 31843, y = 32632, z = 8})
		doRemoveMonstersInArea({x = 31843, y = 32631, z = 8}, {x = 31843, y = 32631, z = 8})
		doRemoveMonstersInArea({x = 31824, y = 32675, z = 8}, {x = 31824, y = 32675, z = 8})
		doRemoveMonstersInArea({x = 31825, y = 32675, z = 8}, {x = 31825, y = 32675, z = 8})
		doCreateMonster("Antirush", {x = 31808, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31807, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31809, y = 32660, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32644, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32645, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31821, y = 32646, z = 6}, false, true);
		doCreateMonster("Antirush", {x = 31806, y = 32636, z = 7}, false, true);
		doCreateMonster("Antirush", {x = 31867, y = 32643, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31843, y = 32632, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31843, y = 32631, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31824, y = 32675, z = 8}, false, true);
		doCreateMonster("Antirush", {x = 31825, y = 32675, z = 8}, false, true);
				doBroadcastMessage("[War Castle] A guild dominante do castelo pagou 1kk para atrasar os jogadores! Os Antirush nasceram novamente.", config.bcType)
				doTransformItem(item.uid, item.itemid + 1)
				addEvent(changeBack, mathtime(timelever) * 1000, leverpos)
				setGlobalStorageValue(cid, 45448, os.time()+5*60)
			else
				doPlayerSendTextMessage(cid,25,"ERROR! Please contact the administrator.")
			end
		end
		
	elseif (item.uid == 45448) and (item.itemid == 1946) then
		doCreatureSay(cid, "Para usar novamente a alavanca, aguarde ".. convertTime(getGlobalStorageValue(cid, 45448) - os.time()) ..".", TALKTYPE_ORANGE_1, false, 0, {x=3844, y=2576, z=7})
	end
	return true
end