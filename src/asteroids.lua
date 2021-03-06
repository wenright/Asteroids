local asteroids = {}
local width
local height
local speed

function load_asteroids ()
	speed = 1

	if #asteroids > 0 then
		for i=#asteroids,1,-1 do
			remove_asteroid(i)
		end
		score = 0
	end

	local num_asteroids = 5
	for i=1,num_asteroids do
		local r = 100 * (math.random() + 0.5)
		local rot = 2 * i * math.pi / num_asteroids
		add_asteroid(math.cos(rot) * r, math.sin(rot) * r, 30)
	end
end

function add_asteroid(x, y, radius)
	local t = {}
	t.x = x
	t.y = y
	t.vx = math.random(-100, 100)
	t.vy = math.random(-100, 100)
	t.rotation = 0
	if math.random() > 0.5 then
		t.torque = math.random() * math.pi / 3
	else
		t.torque = math.random() * -math.pi / 3
	end
	t.radius = radius
	t.max_radius = t.radius * 1.5
	t.verts = {}
	t.temp_verts = {}
	local num_verts = 20
	for i=1,num_verts, 2 do
		local r = t.radius * (math.random() + 0.5)
		local rot = i * math.pi / 10
		t.verts[i] = math.cos(rot) * r
		t.verts[i + 1] = math.sin(rot) * r

		t.temp_verts[i] = t.verts[i]
		t.temp_verts[i + 1] = t.verts[i + 1]
	end

	table.insert(asteroids, t)
end

function remove_asteroid(index)
	if asteroids[index].radius > 15 then
		add_asteroid(asteroids[index].x, asteroids[index].y, asteroids[index].radius / 2)
		add_asteroid(asteroids[index].x, asteroids[index].y, asteroids[index].radius / 2)
	end
	score = score + 20 * (math.floor(50 / asteroids[index].radius))
	add_particle_system(asteroids[index].x, asteroids[index].y)
	table.remove(asteroids, index)
end

function update_asteroids(dt)
	for i=#asteroids, 1, -1 do
		local x_bound = asteroids[i].x
		local y_bound = asteroids[i].y

		--Update location
		asteroids[i].x = asteroids[i].x + asteroids[i].vx * speed * dt
		asteroids[i].y = asteroids[i].y + asteroids[i].vy * speed * dt

		--Check if out of bounds of screen, if so, teleport to opposite side
		if asteroids[i].x + asteroids[i].radius < 0 then
			asteroids[i].x = love.window.getWidth() + asteroids[i].radius
		elseif asteroids[i].x - asteroids[i].radius > love.window.getWidth() then
			asteroids[i].x = -asteroids[i].radius
		end
		if asteroids[i].y + asteroids[i].radius < 0 then
			asteroids[i].y = love.window.getHeight() + asteroids[i].radius
		elseif asteroids[i].y - asteroids[i].radius > love.window.getHeight() then
			asteroids[i].y = -asteroids[i].radius
		end

		asteroids[i].rotation = asteroids[i].rotation + asteroids[i].torque * dt
		local cos = math.cos(asteroids[i].rotation)
		local sin = math.sin(asteroids[i].rotation)

		for j=1,#asteroids[i].verts do
			if j % 2 ~= 0 then
				asteroids[i].temp_verts[j] = asteroids[i].verts[j] * cos - asteroids[i].verts[j + 1] * sin
			else
				asteroids[i].temp_verts[j] = asteroids[i].verts[j - 1] * sin + asteroids[i].verts[j] * cos
			end
		end

		for j=1,#asteroids[i].verts do
			if j % 2 ~= 0 then
				asteroids[i].temp_verts[j] = asteroids[i].x + asteroids[i].temp_verts[j]
			else
				asteroids[i].temp_verts[j] = asteroids[i].y + asteroids[i].temp_verts[j]
			end
		end
	end
end

function draw_asteroids()
	for i=1,#asteroids do
		love.graphics.polygon('line', asteroids[i].temp_verts)
	end
end

function get_asteroids ()
	return asteroids
end
