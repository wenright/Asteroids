local lasers = {}
local image
local width
local height
local scale
local speed

function load_lasers ()
	speed = 500
end

function add_laser(t)
	t.x = t.x + math.cos(t.rotation - math.pi / 2) * 25
	t.y = t.y + math.sin(t.rotation - math.pi / 2) * 25
	table.insert(lasers, t)
end

function update_lasers(dt, asteroids)
	local lasers_to_be_removed = {}

	for i=#lasers,1,-1 do
		lasers[i].x = lasers[i].x + lasers[i].vx * speed * dt
		lasers[i].y = lasers[i].y + lasers[i].vy * speed * dt

		--Check for collision with asteroid
		for j=#asteroids,1,-1 do
			if math.abs(asteroids[j].x - lasers[i].x) < asteroids[j].radius and math.abs(asteroids[j].y - lasers[i].y) < asteroids[j].radius then
				if asteroids[j].radius > 15 then
					add_asteroid(asteroids[j].x, asteroids[j].y, asteroids[j].radius / 2)
					add_asteroid(asteroids[j].x, asteroids[j].y, asteroids[j].radius / 2)
				end
				score = score + 20
				add_particle_system(asteroids[j].x, asteroids[j].y)
				table.remove(asteroids, j)
				table.insert(lasers_to_be_removed, i)
				print("asteroid["..j.."] removed, hit by laser["..i.."]")
			end
		end

		if #asteroids == 0 then
			level_cleared()
		end

		--Remove laser if it leaves the screen. Could have it wrap like ship/asteroid
		if lasers[i].x < 0 or lasers[i].x > love.graphics.getWidth() or lasers[i].y < 0 or lasers[i].y > love.graphics.getHeight() then
			table.insert(lasers_to_be_removed, i)
		end
	end

	for i=1,#lasers_to_be_removed do
		table.remove(lasers, lasers_to_be_removed[i])
	end
end

function draw_lasers()
	for i=#lasers,1,-1 do
		love.graphics.point(lasers[i].x, lasers[i].y)
	end
end
