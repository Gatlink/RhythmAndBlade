ControllerBase = require('scripts/controllers/ControllerBase')
Vector = require('scripts/Vector')

local AXIS_THRESHOLD = 0.5

local GamePad = ControllerBase.new()
local joystick
local wasPressed = {}

GamePad.load = function (self, actor)
	local joysticks = love.joystick.getJoysticks()
	joystick = joysticks[1]
end

GamePad.update = function (self, actor)
	if not self.active or not joystick or not joystick:isGamepad() then
		actor.targetSpeed.x = 0
		actor.curSpeed.x = 0
		return
	end

	local axis = joystick:getGamepadAxis("leftx")
	local direction = axis < 0 and -1 or 1
	if math.abs(axis) < AXIS_THRESHOLD then
		direction = 0
	end

	actor:move(Vector.new(direction, 0))

	local isJumpDown = joystick:isDown(1)
	local justPressedJump = isJumpDown and not wasPressed[1]
	if actor.grounded and justPressedJump then
		actor:jump()
	end
	wasPressed[1] = isJumpDown
end

return GamePad