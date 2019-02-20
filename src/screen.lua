-- https://github.com/JosePedroDias/7min/blob/master/src/screen.moon
-- https://github.com/Ulydev/push

local G = love.graphics

local M = {}

local scale, x, y, canvas

M.getHighestResolution = function()
  -- local modes = love.window.getFullscreenModes()
  -- for _, m in pairs(modes) do
  --   print(m.width, m.height)
  -- end

  return 640, 480

  -- local wi = 0
  -- local hi = 0
  -- local area = 0
  -- local modes = love.window.getFullscreenModes()
  -- for _, m in pairs(modes) do
  --   local areaT = m.width * m.height
  --   if areaT > area then
  --     wi = m.width
  --     hi = m.height
  --     area = areaT
  --   end
  -- end
  -- return wi, hi
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
  --G.setBlendMode("alpha", "alphamultiply") -- premultiplied alphamultiply
  -- canvas.setFilter('nearest')
  G.setDefaultFilter("nearest", "nearest") -- min mag (linear / nearest) ani
end

M.startDraw = function()
  G.setCanvas(canvas)
  G.clear(0, 0, 0, 1)
end

M.endDraw = function()
  G.setCanvas()
  G.draw(canvas, x, y, 0, scale, scale)
end

M.coords = function(_x, _y)
  return (_x - x) / scale, (_y - y) / scale
end

return M
