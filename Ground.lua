local Point = require('Point')

local Ground = {}
Ground.__index = Ground

local DEFAULT_SIZE = 100

Ground.all = {}

Ground.new = function (x, y)
	local halfSize = DEFAULT_SIZE * 0.5
	local new = {}
	new.points = {
		Point.new(x - halfSize, y - halfSize),
		Point.new(x + halfSize, y - halfSize),
		Point.new(x + halfSize, y + halfSize),
		Point.new(x - halfSize, y + halfSize)
	}

	setmetatable(new, Ground)
	new.triangles = love.math.triangulate(new:unpackPoints())

	table.insert(Ground.all, new)
	return new
end

Ground.draw = function (self)
	for _, triangle in ipairs(self.triangles) do
		love.graphics.polygon('fill', triangle)
	end
end

Ground.contains = function (self, x, y)
	for _, triangle in ipairs(self.triangles) do
		-- barycentric coordinate
		local x1, y1, x2, y2, x3, y3 = unpack(triangle)
		local alpha = ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
		local beta = ((y3 - y1) * (x - x3) + (x1 - x3) * (y - y3)) / ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
		local gamma = 1 - alpha - beta

		if alpha > 0 and beta > 0 and gamma > 0 then
			return true
		end
	end

	return false
end

Ground.unpackPoints = function (self)
	local points = {}
	for _, point in ipairs(self.points) do
		table.insert(points, point.x)
		table.insert(points, point.y)
	end
	return unpack(points)
end

Ground.move = function (self, x, y)
	for _, point in ipairs(self.points) do
		point.x = point.x + x
		point.y = point.y + y
	end

	self.triangles = love.math.triangulate(self:unpackPoints())
end

return Ground
