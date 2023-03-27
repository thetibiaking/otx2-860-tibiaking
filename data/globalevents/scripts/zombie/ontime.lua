function onTime()
	local statusZombieEvent = getStatusZombieEvent()
	if(statusZombieEvent < 1) then
		local estagio = 1
		local totalParticipantes = ZB_TOTAL_PARTICIPANTES
		iniciarZombieEvent(estagio, totalParticipantes)
		print("["..os.date("%H:%M:%S:000", os.time()).."] > Zombie Event foi iniciado com sucesso.")
	else
		print("["..os.date("%H:%M:%S:000", os.time()).."] > Zombie Event nao foi iniciado pois ja esta ativo.")
	end
	return true
end