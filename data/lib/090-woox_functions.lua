-- 1º by ???
function getTimeString(self)
    local format = {
        {'dia', self / 60 / 60 / 24},
        {'hora', self / 60 / 60 % 24},
        {'minuto', self / 60 % 60},
        {'segundo', self % 60}
    }
    
    local out = {}
    for k, t in ipairs(format) do
        local v = math.floor(t[2])
        if(v > 0) then
            table.insert(out, (k < #format and (#out > 0 and ', ' or '') or ' e ') .. v .. ' ' .. t[1] .. (v ~= 1 and 's' or ''))
        end
    end
    local ret = table.concat(out)
    if ret:len() < 16 and ret:find('segundo') then
        local a, b = ret:find(' e ')
        ret = ret:sub(b+1)
    end
    return ret
end

-- 2º by WooX
function isPlayerOnline(name)
	local queryResult = db.storeQuery("SELECT `online` FROM `players` WHERE `name` = '"..name.."'")
	local result = result.getDataInt(queryResult, "online") > 0 and true or false
	return result
end

-- 3º by WooX
function getOfflinePlayerStorage(guid, storage)
	if not isPlayerOnline(getPlayerNameByGUID(guid)) then
		local queryResult = db.storeQuery("SELECT `value` FROM `player_storage` WHERE `key` = '"..storage.."' and `player_id` = "..guid.."")
		local result = queryResult and result.getDataInt(queryResult, "value") or -1
		return result
	end
end

-- 4º by WooX
function setOfflinePlayerStorage(guid, storage, value)
	if not isPlayerOnline(getPlayerNameByGUID(guid)) then
		db.query("UPDATE `player_storage` SET `value` = '"..value.."' WHERE `key` = '"..storage.."' and `player_id` = "..guid.."")
	end
end

-- 5º by WooX
function getItemNameByCount(itemID, count)
	if tonumber(count) and count > 1 and isItemStackable(itemID) then
		return getItemInfo(itemID).plural
	end
	return getItemNameById(itemID)
end

-- 6º by Reason
function printTable(_table)
	local function getTable(_table, expand, tabs)
		
		local aux = ""
		if not type(_table) == "table" then
			return _table
		else
			for key,value in pairs(_table) do
				if type(value) == "table" then
				
					for i = 1, tabs -1 do
						aux = aux.."\t"
					end
					
					if type(key)  == "string" then
						aux = aux.. '["'..key..'"] =\t{ \n'..getTable(value, true, tabs +1)
					else
						aux = aux.. "["..key.."] =\t{ \n"..getTable(value, true, tabs +1)
					end
					
					for i = 1, tabs do
						aux = aux.. "\t"
					end
					
					aux = aux.."},\n"				
				else
					if expand then
						for i = 1, tabs -1 do
							aux = aux.. "\t"
						end
					end
					if type(key)  == "string" then
						aux = aux.. '["'..key..'"] = '..(type(value) == "string" and '"'..value..'"' or tostring(value))..",\n"
					else
						aux = aux.. '['..key..'] = '..(type(value) == "string" and '"'..value..'"' or tostring(value))..",\n"
					end
				end
			end
		end

		return aux
	end
    if type(_table) == "table" then
        print(getTable(_table, false, 1))
        return true
    else
        error("Parameter is not a table!")
        return false
    end
end

-- 7º by WooX
function isWalkable(pos, checkCreatures, checkStairs, checkPZ, checkFields)
	if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
	if checkCreatures and getTopCreature(pos).uid > 0 then return false end
	if checkPZ and getTilePzInfo(pos) then return false end
	for i = 0, 255 do
		pos.stackpos = i
		local tile = getTileThingByPos(pos)
		if tile.itemid ~= 0 and not isCreature(tile.uid) then
			if hasProperty(tile.uid, CONST_PROP_BLOCKPROJECTILE) or hasProperty(tile.uid, CONST_PROP_IMMOVABLEBLOCKSOLID) or (hasProperty(tile.uid, CONST_PROP_BLOCKPATHFIND) and not((not checkFields and getTileItemByType(pos, ITEM_TYPE_MAGICFIELD).itemid > 0) or hasProperty(tile.uid, CONST_PROP_HASHEIGHT) or hasProperty(tile.uid, CONST_PROP_FLOORCHANGEDOWN) or hasProperty(tile.uid, CONST_PROP_FLOORCHANGEUP))) then
				return false
			elseif checkStairs then
				if hasProperty(tile.uid, CONST_PROP_FLOORCHANGEDOWN) or hasProperty(tile.uid, CONST_PROP_FLOORCHANGEUP) then
					return false
				end
			end
		else
			break
		end
	end
	return true
end