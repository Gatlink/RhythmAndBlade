local ControllerBase = require('scripts/controllers/ControllerBase')
local Rail = require('scripts/Rail')

local Gravity = ControllerBase.new()

Gravity.executionOrder = 1

Gravity.update = function (self, actor)
	if not self.active then
		actor.targetSpeed.y = 0
		actor.curSpeed.y = 0
		grounded = true
		return
	end

	actor:fall();
end

return Gravity
