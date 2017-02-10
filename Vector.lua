local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
	local new

    x = x or 0
    y = y or 0
    new = {x = x, y = y}

	setmetatable(new, Vector)
	return new
end

Vector.__tostring = function (self)
	return string.format("(%f, %f)", self.x, self.y)
end

Vector.__add = function (lhs, rhs)
	if type(rhs) == "number" then
		return Vector.new(lhs.x + rhs, lhs.y + rhs)
	else
		return Vector.new(lhs.x + rhs.x, lhs.y + rhs.y)
	end
end

Vector.__sub = function (lhs, rhs)
	if type(rhs) == "number" then
		return Vector.new(lhs.x - rhs, lhs.y - rhs)
	else
		return Vector.new(lhs.x - rhs.x, lhs.y - rhs.y)
	end
end

Vector.__unm = function (rhs)
  return Vector.new(-rhs.x, -rhs.y)
end

Vector.__mul = function (lhs, rhs)
	if type(rhs) == "number" then
		return Vector.new(lhs.x * rhs, lhs.y * rhs)
	end
end

function Vector:copy(oth)
  self.x = oth.x
  self.y = oth.y
end

function Vector:clone()
	local new = Vector.new()
	new:copy(self)

	return new
end

function Vector:norm()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:sqrNorm()
    return self.x * self.x + self.y * self.y
end

function Vector:normalized()
	local norm = self:norm()
	return Vector.new(self.x / norm, self.y / norm)
end

function Vector:dot(oth)
	return self.x * oth.x + self.y * oth.y
end

-- in degrees
function Vector:rotate(angle)
	angle = math.rad(angle)
	local cos, sin = math.cos(angle), math.sin(angle)
	return Vector.new(self.x * cos - self.y * sin, self.x * sin + self.y * cos)
end

-- in degrees
function Vector:angle(oth)
	if oth then 
		return math.deg(math.atan2(oth.y,oth.x) - math.atan2(self.y,self.x))
	else
	    return math.deg(math.atan2(self.y,self.x))
	end
end

function Vector:set(x, y)
    self.x, self.y = x, y
end

function Vector:add_inplace(x, y)
    self.x, self.y = self.x + x, self.y + y
end

function Vector:normal()
  return Vector.new(-self.y, self.x)
end

function Vector:det(oth)
  return self.x * oth.y - self.y * oth.x
end

function Vector:projectOn(oth)
  local normalizedOth = oth:normalized()
  return normalizedOth * self:dot(normalizedOth)
end

function Vector:lerp(oth, t)
	return Vector.new(math.lerp(self.x, oth.x, t), math.lerp(self.y, oth.y, t))
end

function Vector:nlerp(oth, t)
	return self:lerp(oth, t):normalized()
end

function Vector:unpack()
    return self.x, self.y
end

function Vector:sqrdistance(x, y)
	local oth = type(x) ~= "table" and Vector.new(x, y) or x
	return (self - oth):sqrNorm()
end

Vector.zero = Vector.new()
Vector.up = Vector.new(0, -1)
Vector.down = Vector.new(0, 1)
Vector.left = Vector.new(-1, 0)
Vector.right = Vector.new(1, 0)

return Vector
