local consts = require "src.consts"
local utils = require "src.utils"
local settings = require "src.settings"
local stages = require "src.stages"

local G = love.graphics

local M = {}

local options = {
  "start game",
  "controls",
  "bricks"
}

local possibleValues = {
  {""},
  {"gameboy", "tetris99"},
  {"gameboy", "tetris99"}
}

local state = {}

M.load = function()
  local controls, bricks = settings.load()

  state.chosenOption = 1
  state.chosenIndices = {
    utils.tableIndexOf(possibleValues[2], controls),
    utils.tableIndexOf(possibleValues[3], bricks),
    1
  }
end

M.unload = function()
  local controls = possibleValues[2][state.chosenIndices[2]]
  local bricks = possibleValues[2][state.chosenIndices[3]]
  settings.save(controls, bricks)
end

M.update = function(dt)
end

M.draw = function()
  local dy = 30
  local x = consts.W / 2 - 100
  local y = (consts.H - dy * #options) / 2

  for i, option in ipairs(options) do
    local alpha = 1
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
