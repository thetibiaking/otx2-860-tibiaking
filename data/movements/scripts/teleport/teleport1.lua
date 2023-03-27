function onStepIn(cid, item, position, fromPosition)
local teleport = {x=33060, y=32711, z=5}
doTeleportThing(cid, teleport)
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_MAGIC_RED)
end