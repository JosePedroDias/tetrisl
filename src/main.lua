local T = require "src.tetris"
local utils = require "src.utils"

local G = love.graphics

function getRandomBrickIdx()
  return love.math.random(#T.BRICKS)
end

local state = {t = 0, brickIdx = getRandomBrickIdx(), brickVar = 1, board = T.emptyBoard(), x = 4, y = 0}

function love.load()
  love.keyboard.setKeyRepeat(true)
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

function moveDown() -- return true if it has hit
  local hits = T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y + 1)
  if hits then
    T.applyBrickToBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y)
    state.x = 4
    state.y = 0
    state.brickIdx = getRandomBrickIdx()
    state.brickVar = 1
    T.computeLines(state.board)
    state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
    if state.x == -1 then
      error("game over")
    end
  else
    state.y = state.y + 1
  end
  return hits
end

function love.update(dt)
  if math.floor(state.t) ~= math.floor(state.t + dt) then
    moveDown()
  end

  state.t = state.t + dt
end

function love.keypressed(key, scancode, is_repeat)
  --if is_repeat then
  --  return
  if key == "up" then
    while not moveDown() do
    end
  elseif key == "down" then
    moveDown()
  elseif key == "left" then
    if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x - 1, state.y) then
      state.x = state.x - 1
    end
  elseif key == "right" then
    if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x + 1, state.y) then
      state.x = state.x + 1
    end
  elseif key == "z" then
    state.brickVar = utils.minus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
    state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  elseif key == "x" then
    state.brickVar = utils.plus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
    state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  elseif key == "escape" then
    love.event.quit()
  end
end

function love.keyreleased(key, scancode)
end
