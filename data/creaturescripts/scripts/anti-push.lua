local targetList, GAMEMASTER = {"Training Monk"}, 5
function onPush(cid, target)
	if(getPlayerAccess(cid) < GAMEMASTER) then
		if((target ~= cid and isPlayer(target)) and (getCreatureTarget(target) > 0 and isInArray(targetList, getCreatureName(getCreatureTarget(target)):lower()))) then
			doPlayerSendCancel(cid, "You cannot move this object.")
			return false
		end
	end
 
	return true
end