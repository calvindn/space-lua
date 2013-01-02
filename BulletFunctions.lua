function addBullet()
	player[level.current].bullet[#player[level.current].bullet+1] = {}
	player[level.current].bullet[#player[level.current].bullet].xPos = player.xPos
	player[level.current].bullet[#player[level.current].bullet].yPos = player.yPos
	player[level.current].bullet[#player[level.current].bullet].xVel = 0
	player[level.current].bullet[#player[level.current].bullet].yVel = 0
	player[level.current].bullet[#player[level.current].bullet].speed = 1000
	player[level.current].bullet[#player[level.current].bullet].lifespan = 0
end

function calculateBulletVelocity(mx, my)
	local px = player.xPos
	local py = player.yPos
	
	local dx = mx - px
	local dy = my - py
	
	local hypotenuse = math.sqrt(dx*dx + dy*dy)
	local radians = math.asin(dy/hypotenuse)
	
	player[level.current].bullet[#player[level.current].bullet].xVel = (math.cos(radians)) * player[level.current].bullet[#player[level.current].bullet].speed
	player[level.current].bullet[#player[level.current].bullet].yVel = (math.sin(radians)) * player[level.current].bullet[#player[level.current].bullet].speed
	
	if mx < player.xPos then
		player[level.current].bullet[#player[level.current].bullet].xVel = player[level.current].bullet[#player[level.current].bullet].xVel * (-1)
	end
end

function updateBulletPosition(index, dt)
	--[[
	bullets[index].xPos = bullets[index].xPos + (bullets[index].xVel*dt*bullets[index].speed)
	bullets[index].yPos = bullets[index].yPos + (bullets[index].yVel*dt*bullets[index].speed)
	--]]
	---[[
	player[level.current].bullet[index].xPos = player[level.current].bullet[index].xPos + (player[level.current].bullet[index].xVel*dt)
	player[level.current].bullet[index].yPos = player[level.current].bullet[index].yPos + (player[level.current].bullet[index].yVel*dt)
	--]]
end

function resolvePlayerShot(dt)
	player.bulletTimer = player.bulletTimer + dt
	if love.mouse.isDown("l") and player.bulletTimer > player.bulletCooldown then
		player.bulletTimer = 0
		local mx, my = love.mouse.getPosition()
		addBullet()
		calculateBulletVelocity(mx, my)
	end
end

function destroyLevelBullets()
	player[level.current] = nil
end