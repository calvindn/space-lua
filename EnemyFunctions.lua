
function addEnemy(x, y, xv, yv, hp)
	enemies[level.current].enemy[#enemies[level.current].enemy+1] = {}
	enemies[level.current].enemy[#enemies[level.current].enemy].xPos = x
	enemies[level.current].enemy[#enemies[level.current].enemy].yPos = y
	enemies[level.current].enemy[#enemies[level.current].enemy].xVel = xv or 0
	enemies[level.current].enemy[#enemies[level.current].enemy].yVel = yv or 1
	enemies[level.current].enemy[#enemies[level.current].enemy].hp = hp or 100
	enemies[level.current].enemy[#enemies[level.current].enemy].speed = 70
	--enemies[level.current].enemy[#enemies[level.current].enemy].surviveTime = 0
end

function updateEnemyPosition(index, dt)
	enemies[level.current].enemy[index].xPos = enemies[level.current].enemy[index].xPos + (enemies[level.current].enemy[index].xVel*dt*enemies[level.current].enemy[index].speed)
	enemies[level.current].enemy[index].yPos = enemies[level.current].enemy[index].yPos + (enemies[level.current].enemy[index].yVel*dt*enemies[level.current].enemy[index].speed)
	
	-- to avoid instant wrapping
	--enemies[level.current].enemy[index].surviveTime = enemies[level.current].enemy[index].surviveTime + dt
	
	if level.current > 0 then --and enemies[level.current].enemy[index].surviveTime > 0.4 then
		if enemies[level.current].enemy[index].xPos > 805 then
			enemies[level.current].enemy[index].xPos = -5
		end
		if enemies[level.current].enemy[index].xPos < -5 then
			enemies[level.current].enemy[index].xPos = windowWidth+5
		end
		if enemies[level.current].enemy[index].yPos > 605 then
			enemies[level.current].enemy[index].yPos = -5
		end
		if enemies[level.current].enemy[index].yPos < -5 then
			enemies[level.current].enemy[index].yPos = windowHeight+5
		end
	end
end

function setLevelEnemies()
	lvlEnemies.timerMax = 3 - (level.current * 0.1)
	if level.current > 25 then
		lvlEnemies.timerMax = 0.5
	end
	lvlEnemies.timer = 0
	lvlEnemies.totalE = 5 + (level.current * 5)
	if level.current == 0 then
		lvlEnemies.totalE = 9999
	end
	lvlEnemies.currentE = 0
	lvlEnemies.hp = level.current * 10
	lvlEnemies.speed = level.current + 69
end

function releaseLevelEnemies(dt)
	
	lvlEnemies.timer = lvlEnemies.timer + dt
	
	if lvlEnemies.timer > lvlEnemies.timerMax and lvlEnemies.currentE < lvlEnemies.totalE then
		if level.current == 0 then
			 lvlEnemies.timerMax = math.random(0, 8)
		end
		lvlEnemies.timer = 0
		tempEnemy.x = math.random(-400, windowWidth+400)
		if tempEnemy.x < 0 then -- left side of window
			tempEnemy.x = -40
			tempEnemy.y = math.random(15, windowHeight-15)
			tempEnemy.xv = math.random (0, 6)
			tempEnemy.yv = math.random(0, 4)
		elseif tempEnemy.x > windowWidth then -- right side of window
			tempEnemy.x = 840
			tempEnemy.y = math.random(15, windowHeight-15)
			tempEnemy.xv = math.random (-6, 0)
			tempEnemy.yv = math.random(-4, 0)
		else -- values is within window bounds
			tempEnemy.y = math.random(0,3)
			if tempEnemy.y == 1 then
				tempEnemy.y = -40
				tempEnemy.xv = math.random(0, 4)
				tempEnemy.yv = math.random(0, 6)
			elseif tempEnemy.y == 2 then
				tempEnemy.y = 640
				tempEnemy.xv = math.random(-4, 0)
				tempEnemy.yv = math.random(-6, 0)
			else
				tempEnemy.y = -40
				tempEnemy.xv = math.random(0, 4)
				tempEnemy.yv = math.random(0, 6)
			end
		end
		addEnemy(tempEnemy.x, tempEnemy.y, tempEnemy.xv, tempEnemy.yv, lvlEnemies.hp, lvlEnemies.speed)
		lvlEnemies.currentE = lvlEnemies.currentE + 1
	end
	
	if lvlEnemies.currentE >= lvlEnemies.totalE then
		if allEnemiesDead() then
			newLevel()
		end
	end
end

function allEnemiesDead()
	for i = 1, table.maxn(enemies[level.current].enemy) do
		if enemies[level.current].enemy[i] then
			return false
		end
	end
	return true
end

function enemyDead(enemy)
	if enemy.hp > 0 then
		return false
	else
		return true
	end
end

