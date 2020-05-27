--[[ this is an optional overlay to be used on mobile devices ]] --
local utils = require "utils"

local M = {}

local G = love.graphics

local REPEAT_MS = 0.2

local size = 70
local dist = 4
local pos = {7.75 * size, 5 * size}

local buttons
local isDown
local callbacks = {}
local callbackNames = {"up", "left", "right", "down", "a", "b"}

local isMobile = utils.isMobile()

local function fireKey(i)
  local cb = callbacks[callbackNames[i]]
  if cb ~= nil then cb() end
end

local function pressingButton(x, y)
  for i, b in ipairs(buttons) do
    if x >= b[1] and x <= b[1] + size and y > b[2] and y <= b[2] + size then
      return i
    end
  end
end

local function computeGeometry()
  local p1 = pos[1]
  local p2 = pos[2]
  local sz = size + dist
  local sz2 = sz * 2

  buttons = {}
  table.insert(buttons, {p1 + sz, p2})
  table.insert(buttons, {p1, p2 + sz})
  table.insert(buttons, {p1 + sz2, p2 + sz})
  table.insert(buttons, {p1 + sz, p2 + sz2})
  table.insert(buttons, {p1 - sz * 5 - sz, p2 + sz2})
  table.insert(buttons, {p1 - sz * 5, p2 + sz2})

  isDown = utils.times(#buttons, function()
    return false
  end)
end

computeGeometry()

M.setCallbacks = function(cbs)
  callbacks = cbs
end

M.update = function(dt)
  for i = 1, #buttons do
    if isDown[i] then
      isDown[i] = isDown[i] + dt

      if isDown[i] > REPEAT_MS then
        isDown[i] = isDown[i] - REPEAT_MS
        fireKey(i)
      end
    end
  end
end

M.draw = function()
  if not isMobile then return end

  G.setColor(1, 1, 1, 0.75)
  for i, p in ipairs(buttons) do
    G.rectangle(isDown[i] and "fill" or "line", p[1], p[2], size, size)
  end
end

M.onPointer = function(x, y)
  if not isMobile then return end

  local i = pressingButton(x, y)
  if not i then return end

  isDown[i] = 0

  fireKey(i)
end

M.onPointerUp = function(x, y)
  if not isMobile then return end

  --[[   local i = pressingButton(x, y)
  if not i then
    return
  end

  isDown[i] = false ]]
  -- exclusive mode, ie, having an up unpresses all buttons
  isDown = utils.map(isDown, function()
    return false
  end)
end

return M
