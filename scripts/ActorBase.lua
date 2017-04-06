local Vector = require('scripts/Vector')
local Rail = require('scripts/Rail')

local ActorBase = {}
ActorBase.__index = ActorBase

local DEFAULT_RADIUS = 10
local VERTICAL_MAX_SPEED = 100
local HORIZONTAL_MAX_SPEED = 150

ActorBase.all = {}

ActorBase.new = function (x, y, unlist)
	local new = {}
	new.position = Vector.new(x or 400, y or 300)
	new.radius = DEFAULT_RADIUS
	new.railConnector = Vector.new(new.position.x, new.position.y + new.radius)
	new.grounded = false
	new.acceleration = Vector.new()
	new.velocity = Vector.new()
	new.horizontalMaxSpeed = HORIZONTAL_MAX_SPEED
	new.verticalMaxSpeed = VERTICAL_MAX_SPEED

	new.railAttraction = 3
	new.mass = 10
	new.groundAcceleration = 60

	new.controllers = {}

	setmetatable(new, ActorBase)

	if not unlist then
		table.insert(ActorBase.all, new)
	end

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

ActorBase.Fall = function (self, g)
	local railProj = Rail.getRailProjection(self.position)
	if self.railConnector:sqrdistance(railProj) <= self.railAttraction ^ 2 then
		local delta = railProj - self.railConnector
		self:move(delta:unpack())
		self.acceleration.y = 0
		self.velocity.y = 0
		grounded = true
	else
		grounded = false
	end

	if not grounded then
		self.acceleration.y = g * self.mass
	end
end

ActorBase.Move = function (self, direction)
	self.acceleration = self.acceleration + direction * self.groundAcceleration
end

-- LOVE CALLBACKS

ActorBase.load = function (self)
	for _, controller in ipairs(self.controllers) do
		controller:load(self)
	end
end

ActorBase.update = function (self, dt)
	self.acceleration:set(0, 0)

	-- Controllers
	for _, controller in ipairs(self.controllers) do
		controller:update(self)
	end

	-- Update
	self.velocity = self.velocity + self.acceleration * dt

	if self.velocity.y > 0 then
		self.velocity.y = math.min(self.velocity.y, self.verticalMaxSpeed)
	elseif self.velocity.y < 0 then
		self.velocity.y = math.max(self.velocity.y, -self.verticalMaxSpeed)
	end

	if self.velocity.x > 0 then
		self.velocity.x = math.min(math.max(self.velocity.x, 0), self.horizontalMaxSpeed)
	elseif self.velocity.x < 0 then
		self.velocity.x = math.max(math.min(self.velocity.x, 0), -self.horizontalMaxSpeed)
	end

	self:move((self.velocity * dt):unpack())
end

ActorBase.draw = function (self)
	love.graphics.setColor(200, 191, 231)
	love.graphics.circle('fill', self.position.x, self.position.y, self.radius)
end

return ActorBase