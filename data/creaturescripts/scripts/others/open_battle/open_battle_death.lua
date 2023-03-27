function onDeath(cid, corpse, killer)
    if getPlayerStorageValue(cid, openBattle.storages.inArena) > 0 then
        setPlayerStorageValue(cid, openBattle.storages.inArena, 0)
    end
    return true
end