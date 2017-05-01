local ActorBase = require('scripts/ActorBase')
local Keyboard = require('scripts/controllers/Keyboard')

local Camera = ActorBase.new(400, 300, true)
table.insert(Camera.controllers, Keyboard)

Camera.horizontalMaxSpeed = 300
Camera.verticalMaxSpeed = 300
Camera.groundAcceleration = 500

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
	love.graphics.translate(self:getTranslation())
end

Camera.postDraw = function (self)
	love.graphics.pop()
end

-- LOVE CALLBACKS
Camera.draw = function (self)
	love.graphics.setColor(255, 0, 0)
	love.graphics.line(self.position.x - 10, self.position.y, self.position.x + 10, self.position.y)
	love.graphics.line(self.position.x, self.position.y - 10, self.position.x, self.position.y + 10)
end

return Camera