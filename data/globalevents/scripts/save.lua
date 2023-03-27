function onThink(interval, lastExecution)
	addEvent(doSaveServer, 60000)
	return true
end