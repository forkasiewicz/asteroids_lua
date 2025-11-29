local Line = require("line")
local Vec = require("vector")

local Asteroid = {}
Asteroid.__index = Asteroid

Asteroid.all = {}

function Asteroid.new(pos, size)
  local n = 10 -- amount of points
  local lines = {}
  local points = {}
  for i = 1, n do
    local rand = math.random(size / 2, size)
    points[i] = Vec.new(rand, 0):rot(
    -- derived from 360 / n and pi / 180
      (2 / n) * i * math.pi
    )
  end
  for i = 1, n do
    if i < n then
      lines[i] = Line.new(
        points[i],
        points[i + 1]
      )
    else
      lines[i] = Line.new(
        points[i],
        points[1]
      )
    end
  end

  -- for consistency's sake
  local asteroid = lines

  asteroid.speed = Vec.new(math.random(100, 200), 0):rot(math.random() * math.pi)
  asteroid.pos = pos
  table.insert(Asteroid.all, asteroid)
  return setmetatable(asteroid, Asteroid)
end

return Asteroid
