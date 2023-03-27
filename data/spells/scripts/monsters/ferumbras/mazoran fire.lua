local posInicioA = {x = 33574, y = 32677, z = 14}
local posFimA = {x = 33597, y = 32699, z = 14}

local posInicioB = {x = 33574, y = 32677, z = 13}
local posFimB = {x = 33597, y = 32699, z = 13}

function teleportPlayersAndBoss(cid)
	for x = posInicioA.x, posFimA.x do
		for y = posInicioA.y, posFimA.y do
   			if isPlayer(getThingFromPos({x = x, y = y, z = posInicioA.z, stackpos = 253}).uid) then
				doTeleportThing(getThingFromPos({x = x, y = y, z = posInicioA.z, stackpos = 253}).uid, {x = x, y = y, z = posInicioA.z - 1})
			end
			if isMonster(getThingFromPos({x = x, y = y, z = posInicioA.z, stackpos = 253}).uid) then
				doTeleportThing(getThingFromPos({x = x, y = y, z = posInicioA.z, stackpos = 253}).uid, {x = x, y = y, z = posInicioA.z - 1})
			end
		end
	end
end

function teleportReturnPlayersAndBoss(cid)
	for x = posInicioB.x, posFimB.x do
		for y = posInicioB.y, posFimB.y do
   			if isPlayer(getThingFromPos({x = x, y = y, z = posInicioB.z, stackpos = 253}).uid) then
				doTeleportThing(getThingFromPos({x = x, y = y, z = posInicioB.z, stackpos = 253}).uid, {x = x, y = y, z = posInicioB.z + 1})
			end
			if isMonster(getThingFromPos({x = x, y = y, z = posInicioB.z, stackpos = 253}).uid) then
				doTeleportThing(getThingFromPos({x = x, y = y, z = posInicioB.z, stackpos = 253}).uid, {x = x, y = y, z = posInicioB.z + 1})
			end
		end
	end
end


function onCastSpell(cid, var)
	teleportPlayersAndBoss(cid)
	addEvent(function()
		teleportReturnPlayersAndBoss(cid)
	end, 8000)
end