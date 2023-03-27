local position = {x = 32152, y = 33060, z = 7}
local config = {
	distX= 11, -- distancia em X entre cada sala (de uma mesma linha)
	distY= 10, -- distancia em Y entre cada sala (de uma mesma coluna)
	rX= 20, -- numero de colunas
	rY= 60 -- numero de linhas
}

local storage = 40481 -- storage que salva a ultima vez que o player entrou (pra evitar spams)

function isWalkable(pos, creature, proj, pz)-- by Nord
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


 local function check_disponivel(npos)
	if isWalkable(npos, true, true) then
		return true
	end
return false
end


local function fazQualquerCoisa(cid, pos, i, j) -- isso é o coração do nosso script, nao mexa nisso

	j = j or 0
	p = i or 0
	if p >= config.rX then
		p = 0
		j = j < config.rY -1 and j + 1 or false
	end
	if j then
		posi = {x = pos.x + ( p * config.distX), y = pos.y + (j * config.distY), z = pos.z}
		if check_disponivel(posi) then
			doTeleportThing(cid, posi)
			doSendMagicEffect(posi, 10)
			--countdown(posi, {{x = posi.x - 1, y = posi.y + 1, z = posi.z}, {x = posi.x + 1 , y = posi.y + 1, z = posi.z}})
		else
			fazQualquerCoisa(cid, pos, p + 1, j)
		end
	else
		doPlayerSendCancel(cid, "Couldn't find any position for you right now.")
	end
end

function onStepIn(cid, item, pos, lastPos, fromPos, toPos, actor)
	if getPlayerStorageValue(cid, storage) - os.time() <= 0 then
		fazQualquerCoisa(cid, position)
	else
		doTeleportThing(cid, fromPos)
		doPlayerSendCancel(cid, "You gotta wait a few seconds before you can enter trainning room again")
	end
return true
end 