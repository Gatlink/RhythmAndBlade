local AXIS_THRESHOLD = 0.5

local GamePad = {}
GamePad.__index = GamePad
setmetatable(GamePad, ControllerBase)

GamePad.new = function (actor)
	local new = ControllerBase.new(actor)

	new.joystick = nil
	new.wasPressed = {}

	setmetatable(new, GamePad)
	return new
end

GamePad.load = function (self)
	local joysticks = love.joystick.getJoysticks()
	self.joystick = joysticks[1]
end

GamePad.update = function (self)
	if not self.active or not self.joystick or not self.joystick:isGamepad() then
		self.actor.targetSpeed.x = 0
		self.actor.curSpeed.x = 0
		return
	end

	local axis = self.joystick:getGamepadAxis("leftx")
	local direction = axis < 0 and -1 or 1
	if math.abs(axis) < AXIS_THRESHOLD then
		direction = 0
	end

	self.actor:run(Vector.new(direction, 0))

	local isJumpDown = self.joystick:isDown(1)
	local justPressedJump = isJumpDown and not self.wasPressed[1]
	if self.actor.grounded and justPressedJump then
		self.actor:jump()
	end
	self.wasPressed[1] = isJumpDown
end

return GamePad