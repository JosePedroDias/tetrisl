local T = require("src.tetris")
local utils = require("src.utils")

local G = love.graphics

local state = {t = 0, brickIdx = 1, brickVar = 1}

function love.load()
  -- print("started")
  -- require("src.tests")
end

function love.draw()
  T.drawBoard()

  -- T.drawCell(1, 0, 0)

  T.drawBrick({0, 0}, state.brickIdx, state.brickVar)

  G.setColor(1, 1, 1, 1)
  G.print("t:" .. utils.to_fixed(state.t) .. ", idx: " .. state.brickIdx .. ", var: " .. state.brickVar)
end

function love.update(dt)
  state.t = state.t + dt
end

function love.keypressed(key, scancode, is_repeat)
  if is_repeat then
    return
  elseif key == "up" then
    state.brickIdx = utils.minus(state.brickIdx, 1, #T.BRICKS)
    state.brickVar = 1
  elseif key == "down" then
    state.brickIdx = utils.plus(state.brickIdx, 1, #T.BRICKS)
    state.brickVar = 1
  elseif key == "left" then
    state.brickVar = utils.minus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  elseif key == "right" then
    state.brickVar = utils.plus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  elseif key == "escape" then
    love.event.quit()
  end
end

function love.keyreleased(key, scancode)
end
