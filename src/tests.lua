local other = require("src.other")

local t = {x = "a"}
local a = true
local b = 2
local c = "23"

local f = function(a)
  return a + 1
end
-- print(other.to_string(f))
-- print(other.table_print(t, 2))

require("src.tetris")
