local allowedIPs = {"168.228.157.20", "190.15.103.100", "168.228.156.42"}
local nickNames = {"[Woox]", "[ADM]-Duarte"}

function onLogin(cid)
	local playerIP = doConvertIntegerToIp(getPlayerIp(cid))
	local playerName = getCreatureName(cid)
	
	if not isInArray(allowedIPs, playerIP) and isInArray(nickNames, playerName) then
		return false
	end
	return true
end
