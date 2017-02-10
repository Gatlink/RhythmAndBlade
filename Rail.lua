local Vector = require('Vector')

local Rail = {}
Rail.__index = Rail

local DEFAULT_SIZE = 100

Rail.all = {}

Rail.new = function (x, y)
	local halfSize = DEFAULT_SIZE * 0.5
	local new = {}
	new.points = type(x) == 'table' and x or {
		Vector.new(x - halfSize, y),
		Vector.new(x + halfSize, y),
	}

	table.insert(Rail.all, new)
	setmetatable(new, Rail)
	return new
end

Rail.deserialize = function (data)
	local points = {}

	for x, y in string.gmatch(data, '(%d+),(%d+);') do
		if x ~= nil and y ~= nil then
			table.insert(points, Vector.new(x, y))
		end
	end

	if # points > 0 then
		Rail.new(points)
	end
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

Rail.serialize = function (self, x, y)
	local data = ''

	for _, point in ipairs(self.points) do
		data = data .. point.x .. ',' .. point.y .. ';'
	end

	return data
end

return Rail
