local ActorBase = require('scripts/ActorBase')
local Gravity = require('scripts/controllers/Gravity')
local GamePad = require('scripts/controllers/GamePad')

local Player = ActorBase.new(50, 50)
Player:addController(Gravity.new(Player))
Player:addController(GamePad.new(Player))

return Player