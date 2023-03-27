local combat = createCombatObject() 
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_NONE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_NONE)

local area = createCombatArea(AREA_CIRCLE3X3)
setCombatArea(combat, area)

function onCastSpell(cid, var)
	if isMonster(cid) then
		local t, spectator = getSpectators({x = 33590, y = 32378, z = 12}, 11, 11)
    	local check = 0
	    if #t ~= nil then
	        for i = 1, #t do
			spectator = t[i]
	            if string.lower(getCreatureName(spectator)) == "flame of omrafir" then
	               check = check + 1
	            end
	        end
	    end
    	if check < 4 then
    		for j = check, 4 do
    			doCreateMonster("Flame Of Omrafir", {x = 33590 + math.random(-2, 2), y = 32378 + math.random(-2, 2), z = 12})
    		end
		end
	end
	return doCombat(cid, combat, var)
end