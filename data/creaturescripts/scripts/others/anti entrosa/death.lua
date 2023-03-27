-- {SYSTEM STORAGES}
--Key of storage used to control whether or not a player is in the arena
STORAGE_PLAYER_IN_ARENA = 18774
--Key of the storage used to manage different war types
STORAGE_PLAYER_WAR_TYPE = 18775
--Key of the storage used to manage if SSAs and Might Rings are enabled
STORAGE_PLAYER_DISABLE_SSAMIGHT = 18776
--Key of the storage used to manage players teams
STORAGE_PLAYER_TEAM = 18777
--Key of the storage used to manage if Drops (Anti Pushs, Flowers and Boxes) are enabled
STORAGE_PLAYER_DISABLE_DROP  = 18778
--Key of the storage used to manage if Summon Spell are enabled
STORAGE_PLAYER_DISABLE_SUMMONS = 18779

function onDeath(cid, corpse, killer)
    if (getPlayerStorageValue(cid, STORAGE_PLAYER_IN_ARENA) == 1) then
		setPlayerStorageValue(cid, STORAGE_PLAYER_IN_ARENA, 0)
		setPlayerStorageValue(cid, STORAGE_PLAYER_WAR_TYPE, 0)		
		setPlayerStorageValue(cid, STORAGE_PLAYER_TEAM, 0)		
		setPlayerStorageValue(cid, STORAGE_PLAYER_DISABLE_SSAMIGHT, 0)
		setPlayerStorageValue(cid, STORAGE_PLAYER_DISABLE_DROP, 0)
		setPlayerStorageValue(cid, STORAGE_PLAYER_DISABLE_SUMMONS, 0)	
        local playerGuildId = getPlayerGuildId(cid)
        local query = "SELECT * FROM `guildwar_arenas` WHERE (`guild1` = " .. playerGuildId .. " or `guild2` = " ..playerGuildId..") and `inuse`= 1"
        local queryResult = db.storeQuery(query)
		local updateQuery = nil
        if(queryResult ~= false) then
            local guild1 = result.getDataInt(queryResult, "guild1")
            local guild2 = result.getDataInt(queryResult, "guild2")
            local arena_mapname = result.getDataString(queryResult, "name")
			
            if(guild1 == playerGuildId) then
                updateQuery = "UPDATE  `guildwar_arenas` SET `playersOnTeamA` = `playersOnTeamA`-1 WHERE `name` = \"" .. arena_mapname .. "\""
                db.query(updateQuery)
				if(isInArray(FRONTLINE_VOCATIONS, getPlayerVocation(cid))) then
					updateQuery = "UPDATE  `guildwar_arenas` SET `onFrontLineA` = `onFrontLineA`-1 WHERE `name` = \"" .. arena_mapname .. "\""
					db.query(updateQuery)		
				end
            elseif(guild2 == playerGuildId) then
                updateQuery = "UPDATE  `guildwar_arenas` SET `playersOnTeamB` = `playersOnTeamB`-1 WHERE `name` = \"" .. arena_mapname .. "\""
                db.query(updateQuery)
				if(isInArray(FRONTLINE_VOCATIONS, getPlayerVocation(cid))) then
					updateQuery = "UPDATE  `guildwar_arenas` SET `onFrontLineB` = `onFrontLineB`-1 WHERE `name` = \"" .. arena_mapname .. "\""
					db.query(updateQuery)
				end				
            end
        end
        result.free(queryResult)
    end
    return true
end