function love.conf(t)
	-- Standard settings
	t.title = 'Spaceship Adventure!'
	t.author = 'Calvin Nichols'
	
	-- Screen
	-- SVGA
	t.screen.width = 800
    t.screen.height = 600

	-- Other settings
	t.modules.joystick = false
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.physics = false
end
