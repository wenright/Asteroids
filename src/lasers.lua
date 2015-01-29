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
	t.lifetime = 1
	table.insert(lasers, t)
end

function update_lasers(dt, asteroids)
	local lasers_to_be_removed = {}

	for i=#lasers,1,-1 do
		lasers[i].x = lasers[i].x + lasers[i].dirx * speed * dt
		lasers[i].y = lasers[i].y + lasers[i].diry * speed * dt

		for j=#asteroids,1,-1 do
			if is_point_in_polygon({lasers[i].x, lasers[i].y}, asteroids[j].temp_verts) then
				remove_asteroid(j)
				table.insert(lasers_to_be_removed, i)
				print("asteroid["..j.."] removed, hit by laser["..i.."]")
			end
		end

		if #asteroids == 0 then
			level_cleared()
		end

		if lasers[i].x < 0 then
			lasers[i].x = love.graphics.getWidth()
		elseif lasers[i].x > love.graphics.getWidth() then
			lasers[i].x = 0
		end
		if lasers[i].y < 0 then
			lasers[i].y = love.graphics.getHeight()
		elseif lasers[i].y > love.graphics.getHeight() then
			lasers[i].y = 0
		end

		lasers[i].lifetime = lasers[i].lifetime - dt
		if lasers[i].lifetime <= 0 then 
			table.insert(lasers_to_be_removed, i)
		end
	end

	for i=1,#lasers_to_be_removed do
		table.remove(lasers, lasers_to_be_removed[i])
	end
end

function draw_lasers()
	love.graphics.setPointSize(3)
	for i=#lasers,1,-1 do
		love.graphics.point(lasers[i].x, lasers[i].y)
	end
end
