local utils = require "src/utils"

local M = {}

-- will be stored at: C:\Users\josep\AppData\Roaming\LOVE\tetris\settings.txt
local SETTINGS_FILE = "settings.txt"

local VERSION = "2"

-- 1=controls 2=bricks 3-sfx 4-music
local valuesInMemory = {"tetris99", "tetris99", "on", "on"}

M.get = function()
  return valuesInMemory[1], valuesInMemory[2], valuesInMemory[3], valuesInMemory[4]
end

M._set = function(controls, bricks, sfx, music)
  valuesInMemory = {controls, bricks, sfx, music}
  M.controls = controls
  M.bricks = bricks
  M.sfx = sfx
  M.music = music
end

M.load = function()
  local data = love.filesystem.read(SETTINGS_FILE)
  if data == nil then
    return M.get()
  end

  local status, matches = pcall(utils.split, data, " ")
  if not status or matches[1] ~= VERSION or #matches ~= 5 then
    return M.get()
  end

  M._set(matches[2], matches[3], matches[4], matches[5])

  return matches[2], matches[3], matches[4], matches[5]
end

M.save = function(controls, bricks, sfx, music)
  M._set(controls, bricks, sfx, music)
  love.filesystem.write(SETTINGS_FILE, utils.join({VERSION, controls, bricks, sfx, music}, " "))
end

return M
