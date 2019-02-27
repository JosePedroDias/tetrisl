local M = {}

-- will be stored at: C:\Users\josep\AppData\Roaming\LOVE\tetris\settings.txt
local SETTINGS_FILE = "settings.txt"

local valuesInMemory = {"tetris99", "tetris99"}

M.get = function()
  return valuesInMemory[1], valuesInMemory[2]
end

M._set = function(controls, bricks)
  valuesInMemory = {controls, bricks}
  M.controls = controls
  M.bricks = bricks
end

M.load = function()
  local data = love.filesystem.read(SETTINGS_FILE)
  if data == nil then
    return M.get()
  end

  local matches = {}
  for subSt in string.gmatch(data, "([^ ]+)") do
    table.insert(matches, subSt)
  end

  M._set(matches[1], matches[2])

  return matches[1], matches[2]
end

M.save = function(controls, bricks)
  M._set(controls, bricks)
  love.filesystem.write(SETTINGS_FILE, controls .. " " .. bricks)
end

return M
