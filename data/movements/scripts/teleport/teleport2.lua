function onStepIn(cid, item, position, fromPosition)
local teleport = {x=32193, y=31419, z=2}
doTeleportThing(cid, teleport, TRUE)
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_RED)
end