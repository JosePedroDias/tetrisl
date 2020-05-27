--[[ stage abstraction to have different handlers per screen
take a look at main.lua to check how this is set up ]] --
local M = {currentStage = nil}

local stages = {}

local function noop()
end

local api = {
  "load", "focus", "update", "draw", "onKey", "onKeyUp", "onPointer",
  "onPointerMove", "onPointerUp", "onTextInput", "unload"
}

M.setStage = function(stageName, stageValue)
  stages[stageName] = stageValue

  for _, methodName in pairs(api) do
    if stageValue[methodName] == nil then stageValue[methodName] = noop end
  end
end

M.toStage = function(stageName, hurdle)
  if M.currentStage then M.currentStage.unload() end
  M.currentStage = stages[stageName]
  M.currentStage.load(hurdle)
end

M.exit = function()
  M.currentStage.unload()
  love.event.quit()
end

return M
