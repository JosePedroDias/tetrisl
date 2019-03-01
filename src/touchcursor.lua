local M = {}

local G = love.graphics

local size = 46
local dist = 5
local pos = {8.5 * size, 8 * size}

local buttons
local isDown
local callbacks = {}
local callbackNames = {"up", "left", "right", "down", "a", "b"}

-- TODO: emulate key repeat to trigger additional cbs

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

  isDown = {}
  for i = 1, #buttons do
    isDown[i] = false
  end
end

computeGeometry()

M.setCallbacks = function(cbs)
  callbacks = cbs
end

M.draw = function()
  G.setColor(1, 1, 1, 0.75)
  for i, p in ipairs(buttons) do
    G.rectangle(isDown[i] and "fill" or "line", p[1], p[2], size, size)
  end
end

M.onPointer = function(x, y)
  for i, b in ipairs(buttons) do
    if x >= b[1] and x <= b[1] + size and y > b[2] and y <= b[2] + size then
      local cb = callbacks[callbackNames[i]]
      if cb ~= nil then
        cb()
      end
    end
  end
end

return M
