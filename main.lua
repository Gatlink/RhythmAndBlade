local Ground = require('Ground')
local GroundEditor = require('GroundEditor')

function love.load()
	love.graphics.setBackgroundColor(50, 50, 50)
	Ground.new(400, 300)
end

function love.update(dt)
	GroundEditor.update(dt)
end

function love.draw()
	love.graphics.setColor(155, 155, 155)
	for _, ground in ipairs(Ground.all) do
		ground:draw()
	end

	GroundEditor.draw()
end

function love.mousepressed(x, y, button)
	GroundEditor.mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	GroundEditor.mousemoved(dx, dy)
end

function love.mousereleased(x, y, button)
	GroundEditor.mousereleased(x, y, button)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end
