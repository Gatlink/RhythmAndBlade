local Editor = require('editor/Editor')

local Rail = require('scripts/Rail')
local RailEditor = require('editor/RailEditor')

local ActorBase = require('scripts/ActorBase')
local ActorEditor = require('editor/ActorEditor')

local Gravity = require('scripts/controllers/Gravity')
local GamePad = require('scripts/controllers/GamePad')
local Keyboard = require('scripts/controllers/Keyboard')

local Camera = require('scripts/Camera')

local actor

function love.load()
	love.graphics.setBackgroundColor(50, 50, 50)
	
	if not Editor.load() then
		Rail.new(400, 300)
	end

	actor = ActorBase.new(50, 50)
	table.insert(actor.controllers, Gravity)
	table.insert(actor.controllers, GamePad)

	actor:load()
end

function love.update(dt)
	Camera:update(dt)

	RailEditor.update(dt)

	actor:update(dt)
end

function love.draw()
	Camera:draw()
	Camera:preDraw()

	love.graphics.setColor(155, 155, 155)
	for _, rail in ipairs(Rail.all) do
		rail:draw()
	end

	actor:draw()

	RailEditor.draw()
	ActorEditor.draw()

	Camera:postDraw()
end

function love.mousepressed(x, y, button)
	RailEditor.mousepressed(x, y, button)
	ActorEditor.mousepressed(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	RailEditor.mousemoved(x, y, dx, dy)
	ActorEditor.mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, button)
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
