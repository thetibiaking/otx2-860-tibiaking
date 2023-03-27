function saveJP()
	doSaveServer()
	doBroadcastMessage("Server Saved!")
	return TRUE
end
function onThink(interval, lastExecution)
	doBroadcastMessage("Saving Server, Please Wait!")
	addEvent(saveJP, 60000)
	return TRUE
end