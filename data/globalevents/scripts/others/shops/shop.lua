				local SHOP_MSG_TYPE = MESSAGE_STATUS_CONSOLE_RED
local SQL_interval = 60

local femaleOutfits = { 
	["citizen"]={801}, 
	["hunter"]={802}, 
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
	["demonhunter"]={863}, 
	["yalaharian"]={833}, 
	["warmaster"]={860}, 
	["wayfarer"]={861}, 
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
	["golden"]={923}, 
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
	["arena champion"]={2730}, 
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
	["falconer"]={2776}, 
	["jouster"]={2778}, 
	["moth cape"]={2780}, 
	["rascoohan"]={2782}, 
	["merry garb"]={2784}, 
	["issavi citizen"]={2786}, 
	["forest warden"]={2787}, 
	["royal bounacean"]={2790}, 
	["dragon knight"]={2791}, 
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
	["retro warrior"]={925}, 
	["retro summoner"]={927}, 
	["retro nobleman"]={929}, 
	["retro mage"]={931}, 
	["retro knight"]={933}, 
	["retro hunter"]={935}, 
	["retro citizen"]={936}
}
local maleOutfits = { 
	["citizen"]={794}, 
	["hunter"]={795}, 
	["mage"]={796}, 
	["knight"]={797}, 
	["nobleman"]={798},
	["summoner"]={799}, 
	["warrior"]={800}, 
	["barbarian"]={808}, 
	["druid"]={809}, 
	["wizard"]={810}, 
	["oriental"]={811}, 
	["pirate"]={816}, 
	["assassin"]={817}, 
	["beggar"]={818}, 
	["shaman"]={819}, 
	["norseman"]={251}, 
	["nightmare"]={268}, 
	["jester"]={273}, 
	["brotherhood"]={278}, 
	["demonhunter"]={832}, 
	["yalaharian"]={826}, 
	["warmaster"]={859}, 
	["wayfarer"]={862}, 
	["afflicted"]={900}, 
	["conjurer"]={903}, 
	["entrepreneur"]={905}, 
	["crystal warlord"]={906}, 
	["deepling"]={909}, 
	["demon"]={910}, 
	["dream warden"]={913}, 
	["insectoid"]={914},	
	["soil guardian"]={917}, 
	["philosopher"]={918}, 
	["dragon slayer"]={921}, 
	["golden"]={922}, 
	["elementalist"]={2700}, 
	["glooth engineer"]={2702}, 
	["champion"]={2705}, 
	["beastmaster"]={2707}, 
	["death herald"]={2709}, 
	["cave explorer"]={2710}, 
	["ranger"]={2713}, 
	["puppeteer"]={2715},  
	["spirit caller"]={2716}, 
	["seaweaver"]={2719}, 
	["recruiter"]={2721}, 
	["sea dog"]={2723}, 
	["royal pumpkin"]={2725}, 
	["rift warrior"]={2727}, 
	["winter warden"]={2729}, 
	["arena champion"]={2731}, 
	["grove keeper"]={2734}, 
	["festive"]={2737}, 
	["pharaoh"]={2738}, 
	["trophy hunter"]={2740}, 
	["herbalist"]={2743}, 
	["sun priestess"]={2744}, 
	["makeshift"]={2746}, 
	["siege master"]={2748},  
	["discoverer"]={2751}, 
	["sinister archer"]={2753}, 
	["pumpkin mummy"]={2755}, 
	["dream warrior"]={2757}, 
	["percht raider"]={2759}, 
	["owl keeper"]={2761}, 
	["guidon bearer"]={2763}, 
	["inquisition"]={2765}, 
	["breezy garb"]={2767}, 
	["orcsoberfest"]={2769}, 
	["poltergeist"]={2771}, 
	["herder"]={2773}, 
	["falconer"]={2775}, 
	["jouster"]={2777},  
	["moth cape"]={2780}, 
	["rascoohan"]={2781}, 
	["merry garb"]={2783}, 
	["issavi citizen"]={2785}, 
	["forest warden"]={2788}, 
	["royal bounacean"]={2789}, 
	["dragon knight"]={2792}, 
	["chaos acolyte"]={2794}, 
	["evoker"]={2796}, 
	["battle mage"]={2798}, 
	["void master"]={2799}, 
	["veteran paladin"]={2801}, 
	["lion of war"]={2803}, 
	["revenant"]={2805}, 
	["trailblazer"]={2807}, 
	["rune master"]={2809}, 
	["mercenary"]={2750}, 
	["retro warrior"]={924}, 
	["retro summoner"]={926}, 
	["retro nobleman"]={928}, 
	["retro mage"]={930}, 
	["retro knight"]={932}, 
	["retro hunter"]={934}, 
	["retro citizen"]={937}
}

local mounts = {
	["carrion worm"] = {id = 1},
	["racing bird"] = {id = 2},
	["war bear"] = {id = 3},	
	["black sheep"] = {id = 4},
	["midnight panther"] = {id = 5},
	["draptor"] = {id = 6},
	["titanica"] = {id = 7},
	["tin lizzard"] = {id = 8},
	["blazebringer"] = {id = 9},
	["rapid boar"] = {id = 10},
	["stampor"] = {id = 11},
	["undead cavebear"] = {id = 12},
	["donkey"] = {id = 13},
	["tiger slug"] = {id = 14},
	["uniwheel"] = {id = 15},
	["crystal wolf"] = {id = 16},
	["war horse"] = {id = 17},
	["kingly deer"] = {id = 18},
	["tamed panda"] = {id = 19},
	["dromedary"] = {id = 20},
	["scorpion king"] = {id = 21},
	["rented horse first"] = {id = 22},
	["armoured horse"] = {id = 23},
	["shadow draptor"] = {id = 24},
	["rented horse second"] = {id = 26},
	["rented horse two"] = {id = 26},	
	["lady bug"] = {id = 27},
	["manta ray"] = {id = 28},
	["ironblight"] = {id = 29},
	["magma crawler"] = {id = 30},
	["dragonling"] = {id = 31},
	["gnarlhound"] = {id = 32},
	["crimson ray"] = {id = 33},
	["steelbeak"] = {id = 34},
	["water buffalo"] = {id = 35},
	["tombstinger"] = {id = 36},
	["platesaurian"] = {id = 37},
	["ursagrodon"] = {id = 38},
	["the hellgrip"] = {id = 39},
	["noble lion"] = {id = 40},
	["desert king"] = {id = 41},
	["shock head"] = {id = 42},
	["walker"] = {id = 43},
	["azudocus"] = {id = 44},
	["carpacosaurus"] = {id = 45},
	["death crawler"] = {id = 46},
	["flamesteed"] = {id = 47},
	["jade lion"] = {id = 48},
	["jade pincer"] = {id = 49},
	["nethersteed"] = {id = 50},
	["tempest"] = {id = 51},
	["winter king"] = {id = 52},
	["doombringer"] = {id = 53},
	["woodland prince"] = {id = 54},
	["hailstorm fury"] = {id = 55},
	["siegebreaker"] = {id = 56},
	["poisonbane"] = {id = 57},
	["blackpelt"] = {id = 58},
	["golden dragonfly"] = {id = 59},
	["steel bee"] = {id = 60},
	["copper fly"] = {id = 61},
	["tundra rambler"] = {id = 62},
	["highland yak"] = {id = 63},
	["glacier vagabond"] = {id = 64},
	["glooth glider"] = {id = 65},
	["shadow hart"] = {id = 66},
	["black stag"] = {id = 67},
	["emperor deer"] = {id = 68},
	["flying divan"] = {id = 69},
	["magic carpet"] = {id = 70},
	["floating kashmir"] = {id = 71},
	["ringtail waccoon"] = {id = 72},
	["night waccoon"] = {id = 73},
	["emerald waccoon"] = {id = 74},
	["flitterkatzen"] = {id = 75},
	["venompaw"] = {id = 76},
	["batcat"] = {id = 77},
	["sea devil"] = {id = 78},
	["coralripper"] = {id = 79},
	["plumfish"] = {id = 80},
	["gorongra"] = {id = 81},
	["noctungra"] = {id = 82},
	["silverneck"] = {id = 83},
	["slagsnare"] = {id = 84},
	["nightstinger"] = {id = 85},
	["razorcreep"] = {id = 86},
	["rift runner"] = {id = 87},
	["nightdweller"] = {id = 88},
	["frostflare"] = {id = 89},
	["cinderhoof"] = {id = 90},
	["mouldpincer"] = {id = 91},
	["bloodcurl"] = {id = 92},
	["leafscuttler"] = {id = 93},
	["sparkion"] = {id = 94},
	["swamp snapper"] = {id = 95},
	["mould shell"] = {id = 96},
	["reed lurker"] = {id = 97},
	["neon sparkid"] = {id = 98},
	["vortexion"] = {id = 99},
	["ivory fang"] = {id = 100},
	["shadow claw"] = {id = 101},
	["snow pelt"] = {id = 102},
	["jackalope"] = {id = 103},
	["wolpertinger"] = {id = 104},
	["dreadhare"] = {id = 105},
	["gold sphinx"] = {id = 106},
	["caped snowman"] = {id = 107},
	["rabbit rickshaw"] = {id = 108},
	["bunny dray"] = {id = 109},
	["cony cart"] = {id = 110},
	["river crocovile"] = {id = 111},
	["swamp crocovile"] = {id = 112},
	["night crocovile"] = {id = 113},
	["gryphon"] = {id = 114},
	["jousting eagle"] = {id = 115},
	["cerberus"] = {id = 116},
	["cold percht"] = {id = 117},
	["ether badger"] = {id = 118},
	["zaoan badger"] = {id = 119},
	["blue barrel"] = {id = 120},
	["red barrel"] = {id = 121},
	["chaos acolyte"] = {id = 122},
	["floating sage"] = {id = 123},
	["floating scholar"] = {id = 124},	
	["floating augur"] = {id = 125},
	["haze"] = {id = 126},
	["antelope"] = {id = 127},
	["snow strider"] = {id = 128},
	["dusk pryer"] = {id = 129},
	["dawn strayer"] = {id = 130},
	["savanna ostrich"] = {id = 131},
	["coral rhea"] = {id = 132},
	["eventide nandu"] = {id = 133},
	["voracious hyaena"] = {id = 134},
	["cunning hyaena"] = {id = 135},
	["scruffy hyaena"] = {id = 136},
	["white lion"] = {id = 137},
	["merry mammoth"] = {id = 138},
	["holiday mammoth"] = {id = 139},
	["void watcher"] = {id = 141},
	["rune watcher"] = {id = 142},
	["rift watcher"] = {id = 143},
	["hyacinth"] = {id = 144},
	["peony"] = {id = 145},
	["dandelion"] = {id = 146},
	["widow queen"] = {id = 147},
	["marsh toad"] = {id = 159},
	["sanguine frog"] = {id = 160},
	["toxic toad"] = {id = 161},
	["ebony tiger"] = {id = 162},
	["feral tiger"] = {id = 163},
	["jungle tiger"] = {id = 164},
	["flying book"] = {id = 165},
	["tawny owl"] = {id = 166},
	["snowy owl"] = {id = 167},
	["boreal owl"] = {id = 168},
	["lacewing moth"] = {id = 169},
	["hibernal moth"] = {id = 170},	
	["festive snowman"] = {id = 171},	
	["muffled snowman"] = {id = 172},	
	["emerald sphinx"] = {id = 173},	
	["shadow sphinx"] = {id = 174},	
	["jungle saurian"] = {id = 175},	
	["ember saurian"] = {id = 176},	
	["lagoon saurian"] = {id = 177},	
	["blazing unicorn"] = {id = 178},	
	["arctic unicorn"] = {id = 179},	
	["prismatic unicorn"] = {id = 180},	
	["cranium spider"] = {id = 181},	
	["cave tarantula"] = {id = 182},	
	["gloom widow"] = {id = 183},	
	["mole"] = {id = 184},	
	["rustwurm"] = {id = 185},	
	["bogwurm"] = {id = 186},	
	["gloomwurm"] = {id = 187},	
	["singeing steed"] = {id = 188},	
	["phantasmal jade"] = {id = 189},	
	["phant"] = {id = 190},	
	["stone rhino"] = {id = 191},	
	["cow"] = {id = 192},	
	["rift runner"] = {id = 193},	
	["docile nightmare"] = {id = 194},	
	["terrafriend"] = {id = 195},	
	["thornfire wolf"] = {id = 196},	
	["land frog"] = {id = 197},
	["bright percht"] = {id = 198},
	["dark percht"] = {id = 199},
	["battle badger"] = {id = 200}	
}

function onThink(interval, lastExecution)
	local result_plr = db.getResult("SELECT * FROM z_ots_comunication")
	if(result_plr:getID() ~= -1) then
		while(true) do
		
			id = tonumber(result_plr:getDataInt("id"))
			local action = tostring(result_plr:getDataString("action"))
			local delete = tonumber(result_plr:getDataInt("delete_it"))
			local cid = getPlayerByName(tostring(result_plr:getDataString("name")))
			
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
					if isItemRune(itemtogive_id) == TRUE then
						full_weight = getItemWeightById(itemtogive_id, 1)
					else
						full_weight = getItemWeightById(itemtogive_id, itemtogive_count)
					end
					
					local free_cap = getPlayerFreeCap(cid)

					local new_item = doCreateItemEx(itemtogive_id, itemtogive_count)
					doItemSetAttribute(new_item, "description",  "Comprador: ".. getPlayerName(cid) .."")
					
					if full_weight <= free_cap then
						received_item = doPlayerAddItemEx(cid, new_item)
						if received_item == RETURNVALUE_NOERROR then
						--doPlayerSave(cid)
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '[Shop Offer] Entrega do Item -> '.. add_item_name ..' <- Feita com Sucesso!\n o Seu Personagem Foi Salvo com sucesso o seu item está seguro contra rollbacks!')
							doPlayerSendTextMessage(cid, MESSAGE_STATUS_WARNING, '[Shop Offer]  Seu item recebeu um serial caso seja duplicado ele será deletado automaticamente!')
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
						    db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '[Shop Offer] Sua Backpack Nao Tem Espaco Para Receber o Item -> '.. add_item_name ..' <- Por Favor Abra Espaco em Sua Backpack, Estaremos Tentando Entregar o Item Em '.. SQL_interval ..' Segundos!.')
						end
					else
						doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, '[Shop Offer] -> '.. add_item_name ..' <- está esperando por voce. Precisa de '.. full_weight ..' de cap livre, voce tem apenas '.. free_cap ..' de cap livre. Coloque alguns itens no depósito e espere '.. SQL_interval ..' segundos!')
					end
				end
				
				if(action == 'give_outfit') then
					if outfit_name ~= "" and maleOutfits[outfit_name] and femaleOutfits[outfit_name] then
						local add_outfit = getPlayerSex(cid) == 0 and femaleOutfits[outfit_name][1] or maleOutfits[outfit_name][1]
						if not canPlayerWearOutfit(cid, add_outfit, 3) then
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
							doSendMagicEffect(getCreaturePosition(cid), CONST_ME_GIFT_WRAPS)
                			doPlayerAddOutfit(cid, add_outfit, 3)
							--doPlayerSave(cid)
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "[Shop Offer] Entrega do outfit -> " .. add_item_name .. " <- Feita com Sucesso, Utilize o comando !save para salvar seu novo outfit!")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "[Shop Offer] Voce ja tem essa outfit -> " .. add_item_name .. " <-, Seus pontos foram devolvidos, obrigado.")
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `z_shop_history_item` SET `trans_state`='haveoutfit', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
							-- db.executeQuery("UPDATE `accounts` SET `premium_points` = `premium_points` + '".. points .."' WHERE `id` = '".. getPlayerAccountId(cid) .."'")
						end
					end
				end
				
				if(action == 'give_mount') then
					if outfit_name ~= "" and mounts[mount_name] then
						if not playerHasMount(cid, mounts[mount_name].id) then
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `z_shop_history_item` SET `trans_state`='realized', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
							doSendMagicEffect(getCreaturePosition(cid), CONST_ME_GIFT_WRAPS)
                			doPlayerAddMount(cid, mounts[mount_name].id)
                            --doPlayerSave(cid)							
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "[Shop Offer] Entrega da mount -> " .. add_item_name .. " <- Feita com Sucesso, Utilize o comando !save para salvar sua nova mount!")
						else
							doPlayerSendTextMessage(cid, SHOP_MSG_TYPE, "[Shop Offer] Voce ja tem essa mount -> " .. add_item_name .. " <-, Seus pontos foram devolvidos, obrigado.")
							db.query("DELETE FROM `z_ots_comunication` WHERE `id` = " .. id .. ";")
							db.query("UPDATE `z_shop_history_item` SET `trans_state`='havemount', `trans_real`=" .. os.time() .. " WHERE id = " .. id .. ";")
							-- db.executeQuery("UPDATE `accounts` SET `premium_points` = `premium_points` + '".. points .."' WHERE `id` = '".. getPlayerAccountId(cid) .."'")
						end
					end
				end
				
			end
			if not(result_plr:next()) then
				break
			end
		end
		result_plr:free()
	end
	
	return true
end