local consts = require "src.consts"
local utils = require "src.utils"
local settings = require "src.settings"
local stages = require "src.stages"
local T = require "src.tetris"

local M = {}

local G = love.graphics

local state = {}

local BLINK_DELTA = 1 / 4

function getRandomBrickIdx()
  return love.math.random(#T.BRICKS)
end

function resetTimer()
  state.tNextDown = state.t + state.dtForDown
  if state.tNextLineAnim then
    state.tNextDown = state.tNextDown + state.dtForLineAnim
  end
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

function moveDown() -- return true if it has hit
  local hits = T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y + 1)
  if hits then
    T.applyBrickToBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y)

    state.destroyedLines = T.computeLines(state.board, false)
    local newLines = #state.destroyedLines
    if newLines > 0 then
      state.tNextLineAnim = state.t + state.dtForLineAnim
      --state.tNextDown = state.tNextDown + state.dtForLineAnim
      love.audio.play(doneSfx)
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
      -- state.ended = true
      stages.toStage("arcadeinput", state.score)
    end
  else
    state.y = state.y + 1
  end

  computeDropY()

  return hits
end

----------------------

M.load = function()
  T.prepare()
  onRestart()
  computeDropY()
end

M.unload = function()
end

M.update = function(dt)
  if state.paused or state.ended then
    return
  end

  if state.tNextLineAnim then
    if state.t > state.tNextLineAnim then
      T.computeLines(state.board, true)
      state.tNextLineAnim = nil
      state.destroyedLines = {}
    end
  elseif state.t > state.tNextDown then
    moveDown()
    resetTimer()
  end

  state.t = state.t + dt
end

M.draw = function()
  local r = 0

  if state.tNextLineAnim == nil then
    r = (state.tNextDown - state.t) / state.dtForDown

    -- 0.5 -> 2 | 0.8 -> 5
    if r > 0.8 then
      r = (r - 0.8) * 5
    else
      r = 0
    end
  end

  T.drawBoardBackground()

  T.drawBoard(state.board, state.t % BLINK_DELTA < BLINK_DELTA / 2 and state.destroyedLines or {})

  if state.tNextLineAnim == nil and not state.ended then
    if state.y ~= state.dropY then
      T.drawBrick({state.x, state.dropY}, state.brickIdx, state.brickVar, true)
    end

    T.drawBrick({state.x, state.y + (1 - r - 1)}, state.brickIdx, state.brickVar)

    T.drawBrick({13, 0}, state.nextBrickIdx, 1)
  end

  G.setColor(1, 1, 1, 1)
  G.print("level:" .. state.level .. "  score:" .. state.score .. "  lines:" .. state.lines)

  if state.paused then
    G.print("P A U S E D", consts.W / 2 - 34, consts.H / 2 - 8)
  elseif state.ended then
    G.print("GAME OVER", consts.W / 2 - 34, consts.H / 2 - 8)
  end
end

-----

function onRestart()
  state.paused = false
  state.ended = false
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
  state.lineAnimLines = {}
  state.dtForLineAnim = 1
  -- state.tNextLineAnim = -1
  state.destroyedLines = {}
end

function onPause()
  if state.ended then
    return
  elseif state.paused then
    state.paused = nil
  else
    state.paused = true
  end
end

function onDrop()
  if state.paused or state.ended then
    return
  end
  love.audio.play(tickSfx)
  while not moveDown() do
  end
  resetTimer()
end

function onDownOnce()
  if state.paused or state.ended then
    return
  end
  love.audio.play(tickSfx)
  moveDown()
  resetTimer()
end

function onLeft()
  if state.paused or state.ended then
    return
  end
  love.audio.play(tickSfx)
  if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x - 1, state.y) then
    state.x = state.x - 1
    computeDropY()
  end
end

function onRight()
  if state.paused or state.ended then
    return
  end
  love.audio.play(tickSfx)
  if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x + 1, state.y) then
    state.x = state.x + 1
    computeDropY()
  end
end

function onCCW()
  if state.paused or state.ended then
    return
  end
  love.audio.play(tickSfx)
  state.brickVar = utils.minus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  computeDropY()
end

function onCW()
  if state.paused or state.ended then
    return
  end
  love.audio.play(tickSfx)
  state.brickVar = utils.plus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  computeDropY()
end

-----

M.onKey = function(key)
  if state.tNextLineAnim then
    return
  end

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
    stages.exit()
  end
end

M.onPointer = function(x, y)
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

return M
