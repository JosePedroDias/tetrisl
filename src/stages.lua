local M = {
  currentStage = nil
}

local stages = {}

M.setStage = function(stageName, stageValue)
  stages[stageName] = stageValue
end

M.toStage = function(stageName)
  if M.currentStage then
    M.currentStage.unload()
  end
  M.currentStage = stages[stageName]
  M.currentStage.load()
end

M.exit = function()
  M.currentStage.unload()
  love.event.quit()
end

return M
