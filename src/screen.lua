-- https://github.com/JosePedroDias/7min/blob/master/src/screen.moon
-- https://github.com/Ulydev/push

local G = love.graphics

local M = {}

local scale, x, y
local canvas

M.getHighestResolution = function()
  -- return {800, 600}

  local wi = 0
  local hi = 0
  local area = 0
  local modes = love.window.getFullscreenModes()
  for _, m in pairs(modes) do
    local areaT = m.width * m.height
    if areaT > area then
      wi = m.width
      hi = m.height
      area = areaT
    end
  end
  return wi, hi
end

M.setSize = function(W, H, w, h, fullscreen)
  local AR = W / H
  local ar = w / h

  if AR > ar then
    scale = H / h
    y = 0
    x = (W - w * scale) / 2
  else
    scale = W / w
    x = 0
    y = (H - h * scale) / 2
  end

  love.window.setMode(W, H, {fullscreen = fullscreen})

  canvas = G.newCanvas(w, h)
  -- canvas.setFilter('nearest')
end

M.startDraw = function()
  G.setCanvas(canvas)
  G.clear(0, 0, 0, 0)
end

M.endDraw = function()
  G.setCanvas()
  G.draw(canvas, x, y, 0, scale, scale)
end

M.coords = function(_x, _y)
  return (_x - x) / scale, (_y - y) / scale
end

return M
