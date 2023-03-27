local storage = 40481 -- storage que salva a ultima vez que o player entrou (pra evitar spams)

function onStepIn(cid, item, pos, lastPos, fromPos, toPos, actor)
	doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
	doPlayerSetStorageValue(cid, storage)
return true
end