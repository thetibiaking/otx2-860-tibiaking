local waitTime = 2 -- minutos

function onStartup()
    doSetGameState(GAMESTATE_CLOSED)
    addEvent(doSetGameState, (waitTime * 60) * 1000, GAMESTATE_NORMAL)
    return true
end