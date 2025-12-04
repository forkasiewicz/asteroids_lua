local Vec = require "vector"
local Line = require "line"

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

function Asteroid.new(size,
    --[[optional]] spawn_pos,
    --[[optional]] spawn_speed
)
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

  local pos
  local speed

  if spawn_pos == nil then
    pos = spawn_asteroid(100)
    speed = Vec.new(
          math.random(150, WINDOW_WIDTH - 300),
          math.random(150, WINDOW_HEIGHT - 300)
        )
        :sub(pos)
        :normalized()
        :scale(200)
  else
    pos = spawn_pos
    speed = spawn_speed:scale(
      math.random(75, 150) * 0.01):rot(math.random(-50, 50) * (pi / 180)
    )
  end

  local asteroid = setmetatable({
    pos = pos,
    size = size,
    speed = speed,
    lines = lines,
    split = false
  }, Asteroid)

  table.insert(Asteroid.all, asteroid)

  return asteroid
end

function Asteroid:update(dt)
  for i, asteroid in ipairs(Asteroid.all) do
    if asteroid == self then
      if self.split then
        table.remove(Asteroid.all, i)
        if asteroid.size == ASTEROID_SIZE / 4 then
          table.remove(Asteroid.all, i)
          break
        else
          Asteroid.new(asteroid.size / 2, asteroid.pos, asteroid.speed)
          Asteroid.new(asteroid.size / 2, asteroid.pos, asteroid.speed)
        end
      end
    end
  end

  self.pos = self.pos:add(self.speed:scale(dt))

  -- teleport asteroid to the other side of the screen
  self.pos.x = self.pos.x % (WINDOW_WIDTH + 100)
  self.pos.y = self.pos.y % (WINDOW_HEIGHT + 100)
end

function Asteroid:draw()
  for _, line in ipairs(self.lines) do
    line = line:addVec(self.pos):draw()
  end
end

return Asteroid
