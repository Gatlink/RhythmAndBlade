local Gravity = {}

local g = 9.81

Gravity.active = true

Gravity.update = function (self, actor)
	if Gravity.active then
		actor:fall(g)
	end
end


return Gravity
