local ControllerBase = require('scripts/controllers/ControllerBase')
local Vector = require('scripts/Vector')

local ACCELERATION = 500

local Keyboard = ControllerBase.new()

Keyboard.update = function (self, actor)
	if not self.active then
		actor.acceleration:set(0, 0)
		actor.velocity:set(0, 0)
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

	if direction.x == 0 then actor.velocity.x = 0 end
	if direction.y == 0 then actor.velocity.y = 0 end

	actor:Move(direction)
end

return Keyboard