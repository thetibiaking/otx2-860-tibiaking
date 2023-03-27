local freeBlessMaxLevel = 100
 
function onLogin(cid)
	if(getPlayerLevel(cid) <= freeBlessMaxLevel and not getPlayerBlessing(cid,1)) then
		for b=1, 5 do
			doPlayerAddBlessing(cid, b)
		end
		doCreatureSay(cid, 'You got free bless, because your level lower than 100', TALKTYPE_ORANGE_1)
		doSendMagicEffect(getThingPosition(cid), CONST_ME_HOLYDAMAGE)
		elseif(getPlayerBlessing(cid,1)) then
	doCreatureSay(cid, 'You are bleesed!', TALKTYPE_ORANGE_1)
	else
	doCreatureSay(cid, 'You are not bleesed. type !bless', TALKTYPE_ORANGE_1)
	end
	return true
end