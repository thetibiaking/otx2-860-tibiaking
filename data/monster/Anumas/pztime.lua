function onSay(cid, words, param, channel)
	if getPlayerPzTime(cid) > 0 and isPlayerPzLocked(cid) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "You still have to wait "..getTimeString(getPlayerPzTime(cid)).." to get rid of fight condition.")
	else
		doPlayerSendCancel(cid, "You are not in fight.")
	end
	return true
end

function getTimeString(self)
    local format = {
        {'dia', self / 60 / 60 / 24},
        {'hora', self / 60 / 60 % 24},
        {'minuto', self / 60 % 60},
        {'segundo', self % 60}
    }
    
    local out = {}
    for k, t in ipairs(format) do
        local v = math.floor(t[2])
        if(v > 0) then
            table.insert(out, (k < #format and (#out > 0 and ', ' or '') or ' e ') .. v .. ' ' .. t[1] .. (v ~= 1 and 's' or ''))
        end
    end
    local ret = table.concat(out)
    if ret:len() < 16 and ret:find('segundo') then
        local a, b = ret:find(' e ')
        ret = ret:sub(b+1)
    end
    return ret
end