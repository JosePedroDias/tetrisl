local consts = require "src.consts"
local utils = require "src.utils"

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
    01234 01234 01234 01234
  0               X        
  1   X           X        
  2   O    XOXX   O   XXOX 
  3   X           X        
  4   X  

]]
local brickI = {
  {{2, 1}, {2, 2}, {2, 3}, {2, 4}},
  {{1, 2}, {2, 2}, {3, 2}, {4, 2}},
  {{2, 0}, {2, 1}, {2, 2}, {2, 3}},
  {{0, 2}, {1, 2}, {2, 2}, {3, 2}}
}
table.insert(BRICKS, brickI)

--[[
    012 012  012 012
  0  XX       X  X  
  1  O  XOX   O  XOX
  2  X    X  XX     
     4   1    2   3
]]
local brickJ = {
  {{0, 1}, {1, 1}, {2, 1}, {2, 2}},
  {{0, 2}, {1, 2}, {1, 1}, {1, 0}},
  {{0, 0}, {0, 1}, {1, 1}, {2, 1}},
  {{2, 0}, {1, 0}, {1, 1}, {1, 2}}
}
table.insert(BRICKS, brickJ)

--[[
    012 012 012 012
  0 XX    X  X     
  1  O  XOX  O  XOX
  2  X       XX X  
     2   3    4  1
]]
local brickL = {
  {{2, 1}, {1, 1}, {0, 1}, {0, 2}},
  {{0, 0}, {1, 0}, {1, 1}, {1, 2}},
  {{2, 0}, {2, 1}, {1, 1}, {0, 1}},
  {{1, 0}, {1, 1}, {1, 2}, {2, 2}}
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
    012 012 012 012
  0  X   XX  X
  1  XO XO   OX  OX
  2   X       X XX
              2  1
]]
local brickS = {
  {{0, 2}, {1, 2}, {1, 1}, {2, 1}},
  --{{1, 0}, {1, 1}, {2, 1}, {2, 2}},
  --{{0, 1}, {1, 1}, {1, 0}, {2, 0}},
  {{0, 0}, {0, 1}, {1, 1}, {1, 2}}
}
table.insert(BRICKS, brickS)

--[[
    012 01 012 012
  0      X  X   X
  1 XOX XO XOX  OX
  2  X   X      X
]]
local brickT = {
  {{0, 1}, {1, 1}, {2, 1}, {1, 2}},
  {{1, 0}, {1, 1}, {1, 2}, {0, 1}},
  {{0, 1}, {1, 1}, {2, 1}, {1, 0}},
  {{1, 0}, {1, 1}, {1, 2}, {2, 1}}
}
table.insert(BRICKS, brickT)

--[[
    012 012 012 012
  0   X      X  XX 
  1  OX XO  XO   OX
  2  X   XX X      
      2   1
]]
local brickZ = {
  {{0, 1}, {1, 1}, {1, 2}, {2, 2}},
  {{2, 0}, {2, 1}, {1, 1}, {1, 2}}
  --{{1, 0}, {1, 1}, {0, 1}, {0, 2}},
  --{{0, 0}, {1, 0}, {1, 1}, {2, 1}}
}

table.insert(BRICKS, brickZ)

function brickFromString(st)
  local br = {}
  local lines = utils.splitLines(st)
  for y, line in pairs(lines) do
    local chars = utils.explodeString(line)
    for x, char in pairs(chars) do
      if char ~= " " then
        table.insert(br, {x - 1, y - 1})
      end
    end
  end
  return br
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

function iterateBoardLine(board, y, fn)
  for x = 1, consts.w do
    fn(board, x, y)
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

function doesBrickHitBoard(brickIdx, brickVar, board, x, y)
  local items = BRICKS[brickIdx][brickVar]
  for k, v in pairs(items) do
    local X = v[1] + x + 1
    if X < 1 or X > consts.w then
      return true
    end
    local Y = v[2] + y + 1
    if Y < 1 then
      -- ignore these, brick not completely inside board
    else
      if Y > consts.h then
        return true
      end
      if board[id2(X, Y)] ~= 0 then
        return true
      end
    end
  end
  return false
end

function applyBrickToBoard(brickIdx, brickVar, board, x, y)
  local items = BRICKS[brickIdx][brickVar]
  for k, v in pairs(items) do
    local X = v[1] + x + 1
    local Y = v[2] + y + 1
    board[id2(X, Y)] = brickIdx
  end
end

function electNearestPosition(brickIdx, brickVar, board, x, y)
  local delta = 0
  if not doesBrickHitBoard(brickIdx, brickVar, board, x, y) then
    return x
  end

  while true do
    delta = delta + 1

    if not doesBrickHitBoard(brickIdx, brickVar, board, x - delta, y) then
      return x - delta
    end

    if not doesBrickHitBoard(brickIdx, brickVar, board, x + delta, y) then
      return x + delta
    end

    if delta > 5 then
      return -1
    end
  end
end

function moveLinesDown(board, sinceY)
  for x = 1, consts.w do
    for y = sinceY, 2, -1 do
      board[id2(x, y)] = board[id2(x, y - 1)]
    end
    board[id2(x, 1)] = 0
  end
end

function isLineFilled(board, y)
  local counter = 0

  function incIfPositive(board, x, y)
    local v = board[id2(x, y)]
    if v > 0 then
      counter = counter + 1
    end
  end

  iterateBoardLine(board, y, incIfPositive)
  return counter == consts.w
end

function computeLines(board)
  local numLines = 0

  function emptyCell(board, x, y)
    board[id2(x, y)] = 0
  end

  local y = consts.h
  while y > 0 do
    if isLineFilled(board, y) then
      numLines = numLines + 1
      iterateBoardLine(board, y, emptyCell)
      moveLinesDown(board, y)
    else
      y = y - 1
    end
  end

  return numLines
end

---- DRAWING FUNCTIONS

local G = love.graphics

local CANVAS

function prepare()
  CANVAS = G.newCanvas(consts.cell, consts.cell)
  G.setCanvas(CANVAS)

  local c = consts.cell
  local gap = c / 6
  local a = gap
  local b = c - gap

  G.setColor(0.5, 0.5, 0.5, 1)
  G.rectangle("fill", 0, 0, consts.cell, consts.cell)

  --[[
    0 a   b c
    a

    b
    c
  ]]
  G.setColor(1, 1, 1, 1)
  G.polygon("fill", 0, 0, c, 0, b, a, a, a, a, b, 0, c, 0, 0)

  G.setColor(0, 0, 0, 1)
  G.polygon("fill", c, c, 0, c, a, b, b, b, b, a, c, 0, c, c)

  G.setCanvas()
end

function drawCell(colorIdx, x, y, isGhost)
  if (colorIdx == 0) then
    return
  end
  local clr = COLORS[colorIdx]
  local alpha = isGhost and 0.25 or 1
  G.setColor(clr[1], clr[2], clr[3], alpha)
  local x1 = consts.x0 + x * consts.cell
  local y1 = consts.y0 + y * consts.cell
  --G.rectangle("fill", x1, y1, consts.cell, consts.cell)
  G.draw(CANVAS, x1, y1)
end

function drawBrick(pos0, brickIdx, brickVar, isGhost)
  local items = BRICKS[brickIdx][brickVar]
  for k, v in pairs(items) do
    local x = pos0[1] + v[1]
    local y = pos0[2] + v[2]
    drawCell(brickIdx, x, y, isGhost)
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
      local alpha = (x + y) % 2 == 0 and 0.075 or 0.05
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
  electNearestPosition = electNearestPosition,
  computeLines = computeLines,
  prepare = prepare,
  drawCell = drawCell,
  drawBrick = drawBrick,
  drawBoard = drawBoard,
  drawBoardBackground = drawBoardBackground
}
