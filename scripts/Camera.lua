local ActorBase = require('scripts/ActorBase')
local Keyboard = require('scripts/controllers/Keyboard')

local Camera = ActorBase.new(400, 300, true)
table.insert(Camera.controllers, Keyboard)

Camera.horizontalMaxSpeed = 300
Camera.verticalMaxSpeed = 300
Camera.groundAcceleration = 500

Camera.preDraw = function (self)
	love.graphics.push()
	love.graphics.translate(400 - self.position.x, 300 - self.position.y)
end

Camera.postDraw = function (self)
	love.graphics.pop()
end

-- LOVE CALLBACKS
Camera.draw = function (self)
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle('fill', self.position.x, self.position.y, 5)
end

return Camera
