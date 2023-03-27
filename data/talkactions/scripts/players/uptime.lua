local storage = 34524
local exausted = 5

function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, storage) >= os.time() then
		doPlayerSendCancel(cid, "Aguarde ".. getPlayerStorageValue(cid, storage) - os.time() .. " segundos para utilizar novamente.")
		return true
	end
	setPlayerStorageValue(cid, storage, os.time()+exausted)
	local tmp = getWorldUpTime()
	local hours = math.ceil(tmp / 3600) - 1
	local minutes = math.ceil((tmp - (3600 * hours)) / 60)
	if(minutes == 60) then
		minutes = 0
		hours = hours + 1
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Uptime: " .. hours .. " hours and " .. minutes .. " minutes.")
	return true
end