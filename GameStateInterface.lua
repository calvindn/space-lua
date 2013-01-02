function setGameStateMenu ()
	gameState.menu = true
	gameState.intro = false
	gameState.level = false
	gameState.pause = false
end

function setGameStateIntro ()
	gameState.menu = false
	gameState.intro = true
	gameState.level = false
	gameState.pause = false
end

function setGameStateLevel ()
	gameState.menu = false
	gameState.intro = false
	gameState.level = true
	gameState.pause = false
end

function setGameStatePause ()
	gameState.menu = false
	gameState.intro = false
	gameState.level = false
	gameState.pause = true
end