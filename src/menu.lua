-- [[ menu screen ]] --
local consts = require "src.consts"
local utils = require "src.utils"
local settings = require "src.settings"
local stages = require "src.stages"

local G = love.graphics

local DY = 50

local M = {}

local isMobile = utils.isMobile()

local options = {
  "start game", "see high scores", "quit", "show ghost", "controls scheme",
  "brick rotations", "sound effects", "music"
}

local possibleValues = {
  {""}, {""}, {""}, {"on", "off"}, {"gameboy", "tetris99"},
  {"gameboy", "tetris99"}, {"on", "off"}, {"on", "off"}
}

local IDX_START = 1
local IDX_HIGH = 2
local IDX_EXIT = 3

local IDX_GHOST = 4
local IDX_CTRLS = 5
local IDX_BRICK = 6
local IDX_SFX = 7
local IDX_MUSIC = 8

local state = {}

M.load = function()
  local ghost, controls, bricks, sfx, music = settings.get()

  state.chosenOption = 1
  state.chosenIndices = {
    1, 1, 1, utils.indexOf(possibleValues[IDX_GHOST], ghost),
    utils.indexOf(possibleValues[IDX_CTRLS], controls),
    utils.indexOf(possibleValues[IDX_BRICK], bricks),
    utils.indexOf(possibleValues[IDX_SFX], sfx),
    utils.indexOf(possibleValues[IDX_MUSIC], music)
  }
end

M.unload = function()
  local ghost = possibleValues[IDX_GHOST][state.chosenIndices[IDX_GHOST]]
  local controls = possibleValues[IDX_CTRLS][state.chosenIndices[IDX_CTRLS]]
  local bricks = possibleValues[IDX_BRICK][state.chosenIndices[IDX_BRICK]]
  local sfx = possibleValues[IDX_SFX][state.chosenIndices[IDX_SFX]]
  local music = possibleValues[IDX_MUSIC][state.chosenIndices[IDX_MUSIC]]
  settings.save(ghost, controls, bricks, sfx, music)
end

M.draw = function()
  local x0 = consts.W / 2 - 140
  local y0 = (consts.H - DY * #options) / 2

  G.setColor(1, 1, 1, 1)

  for i, option in ipairs(options) do
    if i == 4 then G.setColor(1, 1, 1, 0.75) end
    local bullet = "   "
    if state.chosenOption == i and not isMobile then bullet = "- " end

    local value = possibleValues[i][state.chosenIndices[i]]

    local sep = value ~= "" and ": " or ""
    G.print(bullet .. option .. sep .. value, x0, y0 + DY * (i - 1))
  end
end

local function onStartGame()
  stages.toStage("game")
end

local function onHighscores()
  stages.toStage("highscores")
end

local function onToggleOption(i)
  state.chosenIndices[i] = utils.plus(state.chosenIndices[i], 1,
                                      #possibleValues[i])
end

local function onExit()
  stages.exit()
end

M.onKey = function(key)
  if key == "up" then
    state.chosenOption = utils.minus(state.chosenOption, 1, #options)
  elseif key == "down" then
    state.chosenOption = utils.plus(state.chosenOption, 1, #options)
  elseif key == "return" or key == "space" then
    if state.chosenOption == IDX_START then
      onStartGame()
    elseif state.chosenOption == IDX_HIGH then
      onHighscores()
    elseif state.chosenOption == IDX_EXIT then
      onExit()
    else
      onToggleOption(state.chosenOption)
    end
  elseif key == "escape" then
    onExit()
  end
end

M.onPointer = function(_, y)
  local y0 = (consts.H - DY * #options) / 2

  for i, _ in ipairs(options) do
    local yi = y0 + DY * (i - 1)
    if y >= yi and y <= yi + DY then
      state.chosenOption = i
      if i == IDX_START then
        onStartGame()
      elseif i == IDX_HIGH then
        onHighscores()
      elseif i == IDX_EXIT then
        onExit()
      else
        onToggleOption(i)
      end
    end
  end
end

return M
