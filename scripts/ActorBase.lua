local Vector = require('scripts/Vector')
local Rail = require('scripts/Rail')

local ActorBase = {}
ActorBase.__index = ActorBase

local DEFAULT_RADIUS = 10
local RAIL_ATTRACTION = 3
local MAX_DOWNWARD_SPEED = 100

ActorBase.all = {}

ActorBase.new = function (x, y)
	local new = {}
	new.position = Vector.new(x or 400, y or 300)
	new.radius = DEFAULT_RADIUS
	new.railConnector = Vector.new(new.position.x, new.position.y + new.radius)
	new.grounded = false
	new.acceleration = Vector.new()
	new.velocity = Vector.new()

	new.controllers = {}

	setmetatable(new, ActorBase)
	table.insert(ActorBase.all, new)
	return new
end

-- Utility

ActorBase.move = function (self, dx, dy)
	self.position:add_inplace(dx, dy)
	self.railConnector:add_inplace(dx, dy)
end

ActorBase.toggleActiveControllers = function (self)
	for _, controller in ipairs(self.controllers) do
		controller.active = not controller.active
	end
end

-- ACTIONS

ActorBase.fall = function (self, gravity)
	local railProj = Rail.getRailProjection(self.position)
	if self.railConnector:sqrdistance(railProj) <= RAIL_ATTRACTION^2 then
		local delta = railProj - self.railConnector
		self:move(delta:unpack())
		self.acceleration.y = 0
		self.velocity.y = 0
		grounded = true
	else
		grounded = false
	end

	if not grounded then
		self.acceleration:add_inplace(0, gravity)
	end
end

-- LOVE CALLBACKS

ActorBase.update = function (self, dt)
	-- Controllers
	for _, controller in ipairs(self.controllers) do
		controller:update(self)
	end

	-- Update
	self.velocity = self.velocity + self.acceleration * dt

	if self.velocity.y > 0 then
		self.velocity.y = math.min(self.velocity.y, MAX_DOWNWARD_SPEED)
	end

	self:move((self.velocity * dt):unpack())
end

ActorBase.draw = function (self)
	love.graphics.setColor(200, 191, 231)
	love.graphics.circle('fill', self.position.x, self.position.y, self.radius)
end

return ActorBase