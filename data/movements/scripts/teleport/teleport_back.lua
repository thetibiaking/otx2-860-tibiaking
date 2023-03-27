function onStepIn(cid, item, position, fromPosition)
local teleport = {x=32369, y=32241, z=7}
doTeleportThing(cid, teleport)
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_RED)
end