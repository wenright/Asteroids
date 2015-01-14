require 'player'
require 'lasers'
require 'asteroids'
require 'particles'
require 'shader'

function love.load()
	min_dt = 1/90
	next_time = love.timer.getTime()
	t = 0

	score = 0

	math.randomseed(os.time())

	load_player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	load_lasers()
	load_asteroids()
	load_particles()
	load_shaders()
end

function love.update(dt)
	next_time = next_time + min_dt
	t = t + dt

	update_player(dt, get_asteroids())
	update_lasers(dt, get_asteroids())
	update_asteroids(dt)
	update_particles(dt)
end

function love.draw()
	canvas:clear()
	blurred_canvas:clear()
	love.graphics.setCanvas(canvas)
	love.graphics.setBlendMode('alpha')

	draw_lasers()
	draw_player()
	draw_asteroids()
	draw_particles()

	--Post-processing
	love.graphics.setBlendMode('premultiplied')
	love.graphics.setCanvas(blurred_canvas)
	love.graphics.setShader(blur)
	love.graphics.draw(canvas, 0, 0, 0, 1 / blurred_canvas_scale, 1 / blurred_canvas_scale)
	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.draw(canvas, 0, 0)
	love.graphics.draw(blurred_canvas, 0, 0, 0, blurred_canvas_scale, blurred_canvas_scale)

	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end

function love.keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.keypressed(key)
	if key == ' ' then
		add_laser(get_player_attr())
	end
end

function level_cleared ()
	load_asteroids()
end

function game_over ()

end
