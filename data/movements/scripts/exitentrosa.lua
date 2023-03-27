--Key of storage used to control whether or not a player is in the arena
STORAGE_PLAYER_IN_ARENA = 18774
--Key of the storage used to manage different war types
STORAGE_PLAYER_WAR_TYPE = 18775
--Key of the storage used to manage the disabled potions
STORAGE_PLAYER_DISABLED_POTIONS = 18776
--Key of the storage used to manage team of player
STORAGE_PLAYER_TEAM = 18777

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    local queryResult = db.storeQuery("SELECT * FROM `guildwar_arenas` WHERE `guild1` = '"..getPlayerGuildId(cid).."' OR `guild2` = '"..getPlayerGuildId(cid).."' and `inuse`=1;")
    if queryResult then
        if result.getDataInt(queryResult, 'guild1') == getPlayerGuildId(cid) then
            db.query("UPDATE `guildwar_arenas` SET `playersOnTeamA` = `playersOnTeamA`-1 WHERE `guild1` = '"..getPlayerGuildId(cid).."' AND `inuse`='1';")
        else
            db.query("UPDATE `guildwar_arenas` SET `playersOnTeamB` = `playersOnTeamB`-1 WHERE `guild2` = '"..getPlayerGuildId(cid).."' AND `inuse`='1';")
        end
        doPlayerSendTextMessage(cid, 22, "You has been teleported to the temple.")
        setPlayerStorageValue(cid, STORAGE_PLAYER_IN_ARENA, 0)
        setPlayerStorageValue(cid, STORAGE_PLAYER_WAR_TYPE, 0)
        setPlayerStorageValue(cid, STORAGE_PLAYER_DISABLED_POTIONS, 0)
        --doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
    end
    result.free(queryResult)
    return true
end