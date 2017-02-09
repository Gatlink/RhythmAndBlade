local Point = {}
Point.__index = Point

Point.new = function (x, y)
	local new = {}
	new.x = x
	new.y = y

	setmetatable(new, Point)
	return new
end

Point.sqrdistance = function (self, x, y)
	return (self.x - x)^2 + (self.y - y)^2
end

Point.move = function (self, dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

return Point