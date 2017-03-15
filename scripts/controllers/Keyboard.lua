local ControllerBase = require('scripts/controllers/ControllerBase')

local ACCELERATION = 100

local Keyboard = ControllerBase.new()

Keyboard.udpate = function (self, actor)
	if not self.active then
		actor.acceleration.x = 0
		actor.velocity.x = 0
		return
	end

	local direction = 0
	if love.keyboard.isDown("a") then
		direction = -1
	elseif love.keyboard.isDown("d") then
		direction = 1
	end
	actor.acceleration.x = direction * ACCELERATION

	direction = 0
	if love.keyboard.isDown("w") then
		direction = -1
	elseif love.keyboard.isDown("s") then
		direction = 1
	end
	actor.acceleration.y = direction * ACCELERATION
end

return Keyboard