local Vector = require('scripts/Vector')

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
			table.insert(points, Vector.new(tonumber(x), tonumber(y)))
		end
	end

	if # points > 0 then
		Rail.new(points)
	end
end

Rail.getRailProjection = function (pos)
	local points = {}
	for _, rail in ipairs(Rail.all) do
		table.insert(points, rail:getClosestPointOnRail(pos))
	end

	local point
	local lastDis = math.huge
	for _, p in ipairs(points) do
		local curDis = p:sqrdistance(pos)
		if p.y >= pos.y and curDis < lastDis then
			point = p
			lastDis = curDis
		end
	end

	return point
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

Rail.getClosestPointOnRail = function (self, pos)
	if # self.points < 2 then
		return nil
	end

	local points = {}
	for i=1, # self.points - 1 do
		local prev, next = self.points[i], self.points[i + 1]
		if (prev.x <= pos.x and next.x >= pos.x)
		or (prev.x >= pos.x and next.x <= pos.x) then
			local prevToNext = next - prev
			local prevToPos = pos - prev
			table.insert(points, prevToPos:projectOn(prevToNext) + prev)
		end
	end

	local closest
	local lastSqrDistance = math.huge
	for _, point in ipairs(points) do
		local currentSqrDistance = point:sqrdistance(pos)
		if closest == nil or currentSqrDistance < lastSqrDistance then
			closest = point
			lastSqrDistance = currentSqrDistance
		end
	end

	return closest
end

return Rail