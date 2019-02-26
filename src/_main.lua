local consts = require "src.consts"
local screen = require "src.screen"
local stages = require "src.stages"

local menu = require "src.menu"
local game = require "src.game"
local arcadeinput = require "src.arcadeinput"
local highscores = require "src.highscores"

-- local scoreboard = require "src.scoreboard"

local G = love.graphics

function love.load()
  -- scoreboard.load()
  -- scoreboard.add("tony", 42)

  love.keyboard.setKeyRepeat(true)

  -- image resolution fix
  local sW, sH = screen.getCurrentResolution()
  -- print("screenDims: " .. sW .. " x " .. sH)
  screen.setSize(sW, sH, consts.W, consts.H, true)

  -- load resources
  local f1 =
    G.newImageFont(
    "fonts/1.png",
    ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`\'*#=[]"'
  )
  G.setFont(f1)
  tickSfx = love.audio.newSource("sounds/tick.ogg", "static")
  doneSfx = love.audio.newSource("sounds/done.ogg", "static")

  stages.setStage("menu", menu)
  stages.setStage("game", game)
  stages.setStage("arcadeinput", arcadeinput)
  stages.setStage("highscores", highscores)

  stages.toStage("menu")
end

function love.update(dt)
  stages.currentStage.update(dt)
end

function love.draw()
  screen.startDraw()
  stages.currentStage.draw()
  screen.endDraw()
end

function love.keypressed(key, scancode, is_repeat)
  stages.currentStage.onKey(key)
end

function love.mousepressed(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointer(x, y)
end
