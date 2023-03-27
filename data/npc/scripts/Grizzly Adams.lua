local TaskNames = {
	"trolls", 
	"goblins", 
	"rotworms", 
	"cyclops", 
	"crocodiles", 
	"tarantulas", 
	"carniphilas", 
	"stone golems", 
	"mammoths", 
	"ice golems", 
	"quaras scout", 
	"quaras", 
	"water elementals", 
	"earth elementals", 
	"energy elementals", 
	"fire elementals", 
	"mutated rats", 
	"giant spiders", 
	"hydras", 
	"sea serpents", 
	"behemoths", 
	"serpents spawn", 
	"green djinns", 
	"blue djinns", 
	"pirates", 
	"dragons", 
	"minotaurs", 
	"necromancers", 
	"demons",
	"medusas", 
	"grim reapers", 
	"nightmares", 
	"lizards"
}

local Tasks =
{
	[1] = {questStarted = 1510, questEnded = 75300, questStorage = 65000, killsRequired = 100, raceName = "Trolls", rewards = {[1] = {enable = true, type = "exp", values = 20000}, [2] = {enable = true, type = "money", values = 20000}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[2] = {questStarted = 1511, questEnded = 75301, questStorage = 65001, killsRequired = 150, raceName = "Goblins", rewards = {[1] = {enable = true, type = "exp", values = 25000}, [2] = {enable = true, type = "money", values = 25000}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[3] = {questStarted = 1512, questEnded = 75302, questStorage = 65002, killsRequired = 300, raceName = "Rotworms", rewards = {[1] = {enable = true, type = "exp", values = 30000}, [2] = {enable = true, type = "money", values = 30000}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[4] = {questStarted = 1513, questEnded = 75303, questStorage = 65003, killsRequired = 500, raceName = "Cyclops", rewards = {[1] = {enable = true, type = "exp", values = 40000}, [2] = {enable = true, type = "money", values = 40000}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[5] = {questStarted = 1514, questEnded = 75304, questStorage = 65004, killsRequired = 300, raceName = "Crocodiles", rewards = {[1] = {enable = true, type = "exp", values = 35000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[6] = {questStarted = 1515, questEnded = 75305, questStorage = 65005, killsRequired = 300, raceName = "Tarantulas", rewards = {[1] = {enable = true, type = "exp", values = 35000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[7] = {questStarted = 1516, questEnded = 75306, questStorage = 65006, killsRequired = 400, raceName = "Carniphilas", rewards = {[1] = {enable = true, type = "exp", values = 45000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[8] = {questStarted = 1517, questEnded = 75307, questStorage = 65007, killsRequired = 200, raceName = "Stone Golems", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[9] = {questStarted = 1518, questEnded = 75308, questStorage = 65008, killsRequired = 300, raceName = "Mammoths", rewards = {[1] = {enable = true, type = "exp", values = 40000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[10] = {questStarted = 1519, questEnded = 75309, questStorage = 65009, killsRequired = 300, raceName = "Ice Golems", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[11] = {questStarted = 1520, questEnded = 75310, questStorage = 65010, killsRequired = 300, raceName = "Quaras Scout", rewards = {[1] = {enable = true, type = "exp", values = 100000}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[12] = {questStarted = 1521, questEnded = 75311, questStorage = 65011, killsRequired = 70, raceName = "Quaras", rewards = {[1] = {enable = true, type = "exp", values = 45000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[13] = {questStarted = 1522, questEnded = 75312, questStorage = 65012, killsRequired = 70, raceName = "Water Elementals", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[14] = {questStarted = 1523, questEnded = 75313, questStorage = 65013, killsRequired = 70, raceName = "Earth Elementals", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[15] = {questStarted = 1524, questEnded = 75314, questStorage = 65014, killsRequired = 70, raceName = "Energy Elementals", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[16] = {questStarted = 1525, questEnded = 75315, questStorage = 65015, killsRequired = 70, raceName = "Fire Elementals", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[17] = {questStarted = 1526, questEnded = 75316, questStorage = 65016, killsRequired = 200, raceName = "Mutated Rats", rewards = {[1] = {enable = true, type = "exp", values = 35000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[18] = {questStarted = 1527, questEnded = 75317, questStorage = 65017, killsRequired = 500, raceName = "Giant Spiders", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[19] = {questStarted = 1528, questEnded = 75318, questStorage = 65018, killsRequired = 10000, raceName = "Hydras", rewards = {[1] = {enable = true, type = "item", values = {12755, 1}}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[20] = {questStarted = 1529, questEnded = 75319, questStorage = 65019, killsRequired = 2000, raceName = "Sea Serpents", rewards = {[1] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[21] = {questStarted = 1530, questEnded = 75320, questStorage = 65020, killsRequired = 2000, raceName = "Behemoths", rewards = {[1] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[22] = {questStarted = 1531, questEnded = 75321, questStorage = 65021, killsRequired = 7000, raceName = "Serpents Spawn", rewards = {[1] = {enable = true, type = "item", values = {12754, 1}}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[23] = {questStarted = 1532, questEnded = 75322, questStorage = 65022, killsRequired = 500, raceName = "Green Djinns", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = true, type = "money", values = 150000}, [3] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}}},
	[24] = {questStarted = 1533, questEnded = 75323, questStorage = 65023, killsRequired = 500, raceName = "Blue Djinns", rewards = {[1] = {enable = true, type = "exp", values = 50000}, [2] = {enable = true, type = "money", values = 150000}, [3] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}}},
	[25] = {questStarted = 1534, questEnded = 75324, questStorage = 65024, killsRequired = 10000, raceName = "Pirates", rewards = {[1] = {enable = true, type = "exp", values = 100000}, [2] = {enable = true, type = "money", values = 150000}, [3] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}, true}}},
	[26] = {questStarted = 1535, questEnded = 75325, questStorage = 65025, killsRequired = 9000, raceName = "Dragons", rewards = {[1] = {enable = true, type = "item", values = {10020, 1}}, [2] = {enable = false, type = nil, values = {nil, nil}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[27] = {questStarted = 1536, questEnded = 75326, questStorage = 65026, killsRequired = 10000, raceName = "Minotaurs", rewards = {[1] = {enable = true, type = "exp", values = 90000}, [2] = {enable = true, type = "money", values = 90000}, [3] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}}}},
	[28] = {questStarted = 1537, questEnded = 75327, questStorage = 65027, killsRequired = 9000, raceName = "Necromancers", rewards = {[1] = {enable = true, type = "exp", values = 200000}, [2] = {enable = true, type = "money", values = 200000}, [3] = {enable = true, type = "boss", values = {x = 32513, y = 32422, z = 7}}}},
	[29] = {questStarted = 1538, questEnded = 75328, questStorage = 65028, killsRequired = 6666, raceName = "Demons", rewards = {[1] = {enable = true, type = "exp", values = 700000}, [2] = {enable = true, type = "item", values = {10305, 1}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[30] = {questStarted = 1539, questEnded = 75329, questStorage = 65029, killsRequired = 10000, raceName = "Medusas", rewards = {[1] = {enable = true, type = "exp", values = 400000}, [2] = {enable = true, type = "money", values = 2000000}, [3] = {enable = true, type = "item", values = {12748, 1}}}},
	[31] = {questStarted = 1540, questEnded = 75330, questStorage = 65030, killsRequired = 15000, raceName = "Grim Reapers", rewards = {[1] = {enable = true, type = "exp", values = 3690000}, [2] = {enable = true, type = "item", values = {12743, 1}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[32] = {questStarted = 1541, questEnded = 75331, questStorage = 65031, killsRequired = 25000, raceName = "Nightmares", rewards = {[1] = {enable = true, type = "exp", values = 2500000}, [2] = {enable = true, type = "item", values = {12746, 1}}, [3] = {enable = false, type = nil, values = {nil, nil}}}},
	[33] = {questStarted = 1542, questEnded = 75332, questStorage = 65032, killsRequired = 10000, raceName = "Lizards", rewards = {[1] = {enable = true, type = "exp", values = 2700000}, [2] = {enable = true, type = "item", values = {12741, 1}}, [3] = {enable = false, type = nil, values = {nil, nil}}}}
}

local QuestLogStorage = 1509

local function receiveRewards(cid, QuestID)
	for i = 1, 3 do
		if(Tasks[QuestID].rewards[i].enable) then
			if(Tasks[QuestID].rewards[i].type == "boss") then
				doTeleportThing(cid, Tasks[QuestID].rewards[i].values)
			elseif(Tasks[QuestID].rewards[i].type == "exp") then
				doPlayerAddExperience(cid, Tasks[QuestID].rewards[i].values)
				doSendAnimatedText(getThingPos(cid), "EXP +"..Tasks[QuestID].rewards[i].values, TEXTCOLOR_WHITE)
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, "You gain EXP +"..Tasks[QuestID].rewards[i].values)
			elseif(Tasks[QuestID].rewards[i].type == "item") then
				doPlayerAddItem(cid, Tasks[QuestID].rewards[i].values[1], Tasks[QuestID].rewards[i].values[2])
			elseif(Tasks[QuestID].rewards[i].type == "money") then
				doPlayerAddMoney(cid, Tasks[QuestID].rewards[i].values)
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_SMALL, "You gain golds + $"..Tasks[QuestID].rewards[i].values)
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You gain golds + $"..Tasks[QuestID].rewards[i].values)
			elseif(Tasks[QuestID].rewards[i].type == "storage") then
				doPlayerSetStorageValue(cid, Tasks[QuestID].rewards[i].values[1], Tasks[QuestID].rewards[i].values[2])
			end
            doPlayerSave(cid)
		end
	end
end

local function tasksStartedCount(cid)
	local Count = 0
	for i = 1, #Tasks do
		if getPlayerStorageValue(cid, Tasks[i].questStarted) > 0 then
			Count = Count + 1
		end
	end
	return Count
end

local function taskEndedCount(cid)
	local Count = 0
	for i = 1, #Tasks do
		if getPlayerStorageValue(cid, Tasks[i].questEnded) > 0 then
			Count = Count + 1
		end
	end
	return Count
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
local ReportID = {}
local NewTaskID = {}
local CancelTaskID = {}

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end

function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end

function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end

function onThink()
	npcHandler:onThink()
end

function greetCallback(cid)
	if getPlayerStorageValue(cid, QuestLogStorage) ~= 1 and (tasksStartedCount(cid) > 0 or taskEndedCount(cid) > 0)then
		doPlayerSetStorageValue(cid, QuestLogStorage, 1)
	end
	talkState[cid] = 0
	NewTaskID[cid] = nil
	ReportID[cid] = nil
	CancelTaskID[cid] = nil
	return true
end

function creatureSayCallback(cid, type, msg)
	if (not npcHandler:isFocused(cid)) then
		return false
	end
	if msgcontains(msg, 'task') and msg ~= "task names" then
		if taskEndedCount(cid) == #Tasks then
			npcHandler:say("You already finished all tasks.", cid, 350)
		elseif tasksStartedCount(cid) < 5 then
			npcHandler:say("Would you like to do some tasks?, So you just need to tell me what tasks you want to do if you do not know what tasks just say {task names}.", cid, 350)
			talkState[cid] = 1
		else
			npcHandler:say("You already have five active tasks finish any of them or {cancel} one of them", cid, 350)
		end
	elseif msgcontains(msg, 'boss room') then
		npcHandler:say("You wanna go bosses room?", cid, 350)
		talkState[cid] = 3
	elseif msgcontains(msg, 'report') then
		if taskEndedCount(cid) == #Tasks then
			npcHandler:say("You already finished all tasks, don\'t need report to me more.", cid, 350)
		elseif tasksStartedCount(cid) > 0 then
			npcHandler:say("Do you want to report which task?", cid, 350)
			talkState[cid] = 4
		else
			npcHandler:say("You are not active on any task if you want to do some say {task}.", cid, 350)
		end
	elseif msgcontains(msg, 'status') then
		npcHandler:say("Check in your questlog, your task status.", cid, 350)
	elseif msgcontains(msg, 'cancel') then
		if taskEndedCount(cid) == #Tasks then
			npcHandler:say("You already finished all tasks, you are a crazy? what you wanna cancel?.", cid, 350)
		elseif tasksStartedCount(cid) > 0 then
			npcHandler:say("Do you want to cancel that task?", cid, 350)
			talkState[cid] = 6
		else
			npcHandler:say("You are not active on any task if you want to do some say {task}.", cid, 350)
		end
	elseif msgcontains(msg, 'help') then
		npcHandler:say('to start a task say {task}, to cancel task say {cancel}, to know the status of your task is to say {status} and to report their task say {report}.', cid, 350)
		talkState[cid] = 0
	elseif talkState[cid] == 1 then
		if msgcontains(msg, 'task names') then
			npcHandler:say(table.concat(TaskNames, ', '), cid, 350)
		elseif isInArray(TaskNames, msg) then
			local GetTaskNumber = table.find(TaskNames, string.lower(msg))
			if getPlayerStorageValue(cid, Tasks[GetTaskNumber].questEnded) > 0 then
				npcHandler:say('Sorry you are already completed this task, make another choice!, need help in task names? say {task names}.', cid, 350)
			elseif getPlayerStorageValue(cid, Tasks[GetTaskNumber].questStarted) > 0 then
				npcHandler:say('Sorry you are already take this task, make another choice!, need help in task names? say {task names}.', cid, 350)
			else
				npcHandler:say('You really want to do the task of '.. Tasks[GetTaskNumber].raceName ..', {yes} or {no}.', cid, 350)
				NewTaskID[cid] = GetTaskNumber
				talkState[cid] = 2
			end
		else
			npcHandler:say("If you do not know which tasks are say {task names}.", cid, 350)
		end
	elseif talkState[cid] == 2 then
		if msgcontains(msg, 'yes') then
			doPlayerSetStorageValue(cid, Tasks[NewTaskID[cid]].questStarted, 1)
			doPlayerSetStorageValue(cid, Tasks[NewTaskID[cid]].questEnded, 0)
			doPlayerSetStorageValue(cid, Tasks[NewTaskID[cid]].questStorage, 0)
                        doPlayerSave(cid)
			npcHandler:say("Right now you can start on your adventure, come back when you finish your task to report me, good luck.", cid, 350)
			talkState[cid] = 0
		elseif msgcontains(msg, 'no') then
			npcHandler:say("All right when you decide to do some task so talk to me, you wanna make a {task}", cid, 350)
			talkState[cid] = 0
		else
			npcHandler:say('You really want to do the task of '.. Tasks[NewTaskID[cid]].raceName ..', {yes} or {no}.', cid, 350)
		end
	elseif talkState[cid] == 3 then
		if msgcontains(msg, 'yes') then
			if getTilePzInfo(getThingPos(cid)) then
				doSendMagicEffect(getThingPosition(cid), CONST_ME_POFF)
				doTeleportThing(cid, {x = 32513, y = 32422, z = 7})
				doSendMagicEffect({x = 32513, y = 32422, z = 7}, CONST_ME_TELEPORT)
			else
				npcHandler:say("First go to protection zone.", cid, 350)
				talkState[cid] = 0
			end
		elseif msgcontains(msg, 'no') then
			npcHandler:say("Okay, something else?", cid, 350)
			talkState[cid] = 0
		end
	elseif talkState[cid] == 4 then
		if msgcontains(msg, 'task names') then
			npcHandler:say(table.concat(TaskNames, ', '), cid, 350)
		elseif isInArray(TaskNames, msg) then
			local GetTaskNumber = table.find(TaskNames, string.lower(msg))
			if getPlayerStorageValue(cid, Tasks[GetTaskNumber].questStarted) > 0 then
				npcHandler:say("You already completed ".. Tasks[GetTaskNumber].raceName .." task?", cid, 350)
				ReportID[cid] = GetTaskNumber
				talkState[cid] = 5
			else
				npcHandler:say("Sorry you not started ".. Tasks[GetTaskNumber].raceName .." task, to report for me.", cid, 350)
				talkState[cid] = 0
			end
		else
			npcHandler:say("If you do not know which tasks are say {task names}.", cid, 350)
		end
	elseif talkState[cid] == 5 then
		if msgcontains(msg, 'yes') then
			if getPlayerStorageValue(cid, Tasks[ReportID[cid]].questStorage) >= Tasks[ReportID[cid]].killsRequired then
				doPlayerSetStorageValue(cid, Tasks[ReportID[cid]].questStarted)
				doPlayerSetStorageValue(cid, Tasks[ReportID[cid]].questEnded, 1)
				doPlayerSetStorageValue(cid, Tasks[ReportID[cid]].questStorage)
                                doPlayerSave(cid)
				receiveRewards(cid, ReportID[cid])
				--if taskEndedCount(cid) == #Tasks then
				--	doPlayerSetStorageValue(cid, QuestLogStorage, 2)
				--end
				npcHandler:say("Right now take your prize.", cid, 350)
				talkState[cid] = 0
			else
				npcHandler:say("Sorry you not completed your task, you current killed " .. getPlayerStorageValue(cid, Tasks[ReportID[cid]].questStorage) .. " " .. Tasks[ReportID[cid]].raceName .. ", you need to kill " .. Tasks[ReportID[cid]].killsRequired .. ".", cid, 350)
				talkState[cid] = 0
			end
		elseif msgcontains(msg, 'no') then
			npcHandler:say("Okay, something else?", cid, 350)
		end
	elseif talkState[cid] == 6 then
		if msgcontains(msg, 'task names') then
			npcHandler:say(table.concat(TaskNames, ', '), cid, 350)
		elseif isInArray(TaskNames, msg) then
			local GetTaskNumber = table.find(TaskNames, string.lower(msg))
			if getPlayerStorageValue(cid, Tasks[GetTaskNumber].questStarted) > 0 then
				npcHandler:say("You really want cancel task ".. Tasks[GetTaskNumber].raceName ..", {yes} or {no}.", cid, 350)
				CancelTaskID[cid] = GetTaskNumber
				talkState[cid] = 7
			else
				npcHandler:say("Sorry you not started ".. Tasks[GetTaskNumber].raceName .." task, to cancel this task.", cid, 350)
				talkState[cid] = 0
			end
		else
			npcHandler:say("If you do not know which tasks are say {task names}.", cid, 350)
		end
	elseif talkState[cid] == 7 then
		if msgcontains(msg, 'yes') then
			doPlayerSetStorageValue(cid, Tasks[CancelTaskID[cid]].questStarted)
			doPlayerSetStorageValue(cid, Tasks[CancelTaskID[cid]].questStorage)
			npcHandler:say("".. Tasks[CancelTaskID[cid]].raceName .." Task canceled want to do any more {task}?", cid, 350)
			talkState[cid] = 0
		elseif msgcontains(msg, 'no') then
			npcHandler:say("Okay, something else?", cid, 350)
			talkState[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())