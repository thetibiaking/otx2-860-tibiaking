-----------Sasiros Mistrzunius Pvpos !



function onStepIn(cid, item, pos)
local config = {
bosspos = {
{x=32513,y=32485,z=7}, -- position where yakchal first spawns
},
boss = "leviathan", -- name of the boss
}



local thais = {x=32513, y=32490, z=7}
local thaiss = {x=32513, y=32531, z=7}

    if item.actionid == 16359 and getPlayerStorageValue (cid, 75319) == 1 and getPlayerStorageValue (cid, 17671) == -1 then 
		doTeleportThing(cid,thais)
        doSendMagicEffect(getCreaturePosition(cid),10)
		doCreatureSay(cid, 'You have ten minutes to kill and loot this boss, else you will lose that chance and will be kicked out.', TALKTYPE_ORANGE_1)
		doPlayerSetStorageValue (cid, 17671, 1)
		doSummonCreature(config.boss, config.bosspos[1])
		elseif getPlayerStorageValue (cid, 75319) == -1 then
		doTeleportThing(cid,thaiss)
		doCreatureSay(cid, 'You did not complete the task Quest!', TALKTYPE_ORANGE_1)
		else
		doTeleportThing(cid,thaiss)
		doCreatureSay(cid, 'You already had a chance to kill Leviathan.', TALKTYPE_ORANGE_1)
		end	
    return 1
end 
