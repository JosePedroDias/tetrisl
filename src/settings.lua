-- [[ manages loading/saving of game settings ]] --
local utils = require "src/utils"

local M = {}

-- will be stored at: C:\Users\josep\AppData\Roaming\LOVE\tetris\settings.txt
local SETTINGS_FILE = "settings.txt"

local VERSION = "3"

-- 1=ghost 2=controls 3=bricks 4-sfx 5-music
local valuesInMemory = {"on", "tetris99", "tetris99", "on", "on"}

M.get = function()
  return valuesInMemory[1], valuesInMemory[2], valuesInMemory[3],
         valuesInMemory[4], valuesInMemory[5]
end

M._set = function(ghost, controls, bricks, sfx, music)
  valuesInMemory = {ghost, controls, bricks, sfx, music}
  M.ghost = ghost
  M.controls = controls
  M.bricks = bricks
  M.sfx = sfx
  M.music = music
end

M.load = function()
  local data = love.filesystem.read(SETTINGS_FILE)
  if data == nil then return M.get() end

  local status, matches = pcall(utils.split, data, " ")
  if not status or matches[1] ~= VERSION or #matches ~= (#valuesInMemory + 1) then
    return M.get()
  end

  M._set(matches[2], matches[3], matches[4], matches[5], matches[6])

  return matches[2], matches[3], matches[4], matches[5], matches[6]
end

M.save = function(ghost, controls, bricks, sfx, music)
  M._set(ghost, controls, bricks, sfx, music)
  love.filesystem.write(SETTINGS_FILE, utils.join(
                          {VERSION, ghost, controls, bricks, sfx, music}, " "))
end

return M
