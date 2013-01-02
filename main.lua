require "EnemyFunctions"
require "BulletFunctions"
require "CollisionDetection"
require "PlayerFunctions"
require "MenuInterface"
require "GameStateInterface"

	--[[
		-- IDEAS --
		- try out some 16 - 32 bit ships, allow player to change upgrade shit
		- eventually need to make code truly OO for different ships, enemies and weapons
		- background that moves, scrolling planets  and stars
		- maybe use particle effects as an explosion when player dies
		- if enemy hit make them turn red using a quad, flicker
		- if player is hit screenshake
		- sounds for hits and shooting and stuff
		- bosses, upgrades, different weapons
		- could either use oop for bullets and enemies or have an array of tables and set the old ones to nil...
	]]
	
	--[[
		-- BUGS --
		- sometimes enemies get stuck on right side of window
	]]

local Quad = love.graphics.newQuad
	
function love.load()
	--[[
		--- LOAD IMAGES --
	]]
	menuTitle = love.graphics.newImage("gfx/menu/menuTitle.png")
	menuTitle:setFilter("nearest", "nearest")
	menuCredit = love.graphics.newImage("gfx/menu/menuCredit.png")
	menuCredit:setFilter("nearest", "nearest")
	
	hudHeart = love.graphics.newImage("gfx/heart2.png")
	hudHeart:setFilter("nearest", "nearest")
	
	menu = love.graphics.newImage("gfx/menu/menuSheet.png")
	menu:setFilter("nearest", "nearest")
	
	sprite = love.graphics.newImage("gfx/sprites/ship1.png")
	sprite:setFilter("nearest", "nearest")
	
	invader_1 = love.graphics.newImage("gfx/sprites/invader1.png")
	invader_1:setFilter("nearest", "nearest")
	invader_2 = love.graphics.newImage("gfx/sprites/invader2.png")
	invader_2:setFilter("nearest", "nearest")
	invader_3 = love.graphics.newImage("gfx/sprites/invader3.png")
	invader_3:setFilter("nearest", "nearest")
	
	gridCover = love.graphics.newImage("gfx/bg/gridcover2.png")
	
	mouseCursor = love.graphics.newImage("gfx/mouse.png")
	mouseCursor:setFilter("nearest", "nearest")
	
	--[[
	--- LOAD QUADS --
	]]
	hudQuads = {
		fullHeart = {
			Quad(0, 0, 9, 10, 36, 20);
			Quad(9, 0, 9, 10, 36, 20);
			Quad(18, 0, 9, 10, 36, 20);
			Quad(27, 0, 9, 10, 36, 20);
		};
		halfHeart = {
			Quad(0, 10, 5, 10, 36, 20);
			Quad(5, 10, 5, 10, 36, 20);
			Quad(10, 10, 5, 10, 36, 20);
			Quad(15, 10, 5, 10, 36, 20);
		};
	}
	hudQuads.max = 4
	hudQuads.iteratorFH = 1
	hudQuads.iteratorHH = 1
	hudQuads.timerFH = 0
	hudQuads.timerHH = 0
	hudQuads.max = 4
	hudQuads.FH = 0
	hudQuads.HH = false
	
	menuQuads = {
		newGame = {
			Quad(0, 45, 405, 45, 810, 180);
			Quad(405, 45, 405, 45, 810, 180);
		};
		settings = {
			Quad(0, 0, 405, 45, 810, 180);
			Quad(405, 0, 405, 45, 810, 180);
		};
		quit = {
			Quad(0, 90, 405, 45, 810, 180);
			Quad(405, 90, 405, 45, 810, 180);
		};
		help = {
			Quad(0, 135, 405, 45, 810, 180);
			Quad(405, 135, 405, 45, 810, 180);
		};
		iterator = {}
	}
	menuQuads.mx = 0
	menuQuads.my = 0
	menuQuads.iterator.newGame = 1
	menuQuads.iterator.settings = 1
	menuQuads.iterator.quit = 1
	menuQuads.iterator.help = 1
	menuQuads.max = 4
	menuQuads.selected = 1
	menuQuads.cooldown = 0
	
	spriteQuads = {
		Quad(0, 0, 8, 16, 16, 16);
		Quad(8, 0, 8, 16, 16, 16);
	}
	spriteQuads.iterator = 1
	spriteQuads.max = 2
	spriteQuads.timer = 0
	spriteQuads.radians = 0
	
	--[[
	--- LOAD SOUND --
	]]
	song_1 = love.audio.newSource("sfx/stringedDisco.mp3", "stream")
	song_2 = love.audio.newSource("sfx/mall.mp3", "stream")
	
	-- load font
	font = love.graphics.newFont("gfx/Fipps.otf", 24)
	love.graphics.setFont(font)
	
	-- gameState contains booleans for controlling the order of events
	gameState = {}
	gameState.menu = true
	gameState.intro = false
	gameState.level = false
	gameState.pause = false
	
	-- enemies contains an array of enemies and their bullets for each level
	-- after a level is complete enemies[currentLevel] will be set to nil for garbage collection
	enemies = {}
	
	-- used for saving random values before added to enemies array
	tempEnemy = {}
	tempEnemy.x = 0
	tempEnemy.y = 0
	tempEnemy.xv = 0
	tempEnemy.yv = 0
	-- contains the values for the enemies of each level
	lvlEnemies = {}
	lvlEnemies.timer = 0
	lvlEnemies.timerMax = 0
	lvlEnemies.currentE = 0
	lvlEnemies.totalE = 0
	lvlEnemies.hp = 0
	lvlEnemies.speed = 0
	
	-- all player attributes as well as an array of bullets for each level
	-- treated the same as enemies
	player = {}
	player.xPos = 400
	player.yPos = 550
	player.xVel = 0
	player.yVel = 0
	player.acc = 300
	player.maxSpeed = 400
	player.hp = 400
	player.hitTimer = 0
	player.hitCooldown = 1
	player.bulletTimer = 0
	player.bulletCooldown = 0.1
	player.bulletLife = 0.75
	
	-- level.current will indicate the last level that has been reached, not completed
	level = {}
	level.current = 0
	level.set = false
	
	windowWidth =  love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()
	
	fpsOn = false
	
	love.mouse.setVisible(false)
	love.graphics.setColorMode("replace")
 end

 	--[[
		--- UPDATE --
	]]
function love.update(dt)

	if not level.set then
		enemies[level.current] = {}
		enemies[level.current].enemy = {}
		setLevelEnemies()
		
		player[level.current] = {}
		player[level.current].bullet = {}
		
		level.set = true
	end

	-- menu only
	if gameState.menu and not gameState.intro and not gameState.level and not gameState.pause then
		releaseLevelEnemies(dt)
		
		for i = 1, table.maxn(enemies[level.current].enemy) do
			if enemies[level.current].enemy[i] then
					enemies[level.current].enemy[i].xPos = enemies[level.current].enemy[i].xPos + (enemies[level.current].enemy[i].xVel*dt*enemies[level.current].enemy[i].speed)
					enemies[level.current].enemy[i].yPos = enemies[level.current].enemy[i].yPos + (enemies[level.current].enemy[i].yVel*dt*enemies[level.current].enemy[i].speed)
			end
		end
		mainMenu(dt)
	
	-- intro only
	elseif gameState.intro and not gameState.menu and not gameState.level and not gameState.pause then
		spriteAnimation(dt)
		player.xPos = 400
		player.yPos = player.yPos - 50*dt
		
		if player.yPos < 400 then
			song_1:play()
			setGameStateLevel()
		end
	
	-- level only
	elseif gameState.level and not gameState.menu and not gameState.intro and not gameState.pause then
	spriteOrientation()
	heartsAnimation(dt)
	spriteAnimation(dt)
	
	checkHorizontalMove(dt)
	checkHorizontalWrap(dt)
	checkVerticleMove(dt)
	checkVerticleWrap(dt)
	
	resolvePlayerShot(dt)
	
	-- also updates bullet position
	checkEnemyCollisions(dt)
	
	for i = 1, table.maxn(enemies[level.current].enemy) do
		if enemies[level.current].enemy[i] then
			updateEnemyPosition(i, dt)
		end
	end
	
	player.hitTimer = player.hitTimer + dt
	if player.hitTimer > player.hitCooldown then
		for l = 1, table.maxn(enemies[level.current].enemy) do
			if enemies[level.current].enemy[l] then
				if checkCollision(enemies[level.current].enemy[l].xPos, enemies[level.current].enemy[l].yPos, 32, 32, player.xPos, player.yPos, 32, 32) then
					resolvePlayerHit(50)
					resolveEnemyHit(enemies[level.current].enemy[l], 50)
					player.hitTimer = 0
				end
			end
		end
	end
	displayPlayerHp()
	
	if player.hp <= 0 then
			gameOver()
	end
	
	releaseLevelEnemies(dt)
	
	-- pause only
	elseif gameState.pause and not gameState.menu and not gameState.intro and not gameState.level then
		--mainMenu(dt)
	end
	
end

	--[[
		--- DRAW --
	]]
function love.draw()
	love.graphics.draw(gridCover)
	
	if fpsOn then
		love.graphics.print(love.timer.getFPS(),10,10,0,1,1)
	end
	
	-- menu only
	if gameState.menu and not gameState.intro and not gameState.level and not gameState.pause then
	
		for i = 1, table.maxn(enemies[level.current].enemy) do
				if enemies[level.current].enemy[i] then
					love.graphics.draw(invader_1,enemies[level.current].enemy[i].xPos, enemies[level.current].enemy[i].yPos, 0, 3, 3, 4, 4)
				end
		end
	
		love.graphics.draw(menuTitle, 0, 50)
		love.graphics.drawq(menu, menuQuads.newGame[menuQuads.iterator.newGame], 200, 290)
		love.graphics.drawq(menu, menuQuads.settings[menuQuads.iterator.settings], 200, 340)
		love.graphics.drawq(menu, menuQuads.help[menuQuads.iterator.help], 200, 390)
		love.graphics.drawq(menu, menuQuads.quit[menuQuads.iterator.quit], 200, 440)
		love.graphics.draw(menuCredit, 600, 580)
	end
	
	-- intro only
	if gameState.intro and not gameState.menu and not gameState.level and not gameState.pause then
		love.graphics.drawq(sprite, spriteQuads[spriteQuads.iterator], player.xPos, player.yPos, 0, 3, 3, 4, 4)
		love.graphics.print("Level " .. level.current, 330, 250, 0, 1, 1)
	end
	
	-- level only
	if gameState.level and not gameState.menu and not gameState.intro and not gameState.pause then
		love.graphics.drawq(sprite, spriteQuads[spriteQuads.iterator], player.xPos, player.yPos, spriteQuads.radians, 3, 3, 4, 4)
		
		for i = 1, hudQuads.FH do
			love.graphics.drawq(hudHeart, hudQuads.fullHeart[hudQuads.iteratorFH], (i*35), 555, 0, 3, 3)
		end
		if hudQuads.HH then
			love.graphics.drawq(hudHeart, hudQuads.halfHeart[hudQuads.iteratorHH], (hudQuads.FH*35)+35, 555, 0, 3, 3)
		end
		
		for j = 1, table.maxn(player[level.current].bullet) do
			if player[level.current].bullet[j] then
				love.graphics.setColor(0, 255, 0)
				love.graphics.circle("line", player[level.current].bullet[j].xPos, player[level.current].bullet[j].yPos, 5, 5)
			end
		end
		
		for k = 1, table.maxn(enemies[level.current].enemy) do
			if enemies[level.current].enemy[k] then
				love.graphics.draw(invader_1, enemies[level.current].enemy[k].xPos, enemies[level.current].enemy[k].yPos, 0, 3, 3, 4, 4)
			end
		end
	end
	
	-- pause only
	if gameState.pause and not gameState.menu and not gameState.intro and not gameState.level then
	
	end
	
	love.graphics.draw(mouseCursor, math.floor(love.mouse.getX()/3)*3-12, math.floor(love.mouse.getY()/3)*3-12, 0, 3, 3)
end
	
	--[[
		--- CALLBACKS --
	]]
function love.keypressed(key) 
	if key == "escape" then
		love.event.push("quit") 
   end
   
   	if gameState.menu then
		if key == "return" and menuQuads.selected == 1 then
			newGame()
		elseif key == "return" and menuQuads.selected == 2 then
		elseif key == "return" and menuQuads.selected == 3 then
		elseif key == "return" and menuQuads.selected == 4 then
			love.event.push("quit") 
		end
	else
		if key == " " and gameState.level then
			if gameState.pause then
				setGameStateLevel()
			else
				setGameStatePause()
			end
		elseif key == "p" then
			if fpsOn then
				fpsOn = false
			else
				fpsOn = true
			end
		end
	end
end