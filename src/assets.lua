local M = {fonts = {}, sfx = {}, music = {}, gfx = {}}

M.load = function()
  local notoF = love.graphics.newFont("fonts/permanent_marker.fnt")
  love.graphics.setFont(notoF)

  M.fonts["noto"] = notoF

  local dropSfx = love.audio.newSource("sounds/drop.ogg", "static")
  local dropHardSfx = love.audio.newSource("sounds/drop_hard.ogg", "static")
  local levelUpSfx = love.audio.newSource("sounds/level_up.ogg", "static")
  local lineSfx = love.audio.newSource("sounds/line.ogg", "static")
  local moveSfx = love.audio.newSource("sounds/move.ogg", "static")
  local rotateSfx = love.audio.newSource("sounds/rotate.ogg", "static")

  M.sfx["drop"] = dropSfx
  M.sfx["dropHard"] = dropHardSfx
  M.sfx["levelUp"] = levelUpSfx
  M.sfx["line"] = lineSfx
  M.sfx["move"] = moveSfx
  M.sfx["rotate"] = rotateSfx

  local swingjedingMusic = love.audio.newSource("sounds/swingjeding.ogg", "stream")

  M.music["swingjeding"] = swingjedingMusic
end

return M
