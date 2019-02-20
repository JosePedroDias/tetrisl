local M = {}

local _CFG_FILE_PATH_

-- 1=controls 2=bricks
local _DEFAULT_DATA_ = {"99", "99"}

_CFG_FILE_PATH_ = "tetris.txt"

M.load = function()
  local data = love.filesystem.read(_CFG_FILE_PATH_)
  print("data", data)

  if data == nil then
    return _DEFAULT_DATA_
  end

  local matches = {}
  for subSt in string.gmatch(data, "([^ ]+)") do
    table.insert(matches, subSt)
  end
  return matches
end

M.save = function(controls, bricks)
  love.filesystem.write(_CFG_FILE_PATH_, a .. " " .. b)
end

return M
