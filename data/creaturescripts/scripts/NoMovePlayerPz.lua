function onPush(cid, target)
	if getPlayerAccess(cid) < 4 then
		if getTileInfo(getThingPos(cid)).protection or getTileInfo(getThingPos(target)).protection then
			doPlayerSendCancel(cid, "You can't move a player on protect zone!")
			return false
		end
	end
	return true
end