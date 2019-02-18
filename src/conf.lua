local consts = require "src.consts"

love.conf = function(t)
  t.modules.joystick = false
  t.modules.physics = false
  t.window.width = consts.W
  t.window.height = consts.H
  t.window.title = "tetris"
end
