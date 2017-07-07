local ControllerBase = require('scripts/controllers/ControllerBase')

local PlaySoundContinuously = {}
PlaySoundContinuously.__index = PlaySoundContinuously
setmetatable(PlaySoundContinuously, ControllerBase)

PlaySoundContinuously.new = function (actor)
	local new = ControllerBase.new(actor)

	new.delay = 5
	new.timer = new.delay

	setmetatable(new, PlaySoundContinuously)
	return new
end

PlaySoundContinuously.update = function (self, dt)
	self.delay = self.delay - dt

	if self.delay <= 0 then
		self.actor:playSound()
	end
end

return PlaySoundContinuously