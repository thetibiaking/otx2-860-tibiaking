--<movevent type="StepIn" actionid="1801" event="script" value="zombieEvent_movement.lua"/>

local romeiro = {x = 1032, y = 1067, z = 6}

function onStepIn(cid,item, position, lastPosition, fromPosition, toPosition)
	if not zombieEvent.config.allowMultiClient and zombieEvent.isMultiClient(cid) then
		doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
		doPlayerSendCancel(cid, "É proibida a entrada com MCs neste evento.")
	else
	doTeleportThing(cid, romeiro)
	end
	return true
end