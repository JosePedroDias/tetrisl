local M = {}

M.W = 800
M.H = 600

M.w = 10
M.h = 20
M.cell = 22

local _w = M.w * M.cell
local _h = M.h * M.cell

M.x0 = (M.W - _w) / 2
M.y0 = (M.H - _h) / 2

return M
