local ControllerBase = require('scripts/controllers/ControllerBase')
local Rail = require('scripts/Rail')

local Gravity = {}
Gravity.__index = Gravity
setmetatable(Gravity, ControllerBase)

Gravity.executionOrder = 1

Gravity.new = function (actor)
	local new = ControllerBase.new(actor)

	setmetatable(new, Gravity)
	return new
end

Gravity.update = function (self)
	if not self.active then
		self.actor.targetSpeed.y = 0
		self.actor.curSpeed.y = 0
		self.actor.grounded = true
		return
	end

	self.actor:fall();
end

return Gravity
