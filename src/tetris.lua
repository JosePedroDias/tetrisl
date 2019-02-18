local consts = require("src.consts")
local utils = require("src.utils")

local KIND = {}
KIND.I = 1
KIND.J = 2
KIND.L = 3
KIND.O = 4
KIND.S = 5
KIND.T = 6
KIND.Z = 7

local GRID_COLOR = {0.25, 0.25, 0.25}

local COLORS = {
  {0, 1, 1}, -- 1 / cyan / I
  {0, 0, 1}, -- 2 / blue / J
  {1, 0.5, 0}, -- 3 / orange / L
  {1, 1, 0}, -- 4 / yellow / O
  {0, 1, 0}, -- 5 / light green / S
  {0.5, 0, 1}, -- 6 / purple / T
  {1, 0, 0} -- 7 / red / Z
}

local BRICKS = {}

--[[
    0123 0
  0 XXXX X
  1      X
  2      X
  3      X
]]
local brickI = {
  {{0, 0}, {1, 0}, {2, 0}, {3, 0}},
  {{0, 0}, {0, 1}, {0, 2}, {0, 3}}
}
table.insert(BRICKS, brickI)

--[[
    012  01 012 01
  0 XXX   X X   XX
  1   X   X XXX X
  2      XX     X
]]
local brickJ = {
  {{0, 0}, {1, 0}, {2, 0}, {2, 1}},
  {{0, 2}, {1, 2}, {1, 1}, {1, 0}},
  {{0, 0}, {0, 1}, {1, 1}, {2, 1}},
  {{1, 0}, {0, 0}, {0, 1}, {0, 2}}
}
table.insert(BRICKS, brickJ)

--[[
    012  01 012 01
  0 XXX  XX   X X
  1 X     X XXX X
  2       X     XX
]]
local brickL = {
  {{2, 0}, {1, 0}, {0, 0}, {0, 1}},
  {{0, 0}, {1, 0}, {1, 1}, {1, 2}},
  {{2, 0}, {2, 1}, {1, 1}, {0, 1}},
  {{0, 0}, {0, 1}, {0, 2}, {1, 2}}
}
table.insert(BRICKS, brickL)

--[[
    01
  0 XX
  1 XX
]]
local brickO = {
  {{0, 0}, {0, 1}, {1, 0}, {1, 1}}
}
table.insert(BRICKS, brickO)

--[[
    012 01
  0  XX X
  1 XX  XX
  2      X
]]
local brickS = {
  {{0, 1}, {1, 1}, {1, 0}, {2, 0}},
  {{0, 0}, {0, 1}, {1, 1}, {1, 2}}
}
table.insert(BRICKS, brickS)

--[[
    012 01 012 01
  0 XXX  X  X  X
  1  X  XX XXX XX
  2      X     X
]]
local brickT = {
  {{0, 0}, {1, 0}, {2, 0}, {1, 1}},
  {{1, 0}, {1, 1}, {1, 2}, {0, 1}},
  {{0, 1}, {1, 1}, {2, 1}, {1, 0}},
  {{0, 0}, {0, 1}, {0, 2}, {1, 1}}
}
table.insert(BRICKS, brickT)

--[[
    012 01
  0 XX   X
  1  XX XX
  2     X
]]
local brickZ = {
  {{0, 0}, {1, 0}, {1, 1}, {2, 1}},
  {{1, 0}, {1, 1}, {0, 1}, {0, 2}}
}
table.insert(BRICKS, brickZ)

function brickFromString(st)
  local b = {}
  local lines = utils.splitLines(st)
  for y, line in pairs(lines) do
    local chars = utils.explodeString(line)
    for x, char in pairs(chars) do
      if char ~= " " then
        table.insert(b, {x - 1, y - 1})
      end
    end
  end
  return b
end

---- BOARD RELATED

function id2(x, y)
  return y * 100 + x
end

function id2Rev(id)
  local x = id % 100
  local y = (id - x) / 100
  return {x, y}
end

function iterateBoard(board, fn)
  for y = 1, consts.h do
    for x = 1, consts.w do
      fn(board, x, y)
    end
  end
end

function boardFromString(st)
  local board = emptyBoard()
  local lines = utils.splitLines(st)
  for y, line in pairs(lines) do
    local chars = utils.explodeString(line)
    for x, char in pairs(chars) do
      local n = tonumber(char)
      if (type(n) == "number") then
        board[id2(x, y)] = n
      end
    end
  end
  return board
end

function boardToString(board)
  local s = ""
  local lastY = -1
  function printCell(board, x, y)
    if y ~= lastY then
      s = s .. "\n"
    end
    local v = board[id2(x, y)]
    if v == 0 then
      v = " "
    end
    s = s .. v
    lastY = y
  end
  iterateBoard(board, printCell)
  return s
end

function emptyBoard()
  local board = {}
  function emptyCell(board, x, y)
    board[id2(x, y)] = 0
  end
  iterateBoard(board, emptyCell)
  return board
end

function randomBoard()
  local board = {}
  function fillCell(board, x, y)
    local r = love.math.random()
    -- local isOn = r > 0.25
    local isOn = r < ((y - 2) / consts.h)
    board[id2(x, y)] = (not isOn) and 0 or love.math.random(#BRICKS)
  end
  iterateBoard(board, fillCell)
  return board
end

function doesBrickHitBoard(brickIdx, brickVar, board)
  local items = BRICKS[brickIdx][brickVar]
  for k, v in pairs(items) do
    if board[id2(v[1], v[2])] ~= 0 then
      return true
    end
  end
  return false
end

function applyBrickToBoard(brickIdx, brickVar)
  local items = BRICKS[brickIdx][brickVar]
  for k, v in pairs(items) do
    board[id2(v[1], v[2])] = brickIdx
  end
end

function computeLines(board)
  -- TODO:
  return board
end

---- DRAWING FUNCTIONS

local G = love.graphics

function drawCell(colorIdx, x, y)
  if (colorIdx == 0) then
    return
  end
  local clr = COLORS[colorIdx]
  G.setColor(clr[1], clr[2], clr[3], 1)
  G.rectangle("fill", consts.x0 + x * consts.cell, consts.y0 + y * consts.cell, consts.cell, consts.cell)
end

function drawBrick(pos0, brickIdx, brickVar)
  local items = BRICKS[brickIdx][brickVar]
  for k, v in pairs(items) do
    local x = pos0[1] + v[1]
    local y = pos0[2] + v[2]
    drawCell(brickIdx, x, y)
  end
end

function drawBoard(board)
  function fn(b, x, y)
    local v = b[id2(x, y)]
    drawCell(v, x - 1, y - 1)
  end
  iterateBoard(board, fn)
end

function drawBoardBackground()
  for y = 0, consts.h - 1 do
    for x = 0, consts.w - 1 do
      local alpha = (x + y) % 2 == 0 and 0.15 or 0.075
      G.setColor(1, 1, 1, alpha)
      G.rectangle("fill", consts.x0 + x * consts.cell, consts.y0 + y * consts.cell, consts.cell, consts.cell)
    end
  end
end

return {
  BRICKS = BRICKS,
  COLORS = COLORS,
  KIND = KIND,
  brickFromString = brickFromString,
  id2 = id2,
  id2Rev = id2Rev,
  iterateBoard = iterateBoard,
  boardFromString = boardFromString,
  boardToString = boardToString,
  emptyBoard = emptyBoard,
  randomBoard = randomBoard,
  doesBrickHitBoard = doesBrickHitBoard,
  applyBrickToBoard = applyBrickToBoard,
  computeLines = computeLines,
  drawCell = drawCell,
  drawBrick = drawBrick,
  drawBoard = drawBoard,
  drawBoardBackground = drawBoardBackground
}
