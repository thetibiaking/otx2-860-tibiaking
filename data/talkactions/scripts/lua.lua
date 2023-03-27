function onSay(cid, words, param)
	registerCreatureEvent(cid, "luaDemo")
	doShowTextDialog(cid, 1947, true)
	return true
end