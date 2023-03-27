function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, getConfigValue("reportStorage")) == -1 or os.time() >= (getPlayerStorageValue(cid, getConfigValue("reportStorage")) + getConfigValue("reportExhausted")) then
		local pos = getCreaturePosition(cid)
		doPlayerSendTextMessage(cid, 18, "Report have been send.")
		setPlayerStorageValue(cid, getConfigValue("reportStorage"), os.time())
		Log = io.open(getDataDir().."logs/reports.txt", "a+")
		Log:write("Sent: "..os.date("%A %I:%M:%S %p.").."\n")
		Log:write("From position: X = "..pos.x.." | Y = "..pos.y.." | Z = "..pos.z.."\n")
		Log:write(""..getPlayerName(cid).." ["..getPlayerLevel(cid).."]: "..param.."\n\n")
		Log:close()
	else
		local dif = os.time() - getPlayerStorageValue(cid, getConfigValue("reportStorage"))
		local left = getConfigValue("reportExhausted") - dif
		local h, m, s = 0, 0, 0
		while left >= 3600 do
			left = left - 3600
			h = h + 1
		end
		while left >= 60 do
			left = left - 60
			m = m + 1
		end
		while left >= 1 do
			left = left - 1
			s = s+1
		end
		doPlayerSendTextMessage(cid, 18, "You have to wait "..h.." hours, "..m.." minutes and "..s.." seconds before reporting again.")
	end
	return TRUE
end