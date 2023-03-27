         local text = {
        --X pos,Y pos, Z pos, text
          [1] = {pos = {32276,32462,7}, text = {"BomberMan"}},
          [2] = {pos = {32276,32474,7}, text = {"Snowball"}},
          [3] = {pos = {32276,32471,7}, text = {"B.Field"}},
          [4] = {pos = {32276,32468,7}, text = {"CTF"}},
	   [5] = {pos = {32276,32465,7}, text = {"WoE"}},
          [6] = {pos = {32276,32477,7}, text = {"B.Castle"}},
        }

        local effects = {
        --X pos,Y pos, Z pos, text
        [1] = {pos = {32276,32462,7}, effect = {26}},
        [2] = {pos = {32276,32474,7}, effect = {26}},
	 [3] = {pos = {32276,32471,7}, effect = {26}},
        [4] = {pos = {32276,32468,7}, effect = {26}},
        [5] = {pos = {32276,32465,7}, effect = {26}},
        [6] = {pos = {32276,32477,7}, effect = {26}},

		}

function onThink(interval, lastExecution)
        for _, area in pairs(text) do
                doSendAnimatedText({x=area.pos[1],y=area.pos[2],z=area.pos[3]},area.text[1], math.random(01,255))
        end
        for _, area in pairs(effects) do
                doSendMagicEffect({x=area.pos[1],y=area.pos[2],z=area.pos[3]},area.effect[1])
        end
        return TRUE
end 
