local Vector = require('script/Vector')
local Player = require('scripts/Player')

local Sound = {}
Sound.__index = Sound

Sound.soundType = {
	up = { color = {232, 181, 65} },
	down = { color = {0, 225, 0} },
	left = { color = {0, 0, 225} },
	right = { color = {225, 0, 0} }
}

Sound.new = function (type, x, y)
	local new = {}

	new.position = Vector.new(x or 0, y or 0)
	new.color = type.color
	new.player = player
	new.growthSpeed = 300
	new.radius = 0
	new.detectionRadius = 30

	setmetatable(new, Sound)
	return new
end

Sound.update = function (self, dt)
	self.radius = self.radius + self.growthSpeed * dt
end

Sound.draw = function (self)
	local oldWidth = love.graphics.getLineWidth()
	love.graphics.setLineWidth(3)

	love.graphics.setColor(self.color)
	love.graphics.circle('line', self.position.x, self.position.y, self.radius)

	local buttonPos = (Player.position - self.position):normalize() * self.radius
	love.graphics.circle('fill', buttonPos:unpack(), self.detectionRadius)

	love.graphics.setLineWidth(oldWidth)
end