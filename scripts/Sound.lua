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
	new.buttonPosition = new.position
	new.type = type
	new.player = player
	new.growthSpeed = 100
	new.radius = 0
	new.detectionRadius = 10

	setmetatable(new, Sound)
	table.insert(Sound.all, new)
	return new
end

-- STATIC
Sound.getRandomSound = function ()
	local types = {}
	for key, value in pairs(Sound.soundTypes) do
		table.insert(types, value)
	end

	return types[love.math.random(1, # types)]
end

-- UTILS
Sound.destroy = function (self)
	for i, sound in ipairs(Sound.all) do
		if sound == self then
			table.remove(Sound.all, i)
			break
		end
	end
end

Sound.validate = function (self)
	Camera:flash()
	self:destroy()
end

-- LOVE CALLBACKS
Sound.update = function (self, dt)
	self.radius = self.radius + self.growthSpeed * dt
	self.buttonPosition = self.position + (Player.position - self.position):normalized() * self.radius

	local hitPlayer = (self.buttonPosition - Player.position):norm() <= Player.radius
	if hitPlayer then
		Camera:shake(Camera.shakeTypes.horizontal, 0.2, 0.3)
	end

	if self.radius >= MAX_RADIUS or hitPlayer then
		self:destroy()
	end
end

Sound.draw = function (self)
	local oldWidth = love.graphics.getLineWidth()
	love.graphics.setLineWidth(3)

	love.graphics.setColor(self.type.color)
	love.graphics.circle('line', self.position.x, self.position.y, self.radius)

	love.graphics.circle('fill', self.buttonPosition.x, self.buttonPosition.y, self.detectionRadius)

	love.graphics.setLineWidth(oldWidth)
end

return Sound