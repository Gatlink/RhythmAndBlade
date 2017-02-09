local Editor = require('Editor')
local Rail = require('Rail')
local RailEditor = require('RailEditor')

function love.load()
	love.graphics.setBackgroundColor(50, 50, 50)
	Editor.load()
end

function love.update(dt)
	RailEditor.update(dt)
end

function love.draw()
	love.graphics.setColor(155, 155, 155)
	for _, Rail in ipairs(Rail.all) do
		Rail:draw()
	end

	RailEditor.draw()
end

function love.mousepressed(x, y, button)
	RailEditor.mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	RailEditor.mousemoved(dx, dy)
end

function love.mousereleased(x, y, button)
	RailEditor.mousereleased(x, y, button)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	Editor.keypressed(key)
end
