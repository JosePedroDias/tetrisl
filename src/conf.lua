-- local consts = require "src.consts"

love.conf = function(t)
  t.modules.joystick = false
  t.modules.physics = false
  t.window.width = 0
  t.window.height = 0
  t.window.title = "tetris"
end
