function onStartup()
db.executeQuery("UPDATE `guildwar_arenas` SET `inuse` = 0, `type` = 0, `guild1` = 0, `guild2` = 0, `start` = 0, `end` = 0, `maxplayers` = 0, `duration` = 0, `challenger` = 0, `playersOnTeamA` = 0, `playersOnTeamB` = 0;")
return true
end