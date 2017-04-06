local ControllerBase = require('scripts/controllers/ControllerBase')
local Rail = require('scripts/Rail')

local Gravity = ControllerBase.new()

local g = 9.81

Gravity.update = function (self, actor)
	if not self.active then
		actor.acceleration.y = 0
		actor.velocity.y = 0
		grounded = true
		return
	end

	actor:Fall(g);
end

return Gravity
