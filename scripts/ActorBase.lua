local Vector = require('scripts/Vector')
local Rail = require('scripts/Rail')

local ActorBase = {}
ActorBase.__index = ActorBase

local DEFAULT_RADIUS = 10
local VERTICAL_MAX_SPEED = 100
local HORIZONTAL_MAX_SPEED = 150
local MIN_SPEED_THRESHOLD = 1

ActorBase.all = {}

ActorBase.new = function (x, y, unlist)
	local new = {}
	new.position = Vector.new(x or 400, y or 300)
	new.radius = DEFAULT_RADIUS
	new.railConnector = Vector.new(new.position.x, new.position.y + new.radius)
	new.grounded = false
	
	new.a = 0.2
	new.curSpeed = Vector.new()
	new.targetSpeed = Vector.new()
	new.maxSpeed = Vector.new(HORIZONTAL_MAX_SPEED, VERTICAL_MAX_SPEED)
	new.railAttraction = 3

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

ActorBase.addController = function (self, controller)
	for i, ctrlr in ipairs(self.controllers) do
		if controller.executionOrder < ctrlr.executionOrder then
			table.insert(self.controllers, i, controller)
			return
		end
	end

	table.insert(self.controllers, controller)
end

-- ACTIONS

ActorBase.Fall = function (self)
	local railProj = Rail.getRailProjection(self.position)
	if self.railConnector:sqrdistance(railProj) <= self.railAttraction ^ 2 then
		local delta = railProj - self.railConnector
		self:move(delta:unpack())
		self.targetSpeed.y = 0
		self.curSpeed.y = 0
		grounded = true
	else
		grounded = false
	end

	if not grounded then
		self.targetSpeed.y = self.maxSpeed.y
	end
end

ActorBase.Move = function (self, direction)
	self.targetSpeed.x = direction.x * self.maxSpeed.x
	self.targetSpeed.y = direction.y * self.maxSpeed.y	
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
	self.curSpeed = self.targetSpeed * self.a + self.curSpeed * (1 - self.a)
	if math.abs(self.curSpeed.x) < MIN_SPEED_THRESHOLD then self.curSpeed.x = 0 end
	if math.abs(self.curSpeed.y) < MIN_SPEED_THRESHOLD then self.curSpeed.y = 0 end

	self:move((self.curSpeed * dt):unpack())
end

ActorBase.draw = function (self)
	love.graphics.setColor(200, 191, 231)
	love.graphics.circle('fill', self.position.x, self.position.y, self.radius)
end

return ActorBase