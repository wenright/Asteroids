local asteroids = {}
local width
local height
local speed

function load_asteroids ()
	speed = 1

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
	t.torque = math.random(-1.5, 1.5)
	t.radius = radius
	t.max_radius = t.radius * 1.5
	t.verts = {}
	local num_verts = 20
	for i=1,num_verts, 2 do
		local r = t.radius * (math.random() + 0.5)
		local rot = i * math.pi / 10
		t.verts[i] = math.cos(rot) * r
		t.verts[i + 1] = math.sin(rot) * r
	end

	table.insert(asteroids, t)
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
	end
end

function draw_asteroids()
	for i=1,#asteroids do
		local v = {}

		for j=1,#asteroids[i].verts do
			if j % 2 ~= 0 then
				v[j] = asteroids[i].x + asteroids[i].verts[j]
			else
				v[j] = asteroids[i].y + asteroids[i].verts[j]
			end
		end

		love.graphics.push()
		love.graphics.translate(asteroids[i].x, asteroids[i].y)
		love.graphics.rotate(t * asteroids[i].torque)
		love.graphics.translate(-asteroids[i].x, -asteroids[i].y)
		love.graphics.polygon('line', v)
		love.graphics.pop()
	end
end

function get_asteroids ()
	return asteroids
end
