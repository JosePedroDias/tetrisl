love = {}

local utils = require("src.utils")
local T = require("src.tetris")

local function test_brickFromString()
  local br = T.brickFromString([[
XX
 X
 X]])
  local br2 = {{0, 0}, {q, 0}, {1, 1}, {1, 2}}
  --print(utils.tableToString(br))
  assert(utils.deepEqual(br, b2), "not equal")
end

local function test_boardFromString()
  local s =
    [[
6        5
          
          
          
          
          
1234512345
123   1234
1111111111
  111111  
          
          
          
          
          
          
          
          
          
6        7]]
  local board = T.boardFromString(s)
  local s2 = T.boardToString(board)
  --print(s)
  --print(s2)
  assert(s == s2, "string differ")
end

local function test_id2()
  local id = T.id2(3, 4)
  local pair = T.id2Rev(id)
  assert(pair[1] == 3 and pair[2] == 4)
end

local function test_empty_board()
  local b = T.emptyBoard()
  assert(type(b) == "table")

  local counter = 0
  local foundNonZero = false
  for k, v in pairs(b) do
    counter = counter + 1
    if v ~= 0 then
      foundNonZero = true
    end
  end

  assert(counter == 20 * 10)
  assert(not foundNonZero)
end

local function test_computeLines()
  -- TODO:
end

local function st_doesBrickHitBoard()
  -- TODO:
end
