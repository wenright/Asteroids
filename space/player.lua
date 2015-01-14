local alive = true
local lives = 3
local rotation = 0
local rotation_speed = 1.5
local x = 0
local y = 0
local vx = 0
local vy = 0
local acceloration = 7
local verts

function load_player (start_x, start_y)
	x = start_x
	y = start_y

	verts = {0, -25,
			20, 25,
			0, 10,
			-20, 25}
end

function update_player(dt, asteroids)
	if lives >= 0 then
		--Move player based on current x and y velocities
		x = x + vx
		y = y + vy

		--Check for collisions with asteroids
		--TODO allow for more acurate, edge-based collisions
		--print(height)
		for i=#asteroids, 1, -1 do
			if math.abs(asteroids[i].x - x) < asteroids[i].radius and math.abs(asteroids[i].y - y) < asteroids[i].radius then
				table.remove(asteroids, i)
				alive = false
				lives = lives - 1
				print("asteroid["..i.."] removed, player died")
			end
		end

		if lives < 0 then
			game_over()
		end

		--Check if player has moved offscreen
		if x < 0 then
			x = love.window.getWidth()
		elseif x > love.window.getWidth() then
			x = 0
		end
		if y < 0 then
			y = love.window.getHeight()
		elseif y > love.window.getHeight() then
			y = 0
		end

		--Handle player input
		if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
			rotation = rotation - rotation_speed * math.pi * dt
		end

		if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
			rotation = rotation + rotation_speed * math.pi * dt
		end

		if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
			vx = vx + acceloration * math.cos(rotation - math.pi / 2) * dt
			vy = vy + acceloration * math.sin(rotation - math.pi / 2) * dt
		end

		if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
			vx = vx - acceloration * math.cos(rotation - math.pi / 2) * dt
			vy = vy - acceloration * math.sin(rotation - math.pi / 2) * dt
		end
	end
end

function draw_player()
	if lives >= 0 then
		local temp_verts = {}
		for i=1,#verts do
			if i % 2 ~= 0 then
				temp_verts[i] = x + verts[i]
			else
				temp_verts[i] = y + verts[i]
			end
		end

		love.graphics.push()
		love.graphics.translate(x, y)
		love.graphics.rotate(rotation)
		love.graphics.translate(-x, -y)
		love.graphics.polygon('line', temp_verts)
		love.graphics.pop()

		if lives > 0 then
			for i=1,lives do
				temp_verts = {}
				for j=1,#verts,2 do
					temp_verts[j] = (verts[j] - i * 50) / 2 + love.window.getWidth()
					temp_verts[j + 1] = (verts[j + 1] + 50) / 2
				end
				love.graphics.polygon('line', temp_verts)
			end
		end
	else
		love.graphics.print("Game Over", love.window.getWidth() / 4, love.window.getHeight() / 2, 0, 2, 2)
	end

	love.graphics.print(score, 0, 0, 0, 1, 1)
end

function get_player_attr ()
	local t = {}
	t.x = x
	t.y = y
	t.vx = math.cos(rotation - math.pi / 2)
	t.vy = math.sin(rotation - math.pi / 2)
	t.rotation = rotation
	return t
end

function get_player_speed () 
	return math.sqrt(math.pow(vx, 2) + math.pow(vy, 2))
end
