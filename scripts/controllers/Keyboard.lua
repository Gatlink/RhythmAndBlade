local ControllerBase = require('scripts/controllers/ControllerBase')

local ACCELERATION = 500

local Keyboard = ControllerBase.new()

Keyboard.update = function (self, actor)
	if not self.active then
		actor.acceleration:set(0, 0)
		actor.velocity:set(0, 0)
		return
	end

	local direction = 0
	if love.keyboard.isDown("left") then
		direction = -1
	elseif love.keyboard.isDown("right") then
		direction = 1
	end

	actor.acceleration.x = direction * ACCELERATION
	if actor.acceleration.x == 0 then actor.velocity.x = 0 end

	direction = 0
	if love.keyboard.isDown("up") then
		direction = -1
	elseif love.keyboard.isDown("down") then
		direction = 1
	end
	
	actor.acceleration.y = direction * ACCELERATION
	if actor.acceleration.y == 0 then actor.velocity.y = 0 end
end

return Keyboard