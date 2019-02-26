local utils = require "src.utils"

local M = {}

-- will be stored at: C:\Users\josep\AppData\Roaming\LOVE\tetris\scores.txt
local SCORES_FILE = "scores.txt"
local SEP = "|"
local DEFAULTS = "0" .. SEP .. "no one"

M.load = function()
  local data = love.filesystem.read(SCORES_FILE)
  if data == nil then
    data = DEFAULTS
    love.filesystem.write(SCORES_FILE, data)
  end

  local lines = utils.splitLines(data)
  -- print("#lines:", #lines)

  function parseLine(line)
    local row = utils.split(line, SEP)
    row[1] = tonumber(row[1])
    -- print("line:", row[1], row[2])
    return row
  end

  return utils.tableMap(lines, parseLine)
end

M.add = function(who, points)
  local scores = M.load()

  table.insert(scores, {points, who})

  table.sort(
    scores,
    function(a, b)
      return a[1] > b[1]
    end
  )

  -- print(utils.tableToString(scores))

  local data = ""
  for i, row in ipairs(scores) do
    local nl = i > 1 and "\n" or ""
    data = data .. nl .. tostring(row[1]) .. SEP .. row[2]
  end

  love.filesystem.write(SCORES_FILE, data)

  return scores
end

return M
