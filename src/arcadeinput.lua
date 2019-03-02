local consts = require "src.consts"
local utils = require "src.utils"
local scoreboard = require "src.scoreboard"
local stages = require "src.stages"

local touchcursor = require "src.touchcursor"

local G = love.graphics

local M = {}

local alphabet = {
  " ",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "-",
  ".",
  "!",
  "?"
}

local state = {}

local function saveAndReturn(name)
  if string.len(name) > 0 then
    scoreboard.add(name, state.score)
  end
  stages.toStage("highscores")
end

local function onDown()
  state.index = utils.minus(state.index, 1, #alphabet)
end

local function onUp()
  state.index = utils.plus(state.index, 1, #alphabet)
end

local function onLeft()
  state.written = string.sub(state.written, 1, #state.written - 1)
  state.index = 1
end

local function onRight()
  state.written = state.written .. alphabet[state.index]
  state.index = 1
end

local function onEnter()
  state.written = state.written .. alphabet[state.index]
  saveAndReturn(state.written)
end

M.load = function(score)
  state.written = ""
  state.index = 1
  state.score = score

  touchcursor.setCallbacks(
    {
      up = onUp,
      down = onDown,
      left = onLeft,
      right = onRight,
      a = onEnter
    }
  )
end

M.update = function(dt)
  touchcursor.update(dt)
end

M.draw = function()
  local dy = 30
  local x = consts.W / 2
  local y = (consts.H - dy * 2) / 2

  G.setColor(1, 1, 1, 1)
  local f = G.getFont()

  local l1 = "What is your name?"
  local w1 = f:getWidth(l1)
  local l2 = state.written .. "(" .. alphabet[state.index] .. ")"
  local w2 = f:getWidth(l2)

  G.print(l1, x - w1 / 2, y)
  G.print(l2, x - w2 / 2, y + dy)

  touchcursor.draw()
end

M.onKey = function(key)
  if key == "down" then
    onDown()
  elseif key == "up" then
    onUp()
  elseif key == "left" then
    onLeft()
  elseif key == "right" then
    onRight()
  elseif key == "return" then
    onEnter()
  elseif key == "escape" then
    saveAndReturn("")
  end
end

M.onPointer = function(x, y)
  touchcursor.onPointer(x, y)
end

M.onPointerUp = function(x, y)
  touchcursor.onPointerUp(x, y)
end

return M
