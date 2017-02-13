local ActorBase = require('ActorBase')

local ActorEditor = {}

local selected

-- LOVE CALLBACKS

ActorEditor.draw = function ()
	if selected ~= nil then
		love.graphics.setColor(140, 194, 107)
		love.graphics.circle('line', selected.position.x, selected.position.y, selected.radius)

		love.graphics.setColor(190, 112, 119)
		love.graphics.circle('fill', selected.railConnector.x, selected.railConnector.y, 3)
	end
end

ActorEditor.mousepressed = function (x, y, button)
	if button ~= 1 then
		return
	end

	selected = nil
	for _, actor in ipairs(ActorBase.all) do
		if actor.position:sqrdistance(x, y) <= actor.radius^2 then
			selected = actor
		end
	end
end

return ActorEditor