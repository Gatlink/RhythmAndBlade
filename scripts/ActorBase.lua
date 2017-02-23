local Vector = require('scripts/Vector')
local Rail = require('scripts/Rail')

local ActorBase = {}
ActorBase.__index = ActorBase

local DEFAULT_RADIUS = 10
local DOWNWARD_MAX_SPEED = 100
local HORIZONTAL_MAX_SPEED = 150

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

-- LOVE CALLBACKS

ActorBase.load = function (self)
	for _, controller in ipairs(self.controllers) do
		controller:load(self)
	end
end

ActorBase.update = function (self, dt)
	-- Controllers
	for _, controller in ipairs(self.controllers) do
		controller:update(self)
	end

	-- Update
	self.velocity = self.velocity + self.acceleration * dt

	if self.velocity.y > 0 then
		self.velocity.y = math.min(self.velocity.y, DOWNWARD_MAX_SPEED)
	end

	if self.velocity.x > 0 then
		self.velocity.x = math.min(math.max(self.velocity.x, 0), HORIZONTAL_MAX_SPEED)
	elseif self.velocity.x < 0 then
		self.velocity.x = math.max(math.min(self.velocity.x, 0), -HORIZONTAL_MAX_SPEED)
	end

	self:move((self.velocity * dt):unpack())
end

ActorBase.draw = function (self)
	love.graphics.setColor(200, 191, 231)
	love.graphics.circle('fill', self.position.x, self.position.y, self.radius)
end

return ActorBase