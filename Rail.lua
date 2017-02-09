local Point = require('Point')

local Rail = {}
Rail.__index = Rail

local DEFAULT_SIZE = 100

Rail.all = {}

Rail.new = function (x, y)
	local halfSize = DEFAULT_SIZE * 0.5
	local new = {}
	new.points = {
		Point.new(x - halfSize, y),
		Point.new(x + halfSize, y),
	}

	table.insert(Rail.all, new)
	setmetatable(new, Rail)
	return new
end

Rail.draw = function (self)
	love.graphics.line(self:unpackPoints())
end

Rail.unpackPoints = function (self)
	local points = {}
	for _, point in ipairs(self.points) do
		table.insert(points, point.x)
		table.insert(points, point.y)
	end
	return unpack(points)
end

Rail.move = function (self, x, y)
	for _, point in ipairs(self.points) do
		point.x = point.x + x
		point.y = point.y + y
	end
end

return Rail
