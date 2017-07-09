local Player = ActorBase.new(50, 50)
Player:addController(Gravity.new(Player))
Player:addController(GamePad.new(Player))

Player.defenseActivated = false
Player.defenseRadius = 12
Player.defenseDistance = 30

-- ACTIONS
Player.defend = function (self, active)
	self.defenseActivated = active
end

Player.defendAgainst = function (self, soundType)
	for _, sound in ipairs(Sound.all) do
		local sqrDistance = sound.buttonPosition:sqrdistance(self.position)
		local minDistance = self.defenseDistance - self.defenseRadius
		local maxDistance = self.defenseDistance + self.defenseRadius

		if sound.type == soundType
		and sqrDistance >= minDistance * minDistance
		and sqrDistance <= maxDistance * maxDistance then
			sound:validate()
		end
	end
end

-- LOVE
Player.draw = function (self)
	ActorBase.draw(self)

	if not self.defenseActivated then return end

	local oldWidth = love.graphics.getLineWidth()
	love.graphics.setLineWidth(3)

	love.graphics.setColor(225, 225, 225)
	love.graphics.circle('line', self.position.x, self.position.y, self.defenseDistance)

	for _, sound in ipairs(Sound.all) do
		local buttonPos = self.position + (sound.position - self.position):normalized() * self.defenseDistance
		love.graphics.circle('fill', buttonPos.x, buttonPos.y, self.defenseRadius)
	end

	love.graphics.setLineWidth(oldWidth)
end

return Player