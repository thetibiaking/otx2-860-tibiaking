function onSay(cid, words, param)
	local t = string.explode(param, ",")
	if(not t[1]) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid param specified.")
		return true
	end
	if(not t[2]) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Global Storage: "..param..", Value: "..getGlobalStorageValue(t[1]))
		return true
	else
		setGlobalStorageValue(t[1], t[2])
	end
	return true
end