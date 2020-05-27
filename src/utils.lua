--[[ Swiss army knife of sorts ]] --
local M = {}

M.toFixed = function(n, digits)
  return string.format("%." .. tostring(digits) .. "f", n)
end

M.tableToString = function(tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs(tt) do
      table.insert(sb, string.rep(" ", indent)) -- indent it
      if type(value) == "table" and not done[value] then
        done[value] = true
        table.insert(sb, key .. " = {\n")
        table.insert(sb, M.tableToString(value, indent + 2, done))
        table.insert(sb, string.rep(" ", indent)) -- indent it
        table.insert(sb, "}\n")
      elseif "number" == type(key) then
        if (type(value) == "string") then
          table.insert(sb, string.format("%s = \"%s\"\n", tostring(key),
                                         tostring(value)))
        else
          table.insert(sb, string.format("%s = %s\n", tostring(key),
                                         tostring(value)))
        end
      else
        if (type(value) == "string") then
          table.insert(sb, string.format("\"%s\" = \"%s\"\n", tostring(key),
                                         tostring(value)))
        else
          table.insert(sb, string.format("\"%s\" = %s\n", tostring(key),
                                         tostring(value)))
        end
      end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

M.toString = function(tbl)
  if "nil" == type(tbl) then
    return tostring(nil)
  elseif "table" == type(tbl) then
    return M.tableToString(tbl)
  elseif "string" == type(tbl) then
    return "\"" .. tbl .. "\""
  else
    return tostring(tbl)
  end
end

M.keyValueToString = function(tbl)
  local s = ""
  for k, v in pairs(tbl) do s = s + k .. " -> " .. v .. "\n" end
  return s
end

M.arrayToString = function(tbl)
  local s = ""
  local len = M.tableLength(tbl)
  local i = 1
  for _, v in pairs(tbl) do
    if type(v) == "string" then v = "\"" .. v .. "\"" end
    if i < len then
      s = s .. v .. ", "
    else
      s = s .. v
    end
    i = i + 1
  end
  return s
end

M.push = function(arr, item)
  table.insert(arr, item)
  return arr
end

M.pop = function(arr)
  return table.remove(arr, #arr)
end

M.shift = function(arr, item)
  table.insert(arr, 1, item)
  return arr
end

M.unshift = function(arr)
  return table.remove(arr, 1)
end

M.slice = function(arr, start, stop)
  local res = {}
  start = start or 1
  stop = stop or #arr
  for i = start, stop do table.insert(res, arr[i]) end
  return res
end

M.times = function(n, fn)
  fn = fn or function(i)
    return i
  end
  local arr = {}
  for i = 1, n do table.insert(arr, fn(i)) end
  return arr
end

M.split = function(st, sep)
  if sep == nil then sep = "%s" end
  local matches = {}
  for subSt in string.gmatch(st, "([^" .. sep .. "]+)") do
    table.insert(matches, subSt)
  end
  return matches
end

M.splitLines = function(st)
  return M.split(st, "\n")
end

M.tableLength = function(tbl)
  local len = 0
  for _, _ in pairs(tbl) do len = len + 1 end
  return len
end

M.has = function(tbl, item)
  for _, v in pairs(tbl) do if v == item then return true end end
  return false
end

M.indexOf = function(tbl, item)
  for i, v in ipairs(tbl) do if v == item then return i end end
end

M.map = function(tbl, cb)
  local res = {}
  for i, v in ipairs(tbl) do table.insert(res, cb(v, i)) end
  return res
end

M.join = function(tbl, sep)
  sep = sep or ""
  return table.concat(tbl, sep)
end

M.explodeString = function(st)
  local len = string.len(st)
  local arr = {}
  for i = 1, len do table.insert(arr, string.sub(st, i, i)) end
  return arr
end

M.deepEqual = function(t1, t2)
  local t = type(t1)
  if t ~= type(t2) then
    print("different type: " .. t .. " ~= " .. type(t2))
    return false
  end
  if t ~= "table" then
    if t1 ~= t2 then print("values differ: " .. t1 .. " ~= " .. t2) end
    return t1 == t2
  end

  for k1, v1 in pairs(t1) do
    local v2 = t2[k1]
    if not M.deepEqual(v1, v2) then return false end
  end

  for k2, v2 in pairs(t2) do
    local v1 = t1[k2]
    if v2 and not v1 then
      print("ommitted key in 1st table: " .. k2)
      return false
    end
  end

  return true
end

-----

M.minus = function(v, minV, maxV, dontLoop)
  if v == minV then
    if dontLoop then
      return v
    else
      return maxV
    end
  end
  return v - 1
end

M.plus = function(v, minV, maxV, dontLoop)
  if v == maxV then
    if dontLoop then
      return v
    else
      return minV
    end
  end
  return v + 1
end

M.isMobile = function()
  local os = love.system.getOS()
  return os == "Android" or os == "iOS"
end

return M
