local consts = require "src.consts"
local utils = require "src.utils"
local settings = require "src.settings"
local stages = require "src.stages"
local assets = require "src.assets"
local T = require "src.tetris"
local scoreboard = require "src.scoreboard"
local touchcursor = require "src.touchcursor"

local M = {}

local G = love.graphics

local isMobile = utils.isMobile()

local state = {}
-- _G.state = state -- to expose to lovebird

local BLINK_DELTA = 1 / 4

local function getRandomBrickIdx()
  return love.math.random(#T.BRICKS)
end

local function resetTimer()
  state.tNextDown = state.t + state.dtForDown
  if state.tNextLineAnim then
    state.tNextDown = state.tNextDown + state.dtForLineAnim
  end
end

local function levelUp()
  state.level = state.level + 1
  state.dtForDown = state.dtForDown - 0.2
  if settings.sfx == "on" then
    love.audio.play(assets.sfx.levelUp)
  end
end

local function computeDropY()
  local y = state.y
  while not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x, y) do
    y = y + 1
  end
  state.dropY = y - 1
end

local function moveDown() -- return true if it has hit
  local hits = T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y + 1)
  if hits then
    T.applyBrickToBoard(state.brickIdx, state.brickVar, state.board, state.x, state.y)

    state.destroyedLines = T.computeLines(state.board, false)
    local newLines = #state.destroyedLines
    if newLines > 0 then
      state.tNextLineAnim = state.t + state.dtForLineAnim
      if settings.sfx == "on" then
        love.audio.play(assets.sfx.line)
      end
      state.lines = state.lines + newLines
      local deltaScore = 2 ^ (newLines - 1)
      state.score = state.score + deltaScore
      if state.lines % 10 == 0 then
        levelUp()
      end
    end

    utils.push(state.nextBrickIndices, getRandomBrickIdx())
    state.brickIdx = utils.unshift(state.nextBrickIndices)
    state.brickVar = 1
    state.y = 0
    state.x = 3

    state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
    if state.x == -1 then
      if scoreboard.makesIt(state.score) then
        stages.toStage("arcadeinput", state.score)
      else
        state.ended = true
        state.t = 0
      end
    end
  else
    state.y = state.y + 1
  end

  computeDropY()

  return hits
end

----------------------

M.unload = function()
  if settings.music == "on" then
    assets.music.swingjeding:stop()
  end
end

M.update = function(dt)
  touchcursor.update(dt)

  if state.paused then
    return
  elseif state.ended then
    state.t = state.t + dt
    if state.t > 2 then
      stages.toStage("menu")
    end
    return
  end

  if state.tNextLineAnim then
    if state.t > state.tNextLineAnim then
      T.computeLines(state.board, true)
      state.tNextLineAnim = nil
      state.destroyedLines = {}
      computeDropY()
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
    r = r * r * r
  end

  T.drawBoardBackground()

  T.drawBoard(state.board, state.t % BLINK_DELTA < BLINK_DELTA / 2 and state.destroyedLines or {})

  if not isMobile then
    G.setColor(1, 1, 1, 1)
    G.print("Hold:", 190, 40)
    if state.swap then
      T.drawBrick({-5.5, 0}, state.swap, 1)
    end
  end

  G.setColor(1, 1, 1, 1)
  G.print("Next blocks:", 550, 40)
  for i = 1, 5 do
    T.drawBrick({12.5, (i - 1) * 4}, state.nextBrickIndices[i], 1)
  end

  if state.tNextLineAnim == nil and not state.ended then
    if state.y ~= state.dropY and settings.ghost == "on" then
      T.drawBrick({state.x, state.dropY}, state.brickIdx, state.brickVar, true)
    end
    T.drawBrick({state.x, state.y + (1 - r - 1)}, state.brickIdx, state.brickVar)
  end

  local mainF = assets.fonts.main

  G.setColor(1, 1, 1, 1)
  local status = "Level: " .. state.level .. "  Score: " .. state.score .. "  Lines: " .. state.lines
  local w = mainF:getWidth(status)
  G.print(status, (consts.W - w) / 2, 0)

  if state.paused or state.ended then
    local txt = state.paused and "P A U S E D" or "G A M E   O V E R"
    local w2 = mainF:getWidth(txt)
    G.print(txt, (consts.W - w2) / 2, consts.H / 2 - 18)
  end

  touchcursor.draw()
end

-----

local function onRestart()
  state.nextBrickIndices = utils.times(10, getRandomBrickIdx)
  state.paused = false
  state.ended = false
  state.brickIdx = utils.unshift(state.nextBrickIndices)
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
  state.destroyedLines = {}
  state.swap = nil
end

local function onPause()
  if state.ended then
    return
  elseif state.paused then
    state.paused = nil
  else
    state.paused = true
  end
end

local function onDrop()
  if state.paused or state.ended then
    return
  end
  if settings.sfx == "on" then
    love.audio.play(assets.sfx.dropHard)
  end
  while not moveDown() do
  end
  resetTimer()
end

local function onDownOnce()
  if state.paused or state.ended then
    return
  end
  moveDown()
  resetTimer()
end

local function onSwap()
  if state.paused or state.ended then
    return
  end
  state.brickVar = 1
  if state.swap then
    utils.shift(state.nextBrickIndices, state.brickIdx)
    state.brickIdx = state.swap
    state.swap = nil
  else
    state.swap = state.brickIdx
    state.brickIdx = utils.unshift(state.nextBrickIndices)
  end
  state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
end

local function onLeft()
  if state.paused or state.ended then
    return
  end
  if settings.sfx == "on" then
    love.audio.play(assets.sfx.move)
  end
  if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x - 1, state.y) then
    state.x = state.x - 1
    computeDropY()
  end
  resetTimer()
end

local function onRight()
  if state.paused or state.ended then
    return
  end
  if settings.sfx == "on" then
    love.audio.play(assets.sfx.move)
  end
  if not T.doesBrickHitBoard(state.brickIdx, state.brickVar, state.board, state.x + 1, state.y) then
    state.x = state.x + 1
    computeDropY()
  end
  resetTimer()
end

local function onCCW()
  if state.paused or state.ended then
    return
  end
  if settings.sfx == "on" then
    love.audio.play(assets.sfx.rotate)
  end
  state.brickVar = utils.minus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  computeDropY()
  resetTimer()
end

local function onCW()
  if state.paused or state.ended then
    return
  end
  if settings.sfx == "on" then
    love.audio.play(assets.sfx.rotate)
  end
  state.brickVar = utils.plus(state.brickVar, 1, #T.BRICKS[state.brickIdx])
  state.x = T.electNearestPosition(state.brickIdx, state.brickVar, state.board, state.x, state.y)
  computeDropY()
  resetTimer()
end

-----

M.onKey = function(key)
  if state.tNextLineAnim then
    return
  end

  if settings.controls == "tetris99" then
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
  else -- gameboy
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
  if key == "s" then
    onSwap()
  elseif key == "p" then
    onPause()
  elseif key == "r" then
    onRestart()
  elseif key == "escape" then
    stages.toStage("menu")
  end
end

M.load = function()
  T.prepare()
  T.setBricks(settings.bricks)
  onRestart()
  computeDropY()

  if settings.music == "on" then
    assets.music.swingjeding:play()
    assets.music.swingjeding:setLooping(true)
  end

  touchcursor.setCallbacks(
    {
      up = onDrop,
      down = onDownOnce,
      left = onLeft,
      right = onRight,
      a = onCCW,
      b = onCW
    }
  )
end

M.focus = function(isFocused)
  state.paused = not isFocused
end

M.onPointer = function(x, y)
  touchcursor.onPointer(x, y)
end

M.onPointerUp = function(x, y)
  touchcursor.onPointerUp(x, y)
end

return M
