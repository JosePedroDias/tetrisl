local T = require "src.tetris"
local utils = require "src.utils"

local G = love.graphics

function getRandomBrickIdx()
  return love.math.random(#T.BRICKS)
end

local state = {
  nextBrickIdx = getRandomBrickIdx(),
  brickIdx = getRandomBrickIdx(),
  brickVar = 1,
  board = T.emptyBoard(),
  x = 4,
  y = 0,
  score = 0,
  lines = 0,
  t = 0,
  dtForDown = 2,
  tNextDown = 2,
  level = 1
}

function resetTimer()
  state.tNextDown = state.t + state.dtForDown
end

function levelUp()
  state.level = state.level + 1
  state.dtForDown = state.dtForDown - 0.2
end

function computeDropY()
  local y = state.y
  while not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x, y) do
    y = y + 1
  end
  state.dropY = y - 1
end

function love.load()
  love.keyboard.setKeyRepeat(true)

  -- local f = love.graphics.newFont("./assets/fonts/montserrat-semibold.otf", 24)
  -- love.graphics.setFont(f)

  computeDropY()
end

function love.draw()
  T.drawBoardBackground()

  T.drawBoard(state.board)

  if state.y ~= state.dropY then
    T.drawBrick({state.x, state.dropY}, state.brickIdx, state.brickVar, true)
  end

  T.drawBrick({state.x, state.y}, state.brickIdx, state.brickVar)

  T.drawBrick({13, 0}, state.nextBrickIdx, 1)

  G.setColor(1, 1, 1, 1)
  G.print("level:" .. state.level .. "  score:" .. state.score .. "  lines:" .. state.lines)
end

function moveDown() -- return true if it has hit
  local hits = T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y + 1)
  if hits then
    T.applyBrickToBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y)

    local newLines = T.computeLines(state.board)
    if newLines > 0 then
      state.lines = state.lines + newLines
      local deltaScore = 2 ^ (newLines - 1)
      state.score = state.score + deltaScore
      if state.lines % 10 == 0 then
        levelUp()
      end
    end

    state.brickIdx = state.nextBrickIdx
    state.nextBrickIdx = getRandomBrickIdx()
    state.brickVar = 1
    state.y = 0
    state.x = 4

    state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
    if state.x == -1 then
      error("game over")
    end
  else
    state.y = state.y + 1
  end

  computeDropY()

  return hits
end

function love.update(dt)
  if state.t > state.tNextDown then
    moveDown()
    resetTimer()
  end

  state.t = state.t + dt
end

function love.keypressed(key, scancode, is_repeat)
  --if is_repeat then
  --  return
  if key == "up" then
    while not moveDown() do
    end
    resetTimer()
  elseif key == "down" then
    moveDown()
    resetTimer()
  elseif key == "left" then
    if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x - 1, state.y) then
      state.x = state.x - 1
      computeDropY()
    end
  elseif key == "right" then
    if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x + 1, state.y) then
      state.x = state.x + 1
      computeDropY()
    end
  elseif key == "z" then
    state.brickVar = utils.minus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
    state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
    computeDropY()
  elseif key == "x" then
    state.brickVar = utils.plus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
    state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
    computeDropY()
  elseif key == "escape" then
    love.event.quit()
  end
end

function love.keyreleased(key, scancode)
end
