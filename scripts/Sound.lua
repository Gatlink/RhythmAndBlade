local Sound = {}
Sound.__index = Sound

Sound.soundTypes = {
	up = { color = {232, 181, 65} },
	down = { color = {0, 225, 0} },
	left = { color = {0, 0, 225} },
	right = { color = {225, 0, 0} }
}

Sound.all = {}

local MAX_RADIUS = 500

Sound.new = function (type, x, y)
	local new = {}

	new.position = Vector.new(x or 0, y or 0)
	new.color = type.color
	new.player = player
	new.growthSpeed = 100
	new.radius = 0
	new.detectionRadius = 10
	new.index = # Sound.all + 1

	setmetatable(new, Sound)
	table.insert(Sound.all, new)
	return new
end

Sound.update = function (self, dt)
	self.radius = self.radius + self.growthSpeed * dt

	if self.radius >= MAX_RADIUS then
		table.remove(Sound.all, self.index)
		self = nil
	end
end

Sound.draw = function (self)
	local oldWidth = love.graphics.getLineWidth()
	love.graphics.setLineWidth(3)

	love.graphics.setColor(self.color)
	love.graphics.circle('line', self.position.x, self.position.y, self.radius)

	local buttonPos = self.position + (Player.position - self.position):normalized() * self.radius
	love.graphics.circle('fill', buttonPos.x, buttonPos.y, self.detectionRadius)

	love.graphics.setLineWidth(oldWidth)
end


Sound.getRandomSound = function ()
	local types = {}
	for key, value in pairs(Sound.soundTypes) do
		table.insert(types, value)
	end

	return types[love.math.random(1, # types)]
end

return Sound