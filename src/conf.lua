-- [[ this is loaded by love2d and affects its runtime ]] --
-- https://love2d.org/wiki/Config_Files
love.conf = function(t)
  t.identity = "tetris"
  t.appendidentity = true
  t.highdpi = true
  t.accelerometerjoystick = false
  t.version = "11.0"
  t.externalstorage = true
  t.modules.joystick = false
  t.modules.physics = false

  t.window.width = 0
  t.window.height = 0

  -- t.window.width = 640
  -- t.window.height = 480

  t.window.title = "tetris"
end
