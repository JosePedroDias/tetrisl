local T = require "src.tetris"
local utils = require "src.utils"

local G = love.graphics

local state = {t = 0, brickIdx = 2, brickVar = 1, board = T.randomBoard(), x = 0, y = 0}

function love.load()
  -- print("started")
  -- require "src.udpClient2"
end

function love.draw()
  T.drawBoardBackground()

  T.drawBoard(state.board)

  T.drawBrick({state.x, state.y}, state.brickIdx, state.brickVar)

  G.setColor(1, 1, 1, 1)
  G.print("t:" .. utils.toFixed(state.t, 2) .. ", idx: " .. state.brickIdx .. ", var: " .. state.brickVar)
end

function love.update(dt)
  -- TODO: dumb vertical movement
  if math.floor(state.t) ~= math.floor(state.t + dt) then
    state.y = state.y + 1
  end

  state.t = state.t + dt
end

function love.keypressed(key, scancode, is_repeat)
  if is_repeat then
    return
  elseif key == "up" then
    state.brickIdx = utils.minus(state.brickIdx, 1, #T.BRICKS)
    state.brickVar = 1
    state.y = 0
  elseif key == "down" then
    state.brickIdx = utils.plus(state.brickIdx, 1, #T.BRICKS)
    state.brickVar = 1
    state.y = 0
  elseif key == "left" then
    state.x = utils.minus(state.x, 0, 8, true)
  elseif key == "right" then
    state.x = utils.plus(state.x, 0, 8, true)
  elseif key == "z" then
    state.brickVar = utils.minus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  elseif key == "x" then
    state.brickVar = utils.plus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  elseif key == "escape" then
    love.event.quit()
  -- else
  --   print(key)
  end
end

function love.keyreleased(key, scancode)
end
