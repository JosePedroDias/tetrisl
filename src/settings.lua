local M = {}

-- will be stored at
-- C:\Users\josep\AppData\Roaming\LOVE\tetris\settings.txt

local SETTINGS_FILE = "settings.txt"

M.load = function()
  local data = love.filesystem.read(SETTINGS_FILE)
  -- print("data", data)

  if data == nil then
    return "99", "99", "on"
  end

  local matches = {}
  for subSt in string.gmatch(data, "([^ ]+)") do
    table.insert(matches, subSt)
  end
  return matches[1], matches[2], matches[3]
end

M.save = function(controls, bricks)
  love.filesystem.write(SETTINGS_FILE, controls .. " " .. bricks)
end

return M
