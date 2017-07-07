local PlaySoundContinuously = {}
PlaySoundContinuously.__index = PlaySoundContinuously
setmetatable(PlaySoundContinuously, ControllerBase)

PlaySoundContinuously.new = function (actor)
	local new = ControllerBase.new(actor)

	new.delay = 3
	new.timer = new.delay

	setmetatable(new, PlaySoundContinuously)
	return new
end

PlaySoundContinuously.update = function (self, dt)
	self.timer = self.timer - dt

	if self.timer <= 0 then
		self.actor:playSound(Sound.getRandomSound())
		self.timer = self.delay
	end
end

return PlaySoundContinuously