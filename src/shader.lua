function load_shaders ()
	if not love.graphics.newShader
	or not love.graphics.isSupported
	or not love.graphics.isSupported("shader")
	or not love.graphics.isSupported("canvas") then
		print("Your graphics card does not support shaders :(")
		return
	end

	canvas = love.graphics.newCanvas()
	blurred_canvas = love.graphics.newCanvas()

	love.graphics.setPointStyle('smooth')
	love.graphics.setLineStyle('smooth')
	love.graphics.setLineWidth(1)
	love.graphics.setColor(245, 239, 227)
	love.graphics.setBackgroundColor(0, 0, 0)

	font = love.graphics.newFont(36)
	love.graphics.setFont(font)

	blur = love.graphics.newShader('shaders/blur.frag')

	blur:send('width', love.graphics.getWidth())
	blur:send('height', love.graphics.getHeight())
	blur:send('radius', 4.5)
end

function apply_shaders ()
	--Post-processing
	love.graphics.setBlendMode('premultiplied')
	love.graphics.setCanvas(blurred_canvas)
	love.graphics.setShader(blur)
	love.graphics.draw(canvas, 0, 0)
	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.draw(canvas, 0, 0)
	love.graphics.draw(blurred_canvas, 0, 0)
end
