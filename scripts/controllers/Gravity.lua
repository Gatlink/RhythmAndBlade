local ControllerBase = require('scripts/controllers/ControllerBase')
local Rail = require('scripts/Rail')

local Gravity = ControllerBase.new()

local RAIL_ATTRACTION = 3
local G = 9.81
local MASS = 10

Gravity.update = function (self, actor)
	if not self.active then
		actor.acceleration.y = 0
		actor.velocity.y = 0
		grounded = true
		return
	end

	local railProj = Rail.getRailProjection(actor.position)
	if actor.railConnector:sqrdistance(railProj) <= RAIL_ATTRACTION^2 then
		local delta = railProj - actor.railConnector
		actor:move(delta:unpack())
		actor.acceleration.y = 0
		actor.velocity.y = 0
		grounded = true
	else
		grounded = false
	end

	if not grounded then
		actor.acceleration.y = G * MASS
	end
end

return Gravity
