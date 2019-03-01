local consts = require "src.consts"
local utils = require "src.utils"
local scoreboard = require "src.scoreboard"
local stages = require "src.stages"

local G = love.graphics

local M = {}

local scores = {}
local t

M.load = function()
  t = 0
  scores = scoreboard.load()
end

M.update = function(dt)
  t = t + dt
  if t > 3 then
    stages.toStage("menu")
  end
end

M.draw = function()
  local dy = 30
  local x = consts.W / 2
  local y = (consts.H - dy * 10) / 2

  G.setColor(1, 1, 1, 1)
  local f = G.getFont()

  local l = "H I G H   S C O R E S"
  local w = f:getWidth(l)
  G.print(l, x - w / 2, y - dy)

  for i, row in ipairs(scores) do
    local l = row[1] .. " ... " .. row[2]
    local w = f:getWidth(l)
    G.print(l, x - w / 2, y + i * dy)
  end
end

M.onKey = function(key)
  stages.toStage("menu")
end

return M
