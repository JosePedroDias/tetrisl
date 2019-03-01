local M = {fonts = {}, sfx = {}, music = {}, gfx = {}}

local CHARS = ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.!?;:-_/|\\!\'"+*()[]{}&%$#@'

M.load = function()
  local f1 =
    love.graphics.newImageFont(
    "fonts/1.png", -- greyscale_basic_bold greatlakes 1
    CHARS
  )
  love.graphics.setFont(f1)

  M.fonts["1"] = f1

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
