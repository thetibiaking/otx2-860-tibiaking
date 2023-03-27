local condition = createConditionObject(CONDITION_INVISIBLE)
setConditionParam(condition, CONDITION_PARAM_TICKS, 4000)  

local posInicio = {x = 33634, y = 32749, z = 11}
local posFim = {x = 33653, y = 32764, z = 11}

function invisibleBoss()
	for x = posInicio.x, posFim.x  do
		for y = posInicio.y, posFim.y do
			local pos = {x = x, y = y, z = posInicio.z}
			local m = getTopCreature(pos).uid
			if m ~= 0 and isMonster(m) then
				doAddCondition(m, condition)
			end
		end
	end
end

function onCastSpell(cid, var)
	invisibleBoss()
end
