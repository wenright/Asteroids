local particle_systems = {}
local num_particles = 15
local particle_speed = 0.08

function load_particles ()
	
end

function add_particle_system(x, y)
	local new_system = {}
	new_system.lifetime = 0.2
	new_system.particles = {}
	for i=1,num_particles do
		new_system.particles[i] = {}
		new_system.particles[i].x = x
		new_system.particles[i].y = y
		new_system.particles[i].vx = math.random(-100, 100) * particle_speed
		new_system.particles[i].vy = math.random(-100, 100) * particle_speed
	end
	table.insert(particle_systems, new_system)
end

function update_particles(dt)
	for i=#particle_systems,1,-1 do
		for j=1,#particle_systems[i].particles do
			particle_systems[i].particles[j].x = particle_systems[i].particles[j].x + particle_systems[i].particles[j].vx
			particle_systems[i].particles[j].y = particle_systems[i].particles[j].y + particle_systems[i].particles[j].vy
		end

		particle_systems[i].lifetime = particle_systems[i].lifetime - dt
		if particle_systems[i].lifetime < 0 then
			table.remove(particle_systems, i)
		end
	end
end

function draw_particles()
	for i=1,#particle_systems do
		for j=1,#particle_systems[i].particles do
			love.graphics.setPointSize(1)
			love.graphics.point(particle_systems[i].particles[j].x, particle_systems[i].particles[j].y)
			love.graphics.setPointSize(3)
		end
	end
end
