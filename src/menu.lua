local consts = require "src.consts"
local utils = require "src.utils"
local settings = require "src.settings"
local stages = require "src.stages"

local G = love.graphics

local M = {}

local options = {
  "start game",
  "see high scores",
  "change controls",
  "change bricks"
}

local possibleValues = {
  {""},
  {""},
  {"gameboy", "tetris99"},
  {"gameboy", "tetris99"}
}

local IDX_CTRLS = 3
local IDX_BRICK = 4

local state = {}

M.load = function()
  local controls, bricks = settings.get()

  state.chosenOption = 1
  state.chosenIndices = {
    1,
    1,
    utils.tableIndexOf(possibleValues[IDX_CTRLS], controls),
    utils.tableIndexOf(possibleValues[IDX_BRICK], bricks)
  }
end

M.unload = function()
  local controls = possibleValues[IDX_CTRLS][state.chosenIndices[IDX_CTRLS]]
  local bricks = possibleValues[IDX_BRICK][state.chosenIndices[IDX_BRICK]]
  settings.save(controls, bricks)
end

M.draw = function()
  local dy = 30
  local x0 = consts.W / 2 - 100
  local y0 = (consts.H - dy * #options) / 2

  for i, option in ipairs(options) do
    local alpha = 1 -- TODO: alpha borked
    local bullet = "  "
    if state.chosenOption == i then
      alpha = 1
      bullet = "- "
    end

    local value = possibleValues[i][state.chosenIndices[i]]
    G.setColor(1, 1, 1, alpha)
    local sep = value ~= "" and ": " or ""
    G.print(bullet .. option .. sep .. value, x0, y0 + dy * (i - 1))
  end
end

local function onStartGame()
  stages.toStage("game")
end

local function onHighscores()
  stages.toStage("highscores")
end

local function onToggleOption(i)
  state.chosenIndices[i] = utils.plus(state.chosenIndices[i], 1, #possibleValues[i])
end

M.onKey = function(key)
  if key == "up" then
    state.chosenOption = utils.minus(state.chosenOption, 1, #options)
  elseif key == "down" then
    state.chosenOption = utils.plus(state.chosenOption, 1, #options)
  elseif key == "return" or key == "space" then
    if state.chosenOption == 1 then
      onStartGame()
    elseif state.chosenOption == 2 then
      onHighscores()
    else
      onToggleOption(state.chosenOption)
    end
  elseif key == "escape" then
    stages.exit()
  end
end

M.onPointer = function(x, y)
  local dy = 30
  local y0 = (consts.H - dy * #options) / 2

  for i, _ in ipairs(options) do
    local yi = y0 + dy * (i - 1)
    if y >= yi and y <= yi + dy then
      if i == 1 then
        onStartGame()
      elseif i == 2 then
        onHighscores()
      else
        onToggleOption(i)
      end
    end
  end
end

return M
