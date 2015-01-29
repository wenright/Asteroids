local alive
local death_wait_time
local death_timer
local lives
local rotation
local rotation_speed = 1.5
local x = 0
local y = 0
local vx = 0
local vy = 0
local acceleration = 5
local max_speed = 10
local verts
local temp_verts = {}

function load_player (start_x, start_y)
	alive = true
	death_wait_time = 2
	death_timer = death_wait_time
	lives = 3
	rotation = 0

	x = start_x
	y = start_y

	--Define player shape
	verts = { 0,-25,
			 20, 25,
			  0, 10,
			-20, 25 }
end

function update_player(dt, asteroids)
	if lives >= 0 and alive then
		local cos = math.cos(rotation)
		local sin = math.sin(rotation) 

		x = x + vx
		y = y + vy

		if love.keyboard.isDown('a') or love.keyboard.isDown('left') then 
			rotation = rotation - rotation_speed * math.pi * dt 
		end 
		if love.keyboard.isDown('d') or love.keyboard.isDown('right') then 
			rotation = rotation + rotation_speed * math.pi * dt 
		end 
		if love.keyboard.isDown('w') or love.keyboard.isDown('up') then 
			if vx <= max_speed and cos >= 0 or vx >= -max_speed and cos <= 0 then 
				vx = vx + acceleration * sin * dt
			end 
			if vy <= max_speed and sin >= 0 or vy >= -max_speed and sin <= 0 then 
				vy = vy - acceleration * cos * dt
			end
		end

		--Rotate
		for i=1,#verts do
			if i % 2 ~= 0 then
				temp_verts[i] = verts[i] * cos - verts[i + 1] * sin 
			else
				temp_verts[i] = verts[i - 1] * sin + verts[i] * cos
			end
		end

		--Translate
		for i=1,#verts do
			if i % 2 ~= 0 then
				temp_verts[i] = temp_verts[i] + x 
			else
				temp_verts[i] = temp_verts[i] + y
			end
		end

		--Check for collisions with asteroids
		for i=#asteroids, 1, -1 do
			--First check a basic circle collider to save computation
			if math.abs(asteroids[i].x - x) < asteroids[i].radius + 50 and math.abs(asteroids[i].y - y) < asteroids[i].radius + 50 then
				if is_polygon_in_polygon(temp_verts, asteroids[i].temp_verts) then
					remove_asteroid(i)
					alive = false
					lives = lives - 1
					x = love.graphics.getWidth() / 2
					y = love.graphics.getHeight() / 2
					vx = 0
					vy = 0
					rotation = 0
					break
				end
			end
		end

		if lives < 0 then
			game_over()
		end

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
	elseif death_timer <= 0 and lives >= 0 then
		death_timer = death_wait_time
		alive = true
	else
		death_timer = death_timer - dt
	end
end

function draw_player()
	if lives >= 0 and alive then
		love.graphics.polygon('line', temp_verts)

		--Draw lives in top right corner
		--TODO draw lives once at beginning, apply to canvas
		if lives > 0 then
			for i=1,lives do
				local t = {}
				for j=1,#verts,2 do
					t[j] = (verts[j] - i * 50) / 2 + love.window.getWidth()
					t[j + 1] = (verts[j + 1] + 50) / 2
				end
				love.graphics.polygon('line', t)
			end
		end
	elseif lives < 0 then
		love.graphics.print("Game Over", love.window.getWidth() / 4, love.window.getHeight() / 2, 0, 2, 2)
	end

	love.graphics.print(score, 0, 0, 0, 1, 1)
end

function get_player_attr ()
	local t = {}
	t.x = x
	t.y = y
	t.dirx = math.cos(rotation - math.pi / 2)
	t.diry = math.sin(rotation - math.pi / 2)
	t.rotation = rotation
	return t
end

function get_player_speed () 
	return math.sqrt(math.pow(vx, 2) + math.pow(vy, 2))
end

function love.keypressed(key)
	if key == ' ' and alive then
		add_laser(get_player_attr())
	end
end
