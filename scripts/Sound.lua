local Vector = require('script/Vector')

local Sound = {}
Sound.__index = Sound

Sound.soundType = {
	up = { color = {232, 181, 65} },
	down = { color = {0, 225, 0} },
	left = { color = {0, 0, 225} },
	right = { color = {225, 0, 0} }
}

Sound.new = function (type, color, player, x, y)
	local new = {}

	new.position = Vector.new(x or 0, y or 0)
	new.color = type.color
	new.player = player
	new.growthSpeed = 300
	new.radius = 0

	setmetatable(new, Sound)
	return new
end

Sound.update = function (self, dt)
	radisu 
end

Sound.draw = function (self)
	local oldWidth = love.graphics.getLineWidth()
	love.graphics.setLineWidth(3)

	love.graphics.setColor(self.color)
	love.graphics.circle('line', self.position.x, self.position.y, self.radius)

	local direction = (self.player.position - self.position):normalize() * self.radius


	love.graphics.setLineWidth(oldWidth)
end