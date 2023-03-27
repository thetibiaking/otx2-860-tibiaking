local positions = {
	[1] = {pos = {x = 33052, y = 32066, z = 14}, id = 9533},
	[2] = {pos = {x = 33052, y = 32067, z = 14}, id = 9533},
	[3] = {pos = {x = 33052, y = 32068, z = 14}, id = 9533},
	[4] = {pos = {x = 33052, y = 32069, z = 14}, id = 9533},
	[5] = {pos = {x = 33052, y = 32070, z = 14}, id = 9533}
}

local createpos = {
	[1] = {pos = {x = 33052, y = 32066, z = 14}, id = 3612},
	[2] = {pos = {x = 33052, y = 32067, z = 14}, id = 2224},
	[3] = {pos = {x = 33052, y = 32068, z = 14}, id = 3612},
	[4] = {pos = {x = 33052, y = 32069, z = 14}, id = 2224},
	[5] = {pos = {x = 33052, y = 32070, z = 14}, id = 2224}
}

local tempo = 3600

function onUse(cid, item, frompos, item2, topos)
	if getTileItemById(positions[1].pos, positions[1].id).uid < 100 then
		doPlayerSendCancel(cid, "O portão foi aberto.")
	return true
	end

	doCreatureSay(cid, "Você tem 1 hora para atravessar os portões", 19)
	function criar_paredes()
		for i = 1, #positions do
			if i <= (#positions/2) then
				doCreateItem(positions[i].id, 1, positions[i].pos)
				local obst = getTileItemById(createpos[i].pos, createpos[i].id).uid
				doSendMagicEffect(createpos[i].pos, 2)
				doRemoveItem(obst, 1)			
			elseif i > (#positions/2) then
				local obst = getTileItemById(positions[i].pos, positions[i].toid).uid
				doTransformItem(obst, positions[i].id)
			end
		end
		return true
	end

	for i = 1, #positions do
		local obst = getTileItemById(positions[i].pos, positions[i].id).uid
		if i <= (#positions/2) and obst ~= 0 then
			doRemoveItem(obst, 1)
			doSendMagicEffect(positions[i].pos, 2)
			doCreateItem(createpos[i].id, 1, createpos[i].pos)
		elseif i > (#positions/2) and obst ~=0 then
			doTransformItem(obst, positions[i].toid)
		end
	end
	addEvent(criar_paredes, tempo*1000)
	return true
end