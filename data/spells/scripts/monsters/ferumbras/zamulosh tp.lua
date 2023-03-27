local posInicio = {x = 33634, y = 32749, z = 11}
local posFim = {x = 33653, y = 32764, z = 11}
local posTp = {x = 33644, y = 32757, z = 11}

function teleportCreatures(cid)
	for x = posInicio.x, posFim.x  do
		for y = posInicio.y, posFim.y do
			local pos = {x = x, y = y, z = posInicio.z}
			local m = getTopCreature(pos).uid
			if m ~= 0 then
				doTeleportThing(m, posTp)
			end
		end
	end
	return true
end

function summonCreatures()
	doCreateMonster("Zamulosh1", {x = 33644, y = 32757, z = 11})
	doCreateMonster("Zamulosh1", {x = 33644, y = 32757, z = 11})
	doCreateMonster("Zamulosh1", {x = 33644, y = 32757, z = 11})
	doCreateMonster("Zamulosh1", {x = 33644, y = 32757, z = 11})
end

function onCastSpell(cid, var)
	teleportCreatures(cid)
	summonCreatures()
	return
end