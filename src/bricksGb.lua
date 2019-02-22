function setBricks(BRICKS)
  --[[
    01234 01234 01234 01234
  0               X        
  1   X           X        
  2   O    XOXX   O   XXOX 
  3   X           X        
  4   X  

]]
  local brickI = {
    {{0, 1}, {1, 1}, {2, 1}, {3, 1}},
    {{2, -1}, {2, 0}, {2, 1}, {2, 2}}
  }
  table.insert(BRICKS, brickI)

  --[[
    012 012  012 012
  0  XX       X  X  
  1  O  XOX   O  XOX
  2  X    X  XX     
     4   1    2   3
]]
  local brickJ = {
    {{0, 1}, {1, 1}, {2, 1}, {2, 2}},
    {{0, 2}, {1, 2}, {1, 1}, {1, 0}},
    {{0, 0}, {0, 1}, {1, 1}, {2, 1}},
    {{2, 0}, {1, 0}, {1, 1}, {1, 2}}
  }
  table.insert(BRICKS, brickJ)

  --[[
    012 012 012 012
  0 XX    X  X     
  1  O  XOX  O  XOX
  2  X       XX X  
     2   3    4  1
]]
  local brickL = {
    {{2, 1}, {1, 1}, {0, 1}, {0, 2}},
    {{0, 0}, {1, 0}, {1, 1}, {1, 2}},
    {{2, 0}, {2, 1}, {1, 1}, {0, 1}},
    {{1, 0}, {1, 1}, {1, 2}, {2, 2}}
  }
  table.insert(BRICKS, brickL)

  --[[
    01
  0 XX
  1 XX
]]
  local brickO = {
    {{0, 0}, {0, 1}, {1, 0}, {1, 1}}
  }
  table.insert(BRICKS, brickO)

  --[[
    012 012 012 012
  0  X   XX  X
  1  XO XO   OX  OX
  2   X       X XX
              2  1
]]
  local brickS = {
    {{0, 2}, {1, 2}, {1, 1}, {2, 1}},
    {{0, 0}, {0, 1}, {1, 1}, {1, 2}}
  }
  table.insert(BRICKS, brickS)

  --[[
    012 01 012 012
  0      X  X   X
  1 XOX XO XOX  OX
  2  X   X      X
]]
  local brickT = {
    {{0, 1}, {1, 1}, {2, 1}, {1, 2}},
    {{1, 0}, {1, 1}, {1, 2}, {0, 1}},
    {{0, 1}, {1, 1}, {2, 1}, {1, 0}},
    {{1, 0}, {1, 1}, {1, 2}, {2, 1}}
  }
  table.insert(BRICKS, brickT)

  --[[
    012 012 012 012
  0   X      X  XX 
  1  OX XO  XO   OX
  2  X   XX X      
      2   1
]]
  local brickZ = {
    {{0, 1}, {1, 1}, {1, 2}, {2, 2}},
    {{2, 0}, {2, 1}, {1, 1}, {1, 2}}
  }

  table.insert(BRICKS, brickZ)
end

return setBricks
