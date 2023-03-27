function onStepIn(cid, item, position, fromPosition)
local teleport = {x=32974, y=32224, z=7}
doTeleportThing(cid, teleport, TRUE)
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_RED)
end