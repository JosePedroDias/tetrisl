local socket = require "socket"

-- local lovebird = require "lovebird"

local udp
local address, port = "127.0.0.1", 12345
local t = 0
local DELTA_REFRESH = 0.5
local nextRefresh = t + DELTA_REFRESH
local dx = 10

math.randomseed(os.time())

local world = {}
local myEntityId = tostring(math.random(99999))
world[myEntityId] = {x = 320, y = 240}

local function requestUpdate()
  udp:send(myEntityId .. " update $")
end

function love.load()
  love.keyboard.setKeyRepeat(true)

  udp = socket.udp()
  udp:settimeout(0)
  udp:setpeername(address, port)

  requestUpdate()
end

function love.update(dt)
  -- lovebird.update()

  t = t + dt

  if t > nextRefresh then
    requestUpdate()
    nextRefresh = t + DELTA_REFRESH
  end

  repeat
    local data, msg = udp:receive()

    if data then
      local ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
      if cmd == "at" then
        local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
        x, y = tonumber(x), tonumber(y)
        world[ent] = {x = x, y = y}
      else
        print("unrecognised command:", cmd)
      end
    elseif msg ~= "timeout" then
      error("Network error: " .. tostring(msg))
    end
  until not data
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  for k, v in pairs(world) do
    love.graphics.print(k, v.x, v.y)
  end
end

function love.keypressed(key) --, scancode, isRepeat)
  local ent = world[myEntityId]
  if key == "up" then
    ent.y = ent.y - dx
  elseif key == "down" then
    ent.y = ent.y + dx
  elseif key == "left" then
    ent.x = ent.x - dx
  elseif key == "right" then
    ent.x = ent.x + dx
  elseif key == "q" then
    udp:send(myEntityId .. " quit $")
  elseif key == "escape" then
    love.event.quit()
  end

  udp:send(myEntityId .. " at " .. ent.x .. " " .. ent.y)
end
