local Vector = require('scripts/Vector')

local ActorBase = {}
ActorBase.__index = ActorBase

local DEFAULT_RADIUS = 10

ActorBase.all = {}

ActorBase.new = function (x, y)
	local new = {}
	new.position = Vector.new(x or 400, y or 300)
	new.radius = DEFAULT_RADIUS
	new.railConnector = Vector.new(new.position.x, new.position.y + new.radius)

	setmetatable(new, ActorBase)
	table.insert(ActorBase.all, new)
	return new
end

-- ACTIONS

ActorBase.move = function (self, direction)
	-- direction: -1 <- 0 -> 1
end

-- LOVE CALLBACKS

ActorBase.update = function (self, dt)

end

ActorBase.draw = function (self)
	love.graphics.setColor(200, 191, 231)
	love.graphics.circle('fill', self.position.x, self.position.y, self.radius)
end

return ActorBase