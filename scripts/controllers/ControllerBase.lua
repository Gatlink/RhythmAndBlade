local ControllerBase = {}
ControllerBase.__index = ControllerBase

ControllerBase.executionOrder = 0

ControllerBase.new = function (actor)
	local new = {}
	new.active = true
	new.actor = actor

	setmetatable(new, ControllerBase)
	return new
end

ControllerBase.load = function (self) end
ControllerBase.update = function (self) end

return ControllerBase