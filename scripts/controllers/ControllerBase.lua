local ControllerBase = {}
ControllerBase.__index = ControllerBase

ControllerBase.new = function ()
	local new = {}
	new.active = true
	new.executionOrder = 0

	setmetatable(new, ControllerBase)
	return new
end

ControllerBase.load = function (self, actor) end
ControllerBase.update = function (self, actor) end

return ControllerBase