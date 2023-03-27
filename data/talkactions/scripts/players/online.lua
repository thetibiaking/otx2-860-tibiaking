local config = {
showGamemasters = getBooleanFromString(getConfigValue('displayGamemastersWithOnlineCommand')),
storage = 34524,
exausted = 20
}
function onSay(cid, words, param, channel)
	if getPlayerStorageValue(cid, config.storage) >= os.time() then
		doPlayerSendCancel(cid, "Aguarde ".. getPlayerStorageValue(cid, config.storage) - os.time() .. " segundos para utilizar novamente.")
		return true
	end
	setPlayerStorageValue(cid, config.storage, os.time()+config.exausted)
	
local players = getPlayersOnline()
local strings = {""}
local i, position = 1, 1
local added = FALSE
for _, pid in ipairs(players) do
if(added) then
if(i > (position * 7)) then
strings[position] = strings[position] .. ","
position = position + 1
strings[position] = ""
else
strings[position] = i == 1 and "" or strings[position] .. ", "
end
end
if((config.showGamemasters or getPlayerCustomFlagValue(cid, PLAYERCUSTOMFLAG_GAMEMASTERPRIVILEGES) or not getPlayerCustomFlagValue(pid, PLAYERCUSTOMFLAG_GAMEMASTERPRIVILEGES)) and (not isPlayerGhost(pid) or getPlayerGhostAccess(cid) >= getPlayerGhostAccess(pid))) then
strings[position] = strings[position] .. getCreatureName(pid) .. " [" .. getPlayerLevel(pid) .. "]"
i = i + 1
added = TRUE
else
added = FALSE
end
end
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, (i - 1) .. " player(s) online no servidor")
for i, str in ipairs(strings) do
if(str:sub(str:len()) ~= ",") then
str = str .. "."
end
end
return TRUE
end