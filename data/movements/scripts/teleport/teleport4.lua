function onStepIn(cid, item, position, fromPosition)
local teleport = {x=32909, y=32338, z=15}
doTeleportThing(cid, teleport, TRUE)
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_RED)
end