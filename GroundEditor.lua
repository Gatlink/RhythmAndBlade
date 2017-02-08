local Ground = require('Ground')

local GroundEditor = {}

local POINT_RADIUS = 5

local selectedIndex
local dragging = false

GroundEditor.update = function (dt)
	
end

GroundEditor.draw = function ()
	if GroundEditor.selectedIndex ~= nil then
		local ground = Ground.all[GroundEditor.selectedIndex]

		love.graphics.setColor(150, 218, 254)
		love.graphics.polygon('line', ground:unpackPoints())

		for _, point in ipairs(ground.points) do
			love.graphics.circle("fill", point.x, point.y, POINT_RADIUS)
		end
	end
end

GroundEditor.mousepressed = function (x, y, button)
	if button ~= 1 then
		return
	end

	GroundEditor.selectedIndex = nil
	for i, ground in ipairs(Ground.all) do
		if ground:contains(x, y) then
			GroundEditor.selectedIndex = i
			dragging = true
			return
		end
	end
end

GroundEditor.mousemoved = function (dx, dy)
	if dragging and GroundEditor.selectedIndex ~= nil then
		Ground.all[GroundEditor.selectedIndex]:move(dx, dy)
	end
end

GroundEditor.mousereleased = function (x, y, button)
	if button ~= 1 then
		return
	end

	dragging = false
end

return GroundEditor
