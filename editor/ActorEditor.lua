local ActorBase = require('scripts/ActorBase')
local Rail = require('scripts/Rail')

local ActorEditor = {}

local selected
local dragging = false

-- LOVE CALLBACKS

ActorEditor.draw = function ()
	if selected ~= nil then
		love.graphics.setColor(140, 194, 107)
		love.graphics.circle('line', selected.position.x, selected.position.y, selected.radius)

		love.graphics.setColor(190, 112, 119)
		love.graphics.circle('fill', selected.railConnector.x, selected.railConnector.y, 3)

		local proj = Rail.getRailProjection(selected.position)
		if proj ~= nil then
			love.graphics.setColor(255, 235, 235)
			love.graphics.circle('fill', proj.x, proj.y, 3)
		end
	end
end

ActorEditor.mousepressed = function (x, y, button)
	if button ~= 1 then
		return
	end

	selected = nil
	dragging = false
	for _, actor in ipairs(ActorBase.all) do
		if actor.position:sqrdistance(x, y) <= actor.radius^2 then
			selected = actor
			dragging = true
			selected:toggleActiveControllers()
			break
		end
	end
end

ActorEditor.mousemoved = function (x, y, dx, dy)
	if dragging and selected ~= nil then
		selected:translate(dx, dy)
	end
end

ActorEditor.mousereleased = function (x, y, button)
	if button == 1 then
		dragging = nil

		if selected ~= nil then
			selected:toggleActiveControllers()
		end
	end
end

ActorEditor.keypressed = function (key)
	if key == 'escape' then
		selected = nil
		dragging = false
	end
end

return ActorEditor