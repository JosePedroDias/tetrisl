local consts = require("src.consts")

local PIECE = {}
PIECE.I = 1
PIECE.J = 2
PIECE.L = 3
PIECE.O = 4
PIECE.S = 5
PIECE.T = 6
PIECE.Z = 7

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

-- print("colors", #COLORS)

local G = love.graphics

function drawCell(colorIdx, x, y)
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

function drawBoard()
  for y = 0, consts.h - 1 do
    for x = 0, consts.w - 1 do
      local alpha = (x + y) % 2 == 0 and 0.2 or 0.1
      G.setColor(1, 1, 1, alpha)
      G.rectangle("fill", consts.x0 + x * consts.cell, consts.y0 + y * consts.cell, consts.cell, consts.cell)
    end
  end
end

return {
  BRICKS = BRICKS,
  drawCell = drawCell,
  drawBrick = drawBrick,
  drawBoard = drawBoard
}

--[[ 
exports.BRICKS = {{{{0, 0}, {1, 0}, {2, 0}, {3, 0}}, {{0, 0}, {0, 1}, {0, 2}, {0, 3}}}};
local G = love.graphics;
exports.drawCell = function(colorIndex, x, y)
    local color = exports.COLORS[colorIndex + 1];
    G.setColor(color[exports.CHANNEL.R], color[exports.CHANNEL.B], color[exports.CHANNEL.B], 1);
    G.rectangle("fill", (x * cellSize) + x0, (y * cellSize) + y0, cellSize, cellSize);
end;
exports.drawPiece = function(colorIndex, variant, x, y)
    print(#exports.BRICKS);
    print(not (not exports.BRICKS[0 + 1]));
    print(not (not exports.BRICKS[1 + 1]));
    local brick = exports.BRICKS[colorIndex + 1];
    print(1);
    local bVar = brick[variant + 1];
    print(2);
    error("boo");
end;
exports.drawBoard = function()
    local y = 0;
    while y < h do
        do
            local x = 0;
            while x < w do
                do
                    local alpha = ((((x + y) % 2) == 0) and 0.2) or 0.1;
                    G.setColor(1, 1, 1, alpha);
                    G.rectangle("fill", (x * cellSize) + x0, (y * cellSize) + y0, cellSize, cellSize);
                end
                ::__continue4::
                x = x + 1;
            end
        end
        ::__continue3::
        y = y + 1;
    end
    exports.drawPiece(0, 1, 0, 0);
end;
return exports;
 ]]
