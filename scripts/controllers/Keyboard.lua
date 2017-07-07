local ControllerBase = require('scripts/controllers/ControllerBase')
local Vector = require('scripts/Vector')

local Keyboard = {}
Keyboard.__index = Keyboard
setmetatable(Keyboard, ControllerBase)

Keyboard.new = function (actor)
	local new = ControllerBase.new(actor)

	setmetatable(new, Keyboard)
	return new
end

Keyboard.update = function (self)
	if not self.active then
		self.actor.targetSpeed:set(0, 0)
		self.actor.curSpeed:set(0, 0)
		return
	end

	local direction = Vector.new()

	if love.keyboard.isDown("left") then
		direction.x = -1
	elseif love.keyboard.isDown("right") then
		direction.x = 1
	end

	if love.keyboard.isDown("up") then
		direction.y = -1
	elseif love.keyboard.isDown("down") then
		direction.y = 1
	end

	-- if direction.x == 0 then self.actor.curSpeed.x = 0 end
	-- if direction.y == 0 then self.actor.curSpeed.y = 0 end

	self.actor:run(direction)
end

return Keyboard