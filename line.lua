local Line = {}
Line.__index = Line

function Line.new(vector1, vector2)
  return setmetatable({ vector1 = vector1, vector2 = vector2 }, Line)
end

function Line:addVec(vector)
  return Line.new(
    self.vector1:add(vector),
    self.vector2:add(vector)
  )
end

function Line:scale(n)
  return Line.new(
    self.vector1:scale(n),
    self.vector2:scale(n)
  )
end

function Line:rot(n)
  return Line.new(
    self.vector1:rot(n),
    self.vector2:rot(n)
  )
end

-- credit to https://stackoverflow.com/a/9997374
function Line:intersects(line)
  local function ccw(A, B, C)
    return (C.y - A.y) * (B.x - A.x) > (B.y - A.y) * (C.x - A.x)
  end

  local A = self.vector1
  local B = self.vector2
  local C = line.vector1
  local D = line.vector2

  return ccw(A, C, D) ~= ccw(B, C, D) and ccw(A, B, C) ~= ccw(A, B, D)
end

function Line:draw()
  return love.graphics.line(
    self.vector1.x, self.vector1.y, self.vector2.x, self.vector2.y
  )
end

return Line
