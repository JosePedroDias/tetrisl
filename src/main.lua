local consts = require "src.consts"
local T = require "src.tetris"
local utils = require "src.utils"
local screen = require "src.screen"
-- local settings = require "src.settings"

local G = love.graphics

function getRandomBrickIdx()
  return love.math.random(#T.BRICKS)
end

local state = {}

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
  --settings.save("xx", "y123")

  -- local sets = settings.load()
  -- print("controls", sets[1])
  -- print("bricks", sets[2])

  love.keyboard.setKeyRepeat(true)

  local sW, sH = screen.getCurrentResolution()
  -- print("screenDims: " .. sW .. " x " .. sH)

  screen.setSize(sW, sH, consts.W, consts.H, true)

  T.prepare()

  onRestart()

  -- local f = love.graphics.newFont("./assets/fonts/montserrat-semibold.otf", 24)
  -- love.graphics.setFont(f)

  computeDropY()
end

function love.draw()
  local r = (state.tNextDown - state.t) / state.dtForDown

  if r > 0.5 then
    r = (r - 0.5) * 2
  else
    r = 0
  end

  -- if r > 0.8 then
  --   r = (r - 0.8) * 5
  -- else
  --   r = 0
  -- end

  screen.startDraw()

  T.drawBoardBackground()

  T.drawBoard(state.board)

  if state.y ~= state.dropY then
    T.drawBrick({state.x, state.dropY}, state.brickIdx, state.brickVar, true)
  end

  T.drawBrick({state.x, state.y + (1 - r - 1)}, state.brickIdx, state.brickVar)

  T.drawBrick({13, 0}, state.nextBrickIdx, 1)

  G.setColor(1, 1, 1, 1)
  G.print("level:" .. state.level .. "  score:" .. state.score .. "  lines:" .. state.lines)

  if state.paused then
    G.print("P A U S E D", consts.W / 2 - 34, consts.H / 2 - 8)
  end

  screen.endDraw()
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
    state.x = 3

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
  if state.paused then
    return
  end

  if state.t > state.tNextDown then
    moveDown()
    resetTimer()
  end

  state.t = state.t + dt
end

---- ACTIONS

function onRestart()
  state.nextBrickIdx = getRandomBrickIdx()
  state.brickIdx = getRandomBrickIdx()
  state.brickVar = 1
  state.board = T.emptyBoard()
  state.x = 3
  state.y = 0
  state.score = 0
  state.lines = 0
  state.t = 0
  state.dtForDown = 1.5
  state.tNextDown = 1.5
  state.level = 1
end

function onPause()
  if state.paused then
    state.paused = nil
  else
    state.paused = true
  end
end

function onDrop()
  while not moveDown() do
  end
  resetTimer()
end

function onDownOnce()
  moveDown()
  resetTimer()
end

function onLeft()
  if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x - 1, state.y) then
    state.x = state.x - 1
    computeDropY()
  end
end

function onRight()
  if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x + 1, state.y) then
    state.x = state.x + 1
    computeDropY()
  end
end

function onCCW()
  state.brickVar = utils.minus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  computeDropY()
end

function onCW()
  state.brickVar = utils.plus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  computeDropY()
end

function onExit()
  love.event.quit()
end

-- ACTIONS VIA KEYS

function love.keypressed(key, scancode, is_repeat)
  if false then
    if key == "up" then
      onDrop()
    elseif key == "down" then
      onDownOnce()
    elseif key == "left" then
      onLeft()
    elseif key == "right" then
      onRight()
    elseif key == "z" then
      onCW()
    elseif key == "x" then
      onCCW()
    end
  else
    if key == "up" then
      onCCW()
    elseif key == "down" then
      onDownOnce()
    elseif key == "left" then
      onLeft()
    elseif key == "right" then
      onRight()
    elseif key == "space" then
      onDrop()
    end
  end

  if key == "p" then
    onPause()
  elseif key == "r" then
    onRestart()
  elseif key == "escape" then
    onExit()
  end
end

-- ACTIONS VIA TOUCH

function love.mousepressed(_x, _y)
  local x, y = screen.coords(_x, _y)

  local xR = x / consts.W
  local yR = x / consts.H

  if yR < 0.25 then
    onDrop()
  elseif yR > 0.75 then
    onDownOnce()
  else
    if xR < 0.333 then
      onLeft()
    elseif xR > 0.666 then
      onRight()
    else
      onCCW()
    end
  end
end
