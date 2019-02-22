local socket = require "socket"

local udp = socket.udp()
udp:settimeout(0)
udp:setsockname("*", 12345)

local world = {}
local data, msg_or_ip, port_or_nil
local entity, cmd, parms
local running = true

print "Beginning server loop."
while running do
  data, msg_or_ip, port_or_nil = udp:receivefrom()
  if data then
    entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
    if cmd == "move" then
      local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
      assert(x and y)

      x, y = tonumber(x), tonumber(y)

      local ent = world[entity] or {x = 0, y = 0}
      world[entity] = {x = ent.x + x, y = ent.y + y}
    elseif cmd == "at" then
      local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
      assert(x and y)
      x, y = tonumber(x), tonumber(y)
      world[entity] = {x = x, y = y}
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
    error("Unknown network error: " .. tostring(msg))
  end

  socket.sleep(0.01)
end
