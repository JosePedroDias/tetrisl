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

M.update = function(dt)
end

M.draw = function()
  local dy = 30
  local x = consts.W / 2 - 100
  local y = (consts.H - dy * #options) / 2

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
    G.print(bullet .. option .. sep .. value, x, y + dy * (i - 1))
  end
end

M.onKey = function(key)
  if key == "up" then
    state.chosenOption = utils.minus(state.chosenOption, 1, #options)
  elseif key == "down" then
    state.chosenOption = utils.plus(state.chosenOption, 1, #options)
  elseif key == "return" or key == "space" then
    if state.chosenOption == 1 then
      stages.toStage("game")
    elseif state.chosenOption == 2 then
      stages.toStage("highscores")
    else
      state.chosenIndices[state.chosenOption] =
        utils.plus(state.chosenIndices[state.chosenOption], 1, #possibleValues[state.chosenOption])
    end
  elseif key == "escape" then
    stages.exit()
  -- else
  -- print(key)
  end
end

M.onPointer = function(x, y)
  -- print("pointer " .. x ", " .. y)
end

return M
