-- <movevent type="StepIn" actionid="37666" event="script" value="TrainerTileStamina.lua"/>
-- <movevent type="StepOut" actionid="37666" event="script" value="TrainerTileStamina.lua"/>
local Configs = {
	Tile_AID = 37667, -- Actionid do tile
	Stamina_Time = 60, -- Tempo em segundos
	Stamina_Add = 1 -- Quantidade de stamina a adicionar
}

StaminaEvent = {}

local function AddStaminaInTrainer(cid)
	if not isPlayer(cid) then
		if StaminaEvent[cid] then
			stopEvent(StaminaEvent[cid])
			StaminaEvent[cid] = nil
			return true
		end
	end
	doPlayerSetStamina(cid, getPlayerStamina(cid) + Configs.Stamina_Add)
	StaminaEvent[cid] = addEvent(AddStaminaInTrainer, Configs.Stamina_Time * 1000, cid)
end

function onStepIn(cid, item, position, fromPosition, pos)
	if item.aid == Configs.Tile_AID then
		if isPlayer(cid) then
			StaminaEvent[cid] = addEvent(AddStaminaInTrainer, Configs.Stamina_Time * 1000, cid)
		end
	end
	return true
end

function onStepOut(cid, item, position, fromPosition)
	if isPlayer(cid) then
		if StaminaEvent[cid] then
			stopEvent(StaminaEvent[cid])
			StaminaEvent[cid] = nil
		end
	end
	return true
end