function displayPlayerHp()  --  NEED TO FIX THIS
	local hp = player.hp
	hudQuads.FH = math.floor(hp/100)
	if hp % 100 ~= 0 then
		hudQuads.HH = true
	else
		hudQuads.HH = false
	end
end

function spriteOrientation()
	local mx, my = love.mouse.getPosition()
	
	local px = player.xPos
	local py = player.yPos
	
	local dx = mx - px
	local dy = my - py
	
	spriteQuads.radians = math.atan2(dx, dy)*-1+math.pi
end

function spriteAnimation(dt)
	spriteQuads.timer = spriteQuads.timer + dt
	if spriteQuads.timer > 0.2 then
		spriteQuads.timer = 0
		spriteQuads.iterator = spriteQuads.iterator + 1
		if spriteQuads.iterator > spriteQuads.max then
			spriteQuads.iterator = 1
		end
	end
end

function checkHorizontalMove(dt)
	if love.keyboard.isDown("d") and player.xVel < player.maxSpeed then
			player.xVel = player.xVel + (player.acc*dt)
	elseif love.keyboard.isDown("a") and player.xVel > -player.maxSpeed then
			player.xVel = player.xVel - (player.acc*dt)
	end
end

function checkHorizontalWrap(dt)
	if player.xPos > windowWidth then
			player.xPos = 0
	elseif player.xPos < 0 then
			player.xPos = windowWidth
	end	
	player.xPos = player.xPos + (player.xVel * dt)
end

function checkVerticleMove(dt)
   if love.keyboard.isDown("s") and player.yVel < player.maxSpeed then
			player.yVel = player.yVel + (player.acc*dt)
   elseif love.keyboard.isDown("w") and player.yVel > -player.maxSpeed then
			player.yVel = player.yVel - (player.acc*dt)
   end
end

function checkVerticleWrap(dt)
	if player.yPos > windowHeight then
		player.yPos = 0
	elseif player.yPos < 0 then
		player.yPos = windowHeight
	end
	player.yPos = player.yPos + (player.yVel * dt)
end

function heartsAnimation(dt)
	hudQuads.timerFH = hudQuads.timerFH + dt
	if hudQuads.timerFH > 0.3 then
		hudQuads.timerFH = 0
		hudQuads.iteratorFH = hudQuads.iteratorFH + 1
		if hudQuads.iteratorFH > hudQuads.max then
			hudQuads.iteratorFH = 1
		end
	end
	
	hudQuads.timerHH = hudQuads.timerHH + dt
	if hudQuads.timerHH > 0.3 then
		hudQuads.timerHH = 0
		hudQuads.iteratorHH = hudQuads.iteratorHH + 1
		if hudQuads.iteratorHH > hudQuads.max then
			hudQuads.iteratorHH = 1
		end
	end
end

function displayPlayerHp()
	local hp = player.hp
	hudQuads.FH = math.floor(hp/100)
	if hp % 100 ~= 0 then
		hudQuads.HH = true
	else
		hudQuads.HH = false
	end
end