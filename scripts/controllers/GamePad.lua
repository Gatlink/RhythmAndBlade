local AXIS_THRESHOLD = 0.5

local GamePad = {}
GamePad.__index = GamePad
setmetatable(GamePad, ControllerBase)

GamePad.defenseMapping = {}

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

	self.defenseMapping[Sound.soundTypes.up] = 'y'
	self.defenseMapping[Sound.soundTypes.down] = 'a'
	self.defenseMapping[Sound.soundTypes.left] = 'x'
	self.defenseMapping[Sound.soundTypes.right] = 'b'
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
	
	if self.actor.defend ~= nil then
		self.actor:defend(self.joystick:getGamepadAxis("triggerright") > AXIS_THRESHOLD)
	end

	if self.actor.defenseActivated and self.actor.defend and self.actor.defendAgainst then
		for _, sound in pairs(Sound.soundTypes) do
			if self.joystick:isGamepadDown(self.defenseMapping[sound]) then
				self.actor:defendAgainst(sound)
			end
		end
	else
		local isJumpDown = self.joystick:isGamepadDown('a')
		local justPressedJump = isJumpDown and not self.wasPressed[1]
		if self.actor.grounded and justPressedJump then
			self.actor:jump()
		end
		self.wasPressed[1] = isJumpDown
	end
end

return GamePad