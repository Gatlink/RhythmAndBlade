local Rail = require('Rail')

local Editor = {}

Editor.save = function ()
	-- save rails
	local rails = ''
	for _, rail in ipairs(Rail.all) do
		rails = rails .. rail:serialize() .. '\n'
	end

	love.filesystem.write('save0', rails)
end

Editor.load = function ()
	Rail.all = {}
	local data, length = love.filesystem.read('save0')

	if length == 0 or data == nil then
		return false
	end

	for line in string.gmatch(data, '(%S+)%s') do
		Rail.deserialize(line)
	end

	return true
end

-- LOVE CALLBACKS --

Editor.keypressed = function (key)
	if love.keyboard.isDown('lctrl') then
		if key == 's' then
			Editor.save()
		elseif key == 'o' then
			Editor.load()
		end
	end
end

return Editor