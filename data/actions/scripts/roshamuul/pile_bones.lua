function onUse(cid, item, fromPosition, itemEx, toPosition)
	local minutes = 2
	local rand = math.random(1, 100)
	if item.itemid ~= 11253 then
		return true
	end 	
	if getPlayerStorageValue(cid, 45490) <= 0 then
		doPlayerSendCancel(cid, "Speak with Sandomo to use this item.") return true
	end	
	if rand > 25 then
		doCreateMonster("guzzlemaw", getCreaturePosition(cid))
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You ransack the pile but fail to find any useful parts.")
		doSendMagicEffect(toPosition, CONST_ME_MAGIC_RED)
	else
		setPlayerStorageValue(cid, 45491, getPlayerStorageValue(cid, 45491)+1)
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Amidst the pile of various bones you find a large, hollow part, similar to a pipe.");
		doSendMagicEffect(toPosition, CONST_ME_MAGIC_GREEN)
	end
	doTransformItem(item.uid, 12688)
    addEvent(function() doTransformItem(getThingfromPos(toPosition).uid, 11253)  end, minutes*60000)
	return true
end
