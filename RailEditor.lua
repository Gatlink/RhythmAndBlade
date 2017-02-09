local Rail = require('Rail')

local RailEditor = {}

local POINT_RADIUS = 5

local movingIndex
local movingPointIndex

RailEditor.update = function (dt)
	
end

RailEditor.draw = function ()
	for _, rail in ipairs(Rail.all) do
		love.graphics.setColor(150, 218, 254)
		for _, point in ipairs(rail.points) do
			love.graphics.circle("line", point.x, point.y, POINT_RADIUS)
		end
	end
end

RailEditor.mousepressed = function (x, y, button)
	if button ~= 1 then
		return
	end

	movingIndex = nil
	movingPointIndex = nil
	for i, rail in ipairs(Rail.all) do
		for j, point in ipairs(rail.points) do
			if point:sqrdistance(x, y) <= POINT_RADIUS^2 then
				movingIndex = i
				movingPointIndex = j
			end
		end
	end
end

RailEditor.mousemoved = function (dx, dy)
	if movingIndex ~= nil then
		Rail.all[movingIndex].points[movingPointIndex]:move(dx, dy)
	end
end

RailEditor.mousereleased = function (x, y, button)
	if button ~= 1 then
		return
	end

	movingIndex = nil
	movingPointIndex = nil
end

return RailEditor
