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

local forbidenItems = {2100, 1738, 2104, 2103, 2102, 2595, 2596, 1739, 1740, 1746, 1770, 1724, 1750, 1753, 1752, 1747, 1749, 1748, 1741, 1774, 2160, 2148, 2152, 3976, 2789, 7907, 3910, 3938, 3909,}

function onThrow(cid, item, fromPosition, toPosition)
	if getPlayerStorageValue(cid, STORAGE_PLAYER_DISABLE_DROP) > 0 then
		if isInArray(forbidenItems, item.itemid) then
			if fromPosition.x == 65535 and toPosition.x < 65535 then
				doPlayerSendCancel(cid, "You are not allowed to throw this item on the arena.")
				return false
			end
		end
	end
	return true
end