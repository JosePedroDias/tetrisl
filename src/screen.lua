-- https://github.com/JosePedroDias/7min/blob/master/src/screen.moon
-- https://github.com/Ulydev/push

local G = love.graphics

local M = {}

local scale, x, y, canvas

M.getCurrentResolution = function()
  --return 640, 480

  local os = love._os
  local sW, sH, scl

  if os == "Windows" then
    sW = 2736
    sH = 1824
    scl = 2
  elseif os == "Android" then
    sW, sH = love.window.getMode()
    scl = love.window.getDPIScale() or 1
  else
    sW, sH = love.window.getMode()
    scl = love.window.getDPIScale() or 1
  end
  return sW / scl, sH / scl
end

M.getLowestResolution = function()
  local modes = love.window.getFullscreenModes()
  local wi = 100000
  local hi = 100000
  local area = 100000 * 100000
  local modes = love.window.getFullscreenModes()
  for _, m in pairs(modes) do
    local areaT = m.width * m.height
    if areaT < area then
      wi = m.width
      hi = m.height
      area = areaT
    end
  end
  return wi, hi
end

M.getHighestResolution = function()
  local modes = love.window.getFullscreenModes()
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

  love.window.setMode(W, H, {fullscreen = fullscreen, highdpi = false})

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
