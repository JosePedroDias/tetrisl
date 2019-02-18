local utils = require("src.utils")

local function test_split()
  local a = "a b cddd"
  local res = utils.split(a, " ")
  assert(utils.join(res, ",") == "a,b,cddd")

  local b = "a,b,ddd"
  local res2 = utils.split(b, ",")
  assert(utils.join(res2, ",") == "a,b,ddd")
end

local function test_splitLines()
  local a = [[one
two three
   
five]]
  local res = utils.splitLines(a)
  assert(utils.join(res, ",") == "one,two three,   ,five")
end

local function test_join()
  local s = utils.join({"ab c", "DEF", 12}, ",")
  assert(s == "ab c,DEF,12")
end

local function test_explodeString()
  local s = "hello"
  local arr = utils.explodeString(s)
  local s2 = utils.join(arr, ",")
  assert(s2 == "h,e,l,l,o")
end
