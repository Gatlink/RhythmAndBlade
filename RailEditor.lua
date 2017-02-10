local Vector = require('Vector')
local Rail = require('Rail')

local RailEditor = {}

local POINT_RADIUS = 5
local MAX_ANGLE = 30

local selectedIndex
local selectedPointIndex
local dragging = false

local addPoint = function (x, y)
	local rail = Rail.all[selectedIndex]
	local point = rail.points[selectedPointIndex]
	
	local newIndex = point.x > x and selectedPointIndex or selectedPointIndex + 1
	
	table.insert(rail.points, newIndex, Vector.new(x, y))
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
	
	selectedIndex = newIndex
	selectedPointIndex = newPointIndex
end

RailEditor.mousemoved = function (x, y, dx, dy)
	if selectedIndex ~= nil and dragging then
		local prev = Rail.all[selectedIndex].points[selectedPointIndex - 1]
		local current = Rail.all[selectedIndex].points[selectedPointIndex]

		local angle = 0
		if prev ~= nil then
			-- keep horizontal
			if love.keyboard.isDown('lctrl') then
				y = prev.y
			else
				-- check angle
				local mouse = Vector.new(x, y)
				local prevToMouse = mouse - prev
				angle = prevToMouse:angle(Vector.right)
				if angle > MAX_ANGLE or angle < -MAX_ANGLE then
					local prevToCurrent = current - prev
					x, y = (prev + prevToMouse:projectOn(prevToCurrent)):unpack()
				end
			end
		end
		
		current:set(x, y)
	end
end

RailEditor.mousereleased = function (x, y, button)
	if button ~= 1 then
		return
	end

	dragging = false
end

return RailEditor
