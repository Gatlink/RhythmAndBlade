local ControllerBase = require('scripts/controllers/ControllerBase')
local Vector = require('scripts/Vector')

local Keyboard = ControllerBase.new()

Keyboard.update = function (self, actor)
	if not self.active then
		actor.targetSpeed:set(0, 0)
		actor.curSpeed:set(0, 0)
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

	if direction.x == 0 then actor.curSpeed.x = 0 end
	if direction.y == 0 then actor.curSpeed.y = 0 end

	actor:run(direction)
end

return Keyboard