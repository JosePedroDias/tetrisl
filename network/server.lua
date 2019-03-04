local socket = require "socket"

local lovebird = require "src.lovebird"

local udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*", 12345)

local world = {}
local running = true

_G.world = world

print "Beginning server loop."
while running do
  lovebird.update()

  local data, msg_or_ip, port_or_nil = udp:receivefrom()
  if data then
    local entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
    if cmd == "at" then
      local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
      assert(x and y)
      x, y = tonumber(x), tonumber(y)
      world[entity] = {x = x, y = y}
      print(entity .. " -> { " .. "x:" .. x .. ", y:" .. y .. " }")
    elseif cmd == "update" then
      for k, v in pairs(world) do
        udp:sendto(string.format("%s %s %d %d", k, "at", v.x, v.y), msg_or_ip, port_or_nil)
      end
    elseif cmd == "quit" then
      running = false
    else
      print("unrecognised command:", cmd)
    end
  elseif msg_or_ip ~= "timeout" then
    error("Unknown network error: " .. tostring(msg_or_ip))
  end

  socket.sleep(0.01)
end
