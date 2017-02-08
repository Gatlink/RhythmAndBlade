local Point = {}
Point.__index = Point

Point.new = function (x, y)
	local new = {}
	new.x = x
	new.y = y

	setmetatable(new, Point)
	return new
end

return Point