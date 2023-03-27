local SHOP_MSG_TYPE = MESSAGE_EVENT_ORANGE
--- ### Outfits List ###
local femaleOutfits = {
["elementalist"]={2701},
["glooth engineer"]={2703},
["champion"]={2704},
["beastmaster"]={2706},
["death herald"]={2708},
["cave explorer"]={2711},
["ranger"]={2712},
["puppeteer"]={2714},
["spirit caller"]={2716},
["seaweaver"]={2718},
["recruiter"]={2720},
["sea dog"]={2722},
["royal pumpkin"]={2724},
["rift warrior"]={2726},
["winter warden"]={2728},
["arena champion"]={2731},
["lupine warden"]={2732},
["grove keeper"]={2735},
["festive"]={2736},
["pharaoh"]={2739},
["trophy hunter"]={2741},
["herbalist"]={2742},
["sun priestess"]={2745},
["makeshift"]={2747},
["siege master"]={2749},
["discoverer"]={2752},
["sinister archer"]={2754},
["pumpkin mummy"]={2756},
["dream warrior"]={2758},
["percht raider"]={2760},
["owl keeper"]={2762},
["guidon bearer"]={2764},
["inquisition"]={2766},
["breezy garb"]={2768},
["orcsoberfest"]={2770},
["poltergeist"]={2772},
["herder"]={2774},
["falconer"]={2776},
["jouster"]={2778},
["moth cape"]={2780},
["rascoohan"]={2782},
["merry garb"]={2784},
["issavi citizen"]={2786},
["forest warden"]={2787},
["royal bounacean"]={2790},
["dragon knight"]={2792},
["chaos acolyte"]={2793},
["evoker"]={2795},
["battle mage"]={2797},
["void master"]={2800},
["veteran paladin"]={2802},
["lion of war"]={2804},
["revenant"]={2806},
["trailblazer"]={2808},
["rune master"]={2810},
["mercenary"]={2811},
["jersey"]={442},
["citizen"]={801},
["hunter"]={802},
["mage"]={803},
["knight"]={804},
["noblewoman"]={805},
["summoner"]={806},
["warrior"]={807},
["barbarian"]={812},
["druid"]={813},
["wizard"]={814},
["oriental"]={815},
["pirate"]={820},
["assassin"]={821},
["beggar"]={822},
["shaman"]={823},
["norsewoman"]={825},
["nightmare"]={827},
["jester"]={828},
["brotherhood"]={831},
["yalaharian"]={833},
["warmaster"]={860},
["wayfarer"]={861},
["demonhunter"]={863},
["afflicted"]={901},
["conjurer"]={902},
["entrepreneur"]={904},
["crystal warlord"]={907},
["deepling"]={908},
["demon"]={911},
["dream warden"]={912},
["insectoid"]={915},
["soil guardian"]={916},
["philosopher"]={919},
["dragon slayer"]={920},
["golden outfit"]={923},
["retro warrior"]={925},
["retro summoner"]={927},
["retro nobleman"]={929},
["retro mage"]={931},
["retro knight"]={933},
["retro hunter"]={935},
["retro citizen"]={936}
}
local maleOutfits = {
["arena champion"]={2730},
["battle mage"]={2798},
["beastmaster"]={2707},
["breezy garb"]={2767},
["cave explorer"]={2710},
["champion"]={2705},
["chaos acolyte"]={2794},
["death herald"]={2709},
["discoverer"]={2751},
["dragon knight"]={2791},
["dream warrior"]={2757},
["elementalist"]={2700},
["evoker"]={2796},
["falconer"]={2775},
["festive"]={2737},
["forest warden"]={2788},
["glooth engineer"]={2702},
["grove keeper"]={2734},
["guidon bearer"]={2763},
["herbalist"]={2743},
["herder"]={2773},
["inquisition"]={2765},
["issavi citizen"]={2785},
["jouster"]={2777},
["lion of war"]={2803},
["lupine warden"]={2733},
["makeshift"]={2746},
["mercenary"]={2750},
["merry garb"]={2783},
["moth cape"]={2779},
["orcsoberfest"]={2769},
["owl keeper"]={2761},
["percht raider"]={2759},
["pharaoh"]={2738},
["poltergeist"]={2771},
["pumpkin mummy"]={2755},
["puppeteer"]={2715},
["ranger"]={2713},
["rascoohan"]={2781},
["recruiter"]={2721},
["revenant"]={2805},
["rift warrior"]={2727},
["royal bounacean"]={2789},
["royal pumpkin"]={2725},
["rune master"]={2809},
["sea dog"]={2723},
["seaweaver"]={2719},
["siege master"]={2748},
["sinister archer"]={2753},
["spirit caller"]={2717},
["sun priest"]={2744},
["trailblazer"]={2807},
["trophy hunter"]={2740},
["veteran paladin"]={2801},
["void master"]={2799},
["winter warden"]={2729},
["afflicted"]={900},
["assassin"]={817},
["barbarian"]={808},
["beggar"]={818},
["brotherhood"]={830},
["citizen"]={794},
["conjurer"]={903},
["crystal warlord"]={906},
["deepling"]={909},
["demon"]={910},
["demonhunter"]={832},
["dragon slayer"]={921},
["dream warden"]={913},
["druid"]={809},
["entrepreneur"]={905},
["golden outfit"]={922},
["hunter"]={795},
["insectoid"]={914},
["jersey"]={443},
["jester"]={829},
["knight"]={797},
["mage"]={796},
["nightmare"]={826},
["nobleman"]={798},
["norseman"]={824},
["oriental"]={811},
["philosopher"]={918},
["pirate"]={816},
["retro citizen"]={937},
["retro hunter"]={934},
["retro knight"]={932},
["retro mage"]={930},
["retro nobleman"]={928},
["retro summoner"]={926},
["retro warrior"]={924},
["shaman"]={819},
["soil guardian"]={917},
["summoner"]={799},
["warmaster"]={859},
["warrior"]={800},
["wayfarer"]={862},
["wizard"]={810},
["yalaharian"]={834}
}

local exhausted = 5 -- Segundos

function onSay(cid, words, param)
	if exhaustion.get(cid, 75770) then
		doPlayerSendCancel(cid, "You can only use this command again after ".. exhaustion.get(cid, 75770) .." seconds.")
		return true
	end
	exhaustion.set(cid, 75770, exhausted)
	
	local result_plr = db.getResult("SELECT * FROM z_ots_comunication WHERE name = '"..getPlayerName(cid).."';")
	if(result_plr:getID() ~= -1) then
		while(true) do
			id = tonumber(result_plr:getDataInt("id"))
			local action = tostring(result_plr:getDataString("action"))
			local delete = tonumber(result_plr:getDataInt("delete_it"))

			if isPlayer(cid) then
				local itemtogive_id = tonumber(result_plr:getDataInt("param1"))
				local itemtogive_count = tonumber(result_plr:getDataInt("param2"))
				local outfit_name = string.lower(tostring(result_plr:getDataString("param3")))
				local mount_name = string.lower(tostring(result_plr:getDataString("param3")))
				local itemvip = tonumber(result_plr:getDataInt("param4"))
				local add_item_type = tostring(result_plr:getDataString("param5"))
				local add_item_name = tostring(result_plr:getDataString("param6"))
				local points = tonumber(result_plr:getDataInt("param7"))
				local received_item = 0
				local full_weight = 0

				if(action == 'give_item') then
					full_weight = getItemWeightById(itemtogive_id, itemtogive_count)
					if(add_item_type == 'itemcontainer') then
						full_weight = getItemWeightById(itemtogive_id, itemtogive_count)
						if isItemRune(itemtogive_id) == TRUE then
							full_weight = full_weight + getItemWeightById(itemtogive_id, 1)
						else
							full_weight = full_weight + getItemWeightById(outfit_name, itemvip)
						end
					end
					if isItemRune(itemtogive_id) == TRUE then
						full_weight = getItemWeightById(itemtogive_id, 1)
					else
						full_weight = getItemWeightById(itemtogive_id, itemtogive_count)
					end

					local free_cap = getPlayerFreeCap(cid)

					local new_item = doCreateItemEx(itemtogive_id, itemtogive_count)
					-- Item serial
					local serial = generateSerial()
					local avoidClone = db.getResult("SELECT * FROM player_items WHERE serial ='"..serial.."';")
					if(avoidClone:getID() ~= -1) then
						local cloneSerial = string.lower(tostring(avoidClone:getDataString("serial")))
						while(serial == cloneSerial) do
							serial = generateSerial()
						end
					end					
                    doItemSetAttribute(new_item, "description", 'Bought by ' .. getCreatureName(cid) .. ' [Serial: ' .. serial .. '].')

					if(add_item_type == 'itemcontainer') then
						doAddContainerItem(new_item, outfit_name,itemvip)
					end

					if full_weight <= free_cap then
						received_item = doPlayerAddItemEx(cid, new_item)
						if received_item == RETURNVALUE_NOERROR then
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, 'You received >> '.. add_item_name ..' <<')
							db.executeQuery("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
						    db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '>> '.. add_item_name ..' << from OTS shop is waiting for you. Please make place for this item in your backpack/hands and try again.')
						end
					else
						doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '>> '.. add_item_name ..' << from OTS shop is waiting for you. It weight is '.. full_weight ..' oz., you have only '.. free_cap ..' oz. free capacity. Put some items in depot and try again.')
					end
				end

				if(action == 'give_outfit') then
					if outfit_name ~= "" and maleOutfits[outfit_name] and femaleOutfits[outfit_name] then
						local add_outfit = getPlayerSex(cid) == 0 and femaleOutfits[outfit_name][1] or maleOutfits[outfit_name][1]
						if not canPlayerWearOutfit(cid, add_outfit, 3) then
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							doSendMagicEffect(getCreaturePosition(cid), CONST_ME_GIFT_WRAPS)
                			doPlayerAddOutfit(cid, add_outfit, 3)
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "You received the outfit " .. add_item_name .. " of our Shop Online.")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "You already have this outfit. Your points were returned, thank you.")
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + " .. points .. " WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
						end
					end
				end

				if(action == 'give_mount') then
					if mount_name ~= "" and mounts[mount_name] then
						local add_mount = mounts[mount_name][1]
						if not canPlayerWearOutfit(cid, add_mount, 3) then
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							doSendMagicEffect(getCreaturePosition(cid), CONST_ME_GIFT_WRAPS)
                			doPlayerAddOutfit(cid, add_mount, 3)
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "You received the mount " .. add_item_name .. " of our Shop Online.")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "You already have this mount. Your points were returned, thank you.")
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + " .. points .. " WHERE `id` = " .. getPlayerAccountId(cid) .. ";")
						end
					end
				end


			end
			if not(result_plr:next()) then
				break
			end
		end
		result_plr:free()
	else
		doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "There's no item for you to collect.")
	end
	return true
end

function generateSerial()
	math.randomseed(os.clock()*100000000000)
	local serial = ""
	for i = 1, 4 do
		serial = serial .. string.char(math.random(97, 122))
	end
	serial = serial.."-"
	for i = 1, 4 do
		serial = serial .. string.char(math.random(48, 57))
	end	
	return serial
end