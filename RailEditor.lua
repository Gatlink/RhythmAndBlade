local Point = require('Point')
local Rail = require('Rail')

local RailEditor = {}

local POINT_RADIUS = 5

local selectedIndex
local selectedPointIndex
local dragging = false

local addPoint = function (x, y)
	local rail = Rail.all[selectedIndex]
	local point = rail.points[selectedPointIndex]
	
	local newIndex = point.x > x and selectedPointIndex or selectedPointIndex + 1
	
	table.insert(rail.points, newIndex, Point.new(x, y))
	selectedPointIndex = newIndex
end

-- LOVE CALLBACKS --

RailEditor.update = function (dt)
	
end

RailEditor.draw = function ()
	for i, rail in ipairs(Rail.all) do
		for j, point in ipairs(rail.points) do
			if i == selectedIndex and j == selectedPointIndex then
				love.graphics.setColor(140, 194, 107)
			else
				love.graphics.setColor(150, 218, 254)
			end

			love.graphics.circle("line", point.x, point.y, POINT_RADIUS)
		end
	end
end

RailEditor.mousepressed = function (x, y, button)
	if button ~= 1 then
		return
	end

	local newIndex = nil
	local newPointIndex = nil
	for i, rail in ipairs(Rail.all) do
		for j, point in ipairs(rail.points) do
			if point:sqrdistance(x, y) <= POINT_RADIUS^2 then
				newIndex = i
				newPointIndex = j
				dragging = true
			end
		end
	end

	if newIndex == nil and selectedIndex ~= nil and love.keyboard.isDown('lshift') then
		addPoint(x, y)
	else
		selectedIndex = newIndex
		selectedPointIndex = newPointIndex
	end
end

RailEditor.mousemoved = function (dx, dy)
	if selectedIndex ~= nil and dragging then
		Rail.all[selectedIndex].points[selectedPointIndex]:move(dx, dy)
	end
end

RailEditor.mousereleased = function (x, y, button)
	if button ~= 1 then
		return
	end

	dragging = false
end

return RailEditor
