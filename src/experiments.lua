local utils = require "src.utils"

--[[ local t = {x = "a"}
local a = true
local b = 2
local c = "23"
local f = function(a)
  return a + 1
end ]]
-- print(other.to_string(f))
-- print(other.table_print(t, 2))

--[[ 
function _id2(x, y)
  return x .. "|" .. y
end

function id2(x, y)
  return y * 100 + x
end

local mtx = {}
mtx[id2(0, 0)] = 0
mtx[id2(1, 0)] = 1
mtx[id2(0, 1)] = 2
mtx[id2(1, 1)] = 3
for k, v in pairs(mtx) do
  print(k .. " -> " .. v)
end

error("boom")
 ]]
