local T = require("src.tetris")
local utils = require("src.utils")

local state = {t = 0, brickIdx = 1, brickVar = 1}

function love.load()
  print("started")

  -- require("src.tests")
end

function love.draw()
  T.drawBoard()

  --T.drawCell(1, 0, 0)

  T.drawBrick({0, 0}, state.brickIdx, state.brickVar)

  love.graphics.print("t:" .. utils.to_fixed(state.t) .. ", idx: " .. state.brickIdx .. ", var: " .. state.brickVar)
end

function love.update(dt)
  state.t = state.t + dt
end

function love.keypressed(key, scancode, is_repeat)
  if is_repeat then
    return
  elseif key == "left" then
    state.brickIdx = state.brickIdx - 1
  elseif key == "right" then
    state.brickIdx = state.brickIdx + 1
  elseif key == "up" then
    state.brickVar = state.brickVar - 1
  elseif key == "down" then
    state.brickVar = state.brickVar + 1
  elseif key == "escape" then
    love.event.quit()
  end
end

function love.keyreleased(key, scancode)
end
