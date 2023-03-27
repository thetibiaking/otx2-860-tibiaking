local posExitTime = {x = 33454, y = 32873, z = 12}
local posInicio = {x = 33446, y = 32833, z = 11}
local posFim = {x = 33473, y = 32855, z = 11}

function teleportPlayers(cid)
	for x = posInicio.x, posFim.x  do
		for y = posInicio.y, posFim.y do
			local remove, clean = true, true
			local pos = {x = x, y = y, z = posInicio.z}
			local m = getTopCreature(pos).uid
			if m ~= 0 and isPlayer(m) then
				doTeleportThing(m, posExitTime)
			end
		end
	end
	return true
end

function onCastSpell(creature, var)
	teleportPlayers(cid)
	return true
end