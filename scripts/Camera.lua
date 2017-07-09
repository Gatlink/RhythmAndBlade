local Camera = ActorBase.new(400, 300, true)
table.insert(Camera.controllers, Keyboard.new(Camera))

Camera.shakeTypes = {
	both = 0,
	horizontal = 1,
	vertical = 2
}

Camera.maxSpeed = Vector.new(300, 300)
Camera.a = 1
Camera.ignoreWalls = true

local FLASH_DURATION = 0.1
Camera.flashColor = nil
Camera.flashTimer = 0

local MAX_SHAKE_INTENSITY = 50
Camera.shakeIntensity = 0
Camera.shakeTimer = 0
Camera.shakeType = 0

Camera.getRandomShakeOffset = function (self)
	 return (love.math.random() * 2 - 1) * self.shakeIntensity * MAX_SHAKE_INTENSITY
end

Camera.getTranslation = function (self)
	local width, height = love.graphics.getDimensions()
	return width * 0.5 - self.position.x, height * 0.5 - self.position.y
end

Camera.translate = function (self, x, y)
	local camX, camY = self:getTranslation()
	return x - camX, y - camY
end

Camera.preDraw = function (self)
	love.graphics.push()

	local x, y = self:getTranslation()

	if self.shakeTimer > 0 then
		if self.shakeType ~= Camera.shakeTypes.vertical then
			x = x + self:getRandomShakeOffset()
		end

		if self.shakeType ~= Camera.shakeTypes.horizontal then
			y = y + self:getRandomShakeOffset()
		end		
	end

	love.graphics.translate(x, y)
end

Camera.postDraw = function (self)
	love.graphics.pop()

	if self.flashTimer > 0 then
		local t = 2 * self.flashTimer / FLASH_DURATION - 1
		self.flashColor[4] = 255 * (- t * t + 1)
		love.graphics.setColor(self.flashColor)

		local width, height = love.graphics.getDimensions()
		local offset = MAX_SHAKE_INTENSITY
		love.graphics.rectangle('fill', -offset, -offset, width + offset, height + offset)
	end
end

-- LOVE CALLBACKS
Camera.update = function (self, dt)
	ActorBase.update(self, dt)

	if self.flashTimer > 0 then
		self.flashTimer = self.flashTimer - dt
	end

	if self.shakeTimer > 0 then
		self.shakeTimer = self.shakeTimer - dt
	end
end

Camera.draw = function (self)
	love.graphics.setColor(255, 0, 0)
	love.graphics.line(self.position.x - 10, self.position.y, self.position.x + 10, self.position.y)
	love.graphics.line(self.position.x, self.position.y - 10, self.position.x, self.position.y + 10)
end

-- EFFECTS
Camera.flash = function (self, color)
	self.flashColor = color or {255, 255, 255}
	self.flashTimer = FLASH_DURATION
end

Camera.shake = function (self, type, intensity, duration)
	self.shakeType = type
	self.shakeIntensity = intensity
	self.shakeTimer = duration
end

return Camera
