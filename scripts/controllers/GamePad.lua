ControllerBase = require('scripts/controllers/ControllerBase')
Vector = require('scripts/Vector')

local AXIS_THRESHOLD = 0.2

local GamePad = ControllerBase.new()
local joystick

GamePad.load = function (self, actor)
	local joysticks = love.joystick.getJoysticks()
	joystick = joysticks[1]
end

GamePad.update = function (self, actor)
	if not self.active or not joystick or not joystick:isGamepad() then
		actor.acceleration.x = 0
		actor.velocity.x = 0
		return
	end

	local axis = joystick:getGamepadAxis("leftx")
	local direction = axis < 0 and -1 or 1
	if math.abs(axis) < AXIS_THRESHOLD then
		direction = 0
		actor.velocity.x = 0
	end

	actor:Move(Vector.new(direction, 0))
end

return GamePad