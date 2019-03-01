local M = {
  currentStage = nil
}

local stages = {}

local function noop()
end

local api = {"load", "update", "draw", "onKey", "onKeyUp", "onPointer", "onPointerMove", "onPointerUp", "unload"}

M.setStage = function(stageName, stageValue)
  stages[stageName] = stageValue

  for _, methodName in pairs(api) do
    if stageValue[methodName] == nil then
      stageValue[methodName] = noop
    end
  end
end

M.toStage = function(stageName, hurdle)
  if M.currentStage then
    M.currentStage.unload()
  end
  M.currentStage = stages[stageName]
  M.currentStage.load(hurdle)
end

M.exit = function()
  M.currentStage.unload()
  love.event.quit()
end

return M
