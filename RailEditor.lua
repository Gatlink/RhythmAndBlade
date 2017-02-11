local Vector = require('Vector')
local Rail = require('Rail')

local RailEditor = {}

local POINT_MIN_DISTANCE = 50
local POINT_RADIUS = 5
local MAX_ANGLE = 30

local HORIZONTAL_KEY = "lctrl"
local WALL_KEY = "lshift"
local DELETE_KEY = "delete"
local ADD_POINT_KEY = "space"
local ADD_RAIL_KEY = "lalt"
local SELECT_RAIL_KEY = "a"
local UNSELECT_KEY = "escape"

local selectedIndex
local selectedPointIndex
local dragging = false
local railSelected = false

local addPoint = function (x, y)
	local rail = Rail.all[selectedIndex]
	local point = rail.points[selectedPointIndex]
	
	local newIndex = point.x > x and selectedPointIndex or selectedPointIndex + 1
	
	table.insert(rail.points, newIndex, Vector.new(x, y))
	selectedPointIndex = newIndex
end

local isSmthgSelected = function ()
	return selectedIndex ~= nil and selectedPointIndex ~= nil
end

-- LOVE CALLBACKS --

RailEditor.update = function (dt)
	
end

RailEditor.draw = function ()
	for i, rail in ipairs(Rail.all) do
		for j, point in ipairs(rail.points) do
			if i == selectedIndex and (j == selectedPointIndex or railSelected) then
				love.graphics.setColor(140, 194, 107)
			else
				love.graphics.setColor(150, 218, 254)
			end

			love.graphics.circle("line", point.x, point.y, POINT_RADIUS)

			local next = rail.points[j + 1]
			if next ~= nil and next.x == point.x then
				love.graphics.setColor(190, 112, 119)
				love.graphics.line(point.x, point.y, next.x, next.y)	
			end
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
				if i ~= selectedIndex then
					railSelected = false
				end

				newIndex = i
				newPointIndex = j
				dragging = true
				break
			end
		end
	end
	
	selectedIndex = newIndex
	selectedPointIndex = newPointIndex

	-- New rail
	if love.keyboard.isDown(ADD_RAIL_KEY) then
		Rail.new(x, y)
		selectedIndex = # Rail.all
		selectedPointIndex = # Rail.all[selectedIndex].points
		railSelected = true
	end
end

RailEditor.mousemoved = function (x, y, dx, dy)
	if isSmthgSelected() and dragging then
		local prev = Rail.all[selectedIndex].points[selectedPointIndex - 1]
		local current = Rail.all[selectedIndex].points[selectedPointIndex]
		local next = Rail.all[selectedIndex].points[selectedPointIndex + 1]

		-- move all
		if railSelected then
			local rail = Rail.all[selectedIndex]
			for _, point in ipairs(rail.points) do
				point:add_inplace(dx, dy)
			end
			return
		end

		-- keep horizontal
		if love.keyboard.isDown(HORIZONTAL_KEY) then
			if prev ~= nil then
				y = prev.y
			elseif next ~= nil then
				y = next.y
			end		
		end

		-- don't mess the order
		if prev ~= nil then
			x = math.max(prev.x + POINT_MIN_DISTANCE, x)
		end

		if next ~= nil then
			x = math.min(next.x - POINT_MIN_DISTANCE, x)
		end

		-- Wall
		if love.keyboard.isDown(WALL_KEY) then
			if prev ~= nil then
				x = prev.x
			elseif next ~= nil then
				x = next.x
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

RailEditor.keypressed = function (key)
	if key == ADD_POINT_KEY and isSmthgSelected() then
		local current = Rail.all[selectedIndex].points[selectedPointIndex]
		local next = Rail.all[selectedIndex].points[selectedPointIndex + 1]

		local x, y
		if next ~= nil then
			x, y = (current.x + next.x) * 0.5, (current.y + next.y) * 0.5
		else
			x, y = current.x + POINT_MIN_DISTANCE * 2, current.y
		end
		
		selectedPointIndex = selectedPointIndex + 1
		table.insert(Rail.all[selectedIndex].points, selectedPointIndex, Vector.new(x, y))
	elseif key == DELETE_KEY and isSmthgSelected() then
		if railSelected then
			table.remove(Rail.all, selectedIndex)
		elseif # Rail.all[selectedIndex].points >= 3 then
			table.remove(Rail.all[selectedIndex].points, selectedPointIndex)
		end

		selectedIndex = nil
		selectedPointIndex = nil
		railSelected = false
	elseif key == SELECT_RAIL_KEY and isSmthgSelected() then
		railSelected = true
	elseif key == UNSELECT_KEY then
		railSelected = false
		selectedIndex = false
		selectedPointIndex = false
	end
end

return RailEditor
