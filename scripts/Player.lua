local Player = ActorBase.new(50, 50)
Player:addController(Gravity.new(Player))
Player:addController(GamePad.new(Player))

return Player