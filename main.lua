local Editor = require('editor/Editor')
local Rail = require('scripts/Rail')
local RailEditor = require('editor/RailEditor')

function love.load()
	love.graphics.setBackgroundColor(50, 50, 50)
	
	if not Editor.load() then
		Rail.new(400, 300)
	end
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
	RailEditor.mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, button)
	RailEditor.mousereleased(x, y, button)
end

function love.keypressed(key)
	if key == 'f4' and love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt') then
		love.event.quit()
	end

	Editor.keypressed(key)
	RailEditor.keypressed(key)
end
