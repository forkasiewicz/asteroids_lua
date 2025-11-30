local Line = require("line")
local Vec = require("vector")

local pi, tau = math.pi, math.pi * 2

local Asteroid = {}
Asteroid.__index = Asteroid

Asteroid.all = {}

local function spawn_asteroid(margin)
  local side = math.random(1, 4)

  if side == 1 then
    -- left
    return Vec.new(
      math.random(-margin, -1),
      math.random(0, WINDOW_HEIGHT)
    )
  elseif side == 2 then
    -- right
    return Vec.new(
      math.random(WINDOW_WIDTH + 1, WINDOW_WIDTH + margin),
      math.random(0, WINDOW_HEIGHT)
    )
  elseif side == 3 then
    -- top
    return Vec.new(
      math.random(0, WINDOW_WIDTH),
      math.random(-margin, -1)
    )
  else
    -- bottom
    return Vec.new(
      math.random(0, WINDOW_WIDTH),
      math.random(WINDOW_HEIGHT + 1, WINDOW_HEIGHT + margin)
    )
  end
end

function Asteroid.new(size)
  local n = 10 -- amount of points
  local lines = {}
  local points = {}
  for i = 1, n do
    local rand = math.random(size / 2, size)
    points[i] = Vec.new(rand, 0):rot(
    -- derived from 360 / n and pi / 180
      (2 / n) * i * pi
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

  asteroid.pos = spawn_asteroid(100)
  asteroid.speed = Vec.new(
        math.random(150, WINDOW_WIDTH - 300),
        math.random(150, WINDOW_HEIGHT - 300)
      )
      :sub(asteroid.pos)
      :normalized()
      :scale(200)
  table.insert(Asteroid.all, asteroid)
  return setmetatable(asteroid, Asteroid)
end

return Asteroid
