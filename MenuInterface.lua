function mainMenu(dt)
	menuQuads.cooldown = menuQuads.cooldown + dt
		
		local mx, my = love.mouse.getPosition()
		
		if mx > 200 and mx < 610 then
			if my > 290 and my < 340 then
				if love.mouse.isDown("l") then
					newGame()
				end
			elseif my > 340 and my < 390 then
			elseif my > 390 and my < 440 then
			elseif my > 440 and my < 490 then
				if love.mouse.isDown("l") then
					love.event.push("quit") 
				end
			end
		end
		
		if mx > 200 and mx < 610 and (mx ~= menuQuads.mx or my ~= menuQuads.my) then
			if my > 290 and my < 340 then
				menuQuads.selected = 1
			elseif my > 340 and my < 390 then
				menuQuads.selected = 2
			elseif my > 390 and my < 440 then
				menuQuads.selected = 3
			elseif my > 440 and my < 490 then
				menuQuads.selected = 4
			end
		end
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			if menuQuads.cooldown > 0.13 then
				menuQuads.cooldown = 0
				menuQuads.selected = menuQuads.selected - 1
				if menuQuads.selected < 1 then
					menuQuads.selected = menuQuads.max
				end
			end
		elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			if menuQuads.cooldown > 0.13 then
				menuQuads.cooldown = 0
				menuQuads.selected = menuQuads.selected + 1
				if menuQuads.selected > menuQuads.max then
					menuQuads.selected = 1
				end
			end
		end
		
		if menuQuads.selected == 1 then
			menuQuads.iterator.newGame = 2
			menuQuads.iterator.settings = 1
			menuQuads.iterator.quit = 1
			menuQuads.iterator.help = 1
		elseif menuQuads.selected == 2 then
			menuQuads.iterator.settings = 2
			menuQuads.iterator.newGame = 1
			menuQuads.iterator.quit = 1
			menuQuads.iterator.help = 1
		elseif menuQuads.selected == 3 then
			menuQuads.iterator.help = 2
			menuQuads.iterator.quit = 1
			menuQuads.iterator.newGame = 1
			menuQuads.iterator.settings = 1
		elseif menuQuads.selected == 4 then
			menuQuads.iterator.quit = 2
			menuQuads.iterator.newGame = 1
			menuQuads.iterator.settings = 1
			menuQuads.iterator.help = 1
		end
		
		menuQuads.mx, menuQuads.my = mx, my
end

function newGame()
	level.set = false
	level.current = 1
	player.yPos = 640
	player.xPos = 400
	player.hp = 400
	player.xVel = 0
	player.yVel = 0
	setGameStateIntro()
end

function newLevel()
	level.set = false
	enemies[level.current] = nil
	player[level.current] = nil
	level.current = level.current + 1
	player.yPos = 640
	player.xPos = 400
	player.xVel = 0
	player.yVel = 0
	player.hp = 400
	setGameStateIntro()
end

function gameOver()
	enemies[level.current] = nil
	player[level.current] = nil
	level.current = 0
	setGameStateMenu()
end