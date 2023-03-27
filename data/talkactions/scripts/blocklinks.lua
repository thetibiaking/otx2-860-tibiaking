local blockedLinks = {'newtibia.com', 'Newtibia.com', '8.6', 'Mewtibia.com', 'global.com', 'golden-styller.com', 'styller.com', 'styller', 'hostbr', 'wtibia.', 'sewtibia.com', 'mewtibia.com'}

local muteStorage = 16246
local muteTime = 60 -- in seconds
-- END OF CONFIG --

local blockedLinksData = {}
local separator = '[ !\t%$%^%+%-%.%%_,<>]*'
for _, linkText in pairs(blockedLinks) do
    local data = {}
    data.link = linkText

    data.preg = '.*'
    for c in string.gmatch(linkText, '.') do
        if(c == '.') then
            data.preg = data.preg .. '.*'
        else
            data.preg = data.preg .. c .. separator
        end
    end
    data.preg = data.preg .. '.*'

    table.insert(blockedLinksData, data)
end

function isLegalMessage(words)
    for _, blockedLink in pairs(blockedLinksData) do
        if(string.match(words, blockedLink.preg) ~= nil) then
            return false, blockedLink.link
        end
    end
    return true, ''
end

function onSay(cid, words, param, channel)
    words = words .. ' ' .. param
    local legalMessage, forbiddenLink = isLegalMessage(
string.lower(words))

    if(not legalMessage) then
        local muteStorageValue = getPlayerStorageValue(cid, muteStorage)
        if(muteStorageValue > os.time()) then
            doPlayerSendCancel(cid, 'You are still muted for ' .. muteStorageValue-os.time() .. ' seconds.')
            return true
        end
        setPlayerStorageValue(cid, muteStorage, os.time()+muteTime)

        if(channel == CHANNEL_DEFAULT) then
            doCreatureSay(cid, '...', TALKTYPE_SAY)
        end
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, 'Link: ' .. forbiddenLink .. ' is forbidden.')
        return true
    end
    return false
end