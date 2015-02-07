local num_stars
local star_canvas

function load_starfield()
	num_stars = 150
	local max_size = 3

	star_canvas = love.graphics.newCanvas()
	love.graphics.setCanvas(star_canvas)

	for i=1,num_stars do
		love.graphics.setPointSize(math.floor(math.random() * max_size) + 1)
		love.graphics.point(math.random() * love.window.getWidth(), math.random() * love.window.getHeight())
	end
	love.graphics.setPointSize(3)
	love.graphics.setCanvas()
end

function draw_starfield()
	love.graphics.draw(star_canvas)
end
