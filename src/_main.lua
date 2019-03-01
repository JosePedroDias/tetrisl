local consts = require "src.consts"
local screen = require "src.screen"
local stages = require "src.stages"
local settings = require "src.settings"
local assets = require "src.assets"

local menu = require "src.menu"
local game = require "src.game"
local arcadeinput = require "src.arcadeinput"
local highscores = require "src.highscores"

local G = love.graphics

function love.load()
  settings.load()

  love.keyboard.setKeyRepeat(true)

  -- image resolution fix
  local sW, sH = screen.getCurrentResolution()
  screen.setSize(sW, sH, consts.W, consts.H, true)

  -- load resources
  assets.load()

  stages.setStage("menu", menu)
  stages.setStage("game", game)
  stages.setStage("arcadeinput", arcadeinput)
  stages.setStage("highscores", highscores)

  stages.toStage("menu")

  settings.load()
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

function love.keyreleased(key, scancode, is_repeat)
  stages.currentStage.onKeyUp(key)
end

function love.mousepressed(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointer(x, y)
end

function love.mousemoved(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointerMove(x, y)
end

function love.mousereleased(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointerUp(x, y)
end
