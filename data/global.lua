dofile('data/lib/lib.lua')

function isWalkable(pos, creature, proj, pz)
    if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
    if getTopCreature(pos).uid > 0 and creature then return false end
    if getTileInfo(pos).protection and pz then return false, true end
    local n = not proj and 2 or 2
    for i = 0, 255 do
        pos.stackpos = i
        local tile = getTileThingByPos(pos)
        if tile.itemid ~= 0 and not isCreature(tile.uid) then
            if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
                return false
            end
        end
    end
    return true
end

function getRespawnDivider()
    local multiplier = 1
    local size = #getPlayersOnline()
    if size >= 100 and size < 199 then
        multiplier = 2
    elseif size >= 200 and size < 299 then
        multiplier = 3
    elseif size >= 300 then
        multiplier = 4
    end
    return multiplier
end

function removeMoneyNpc(cid, amount)
	if type(amount) == 'string' then
		amount = tonumber(amount)
	end

	local moneyCount = getPlayerMoney(cid)
	local bankCount = getPlayerBalance(cid)
	if amount > moneyCount + bankCount then
		return false
	end

	doPlayerRemoveMoneySrc(cid, math.min(amount, moneyCount))
	if amount > moneyCount then
		doPlayerSetBalance(cid, bankCount - math.max(amount - moneyCount, 0))
		if moneyCount == 0 then
			doPlayerSendTextMessage(cid, 25, string.format("Paid %d gold from bank account. Your account balance is now %d gold.", amount, getPlayerBalance(cid)))
		else
			doPlayerSendTextMessage(cid, 25, string.format("Paid %d from inventory and %d gold from bank account. Your account balance is now %d gold.", moneyCount, amount - moneyCount, getPlayerBalance(cid)))
		end
	end

	return true
end

function doPlayerRemoveMoney(cid, amount)
	return removeMoneyNpc(cid, amount)
end 

function setItemOwner(cid, item)
    doItemSetAttribute(item, 'owner', getPlayerGUID(cid))
    doItemSetAttribute(item, 'ownername', getPlayerName(cid))
end