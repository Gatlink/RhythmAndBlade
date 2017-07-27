-- UTILITIES
Vector = require('scripts/Vector')

-- LD
Rail = require('scripts/Rail')

-- CONTROLLERS
ControllerBase = require('scripts/controllers/ControllerBase')
GamePad = require('scripts/controllers/GamePad')
Gravity = require('scripts/controllers/Gravity')
Keyboard = require('scripts/controllers/Keyboard')
PlaySoundContinuously = require('scripts/controllers/PlaySoundContinuously')

-- ACTORS
ActorBase = require('scripts/ActorBase')
Camera = require('scripts/Camera')
Player = require('scripts/Player')
Sound = require('scripts/Sound')

-- EDITOR
Editor = require('editor/Editor')
RailEditor = require('editor/RailEditor')
ActorEditor = require('editor/ActorEditor')

local soundEmitter

function love.load()
	love.graphics.setBackgroundColor(50, 50, 50)
	
	if not Editor.load() then
		Rail.new(400, 300)
	end

	Player:load()

	soundEmitter = ActorBase.new(200, 50)
	-- soundEmitter:addController(PlaySoundContinuously.new(soundEmitter))

	soundEmitter:load()
end

function love.update(dt)
	Camera:update(dt)

	RailEditor.update(dt)

	Player:update(dt)

	soundEmitter:update(dt)

	for _, sound in ipairs(Sound.all) do
		sound:update(dt)
	end
end

function love.draw()
	Camera:preDraw()

	love.graphics.setColor(155, 155, 155)
	for _, rail in ipairs(Rail.all) do
		rail:draw()
	end

	Player:draw()

	soundEmitter:draw()

	for _, sound in ipairs(Sound.all) do
		sound:draw()
	end

	RailEditor.draw()
	ActorEditor.draw()

	Camera:draw()
	Camera:postDraw()
end

function love.mousepressed(x, y, button)
	x, y = Camera:translate(x, y)
	RailEditor.mousepressed(x, y, button)
	ActorEditor.mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	x, y = Camera:translate(x, y)
	RailEditor.mousemoved(x, y, dx, dy)
	ActorEditor.mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, button)
	x, y = Camera:translate(x, y)
	RailEditor.mousereleased(x, y, button)
	ActorEditor.mousereleased(x, y, button)
end

function love.keypressed(key)
	if key == 'f4' and (love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt')) then
		love.event.quit()
	end

	Editor.keypressed(key)
	RailEditor.keypressed(key)
	ActorEditor.keypressed(key)
end
