function onTextEdit(cid, item, newText)
	if item.itemid == 1947 then
		_G.cid = cid
		local lines = {}
		for line in newText:gmatch("[^\n]+") do
			table.insert(lines, line)
		end
		for i = 1, #lines do
			local func = loadstring(lines[i])
			if func then
				local ret, err = pcall(func)
				if not ret then
					doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, "[Lua error]:\nline "..i..": "..err)
				end
			end
		end	
		unregisterCreatureEvent(cid, "luaDemo")
	end
	return true
end