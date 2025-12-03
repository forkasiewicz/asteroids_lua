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

function Asteroid.new(size)
  local n = 10 -- amount of draw_points
  local draw_lines = {}
  local draw_points = {}
  local collision_lines = {}
  local collision_points = {}
  for i = 1, n do
    local rand = math.random(size / 2, size)
    draw_points[i] = Vec.new(rand, 0):rot(
    -- derived from 360 / n and pi / 180
      (2 / n) * i * pi
    )

    collision_points[i] = Vec.new(size, 0):rot(
    -- derived from 360 / n and pi / 180
      (2 / n) * i * pi
    )
  end
  for i = 1, n do
    if i < n then
      draw_lines[i] = Line.new(
        draw_points[i],
        draw_points[i + 1]
      )

      collision_lines[i] = Line.new(
        collision_points[i],
        collision_points[i + 1]
      )
    else
      draw_lines[i] = Line.new(
        draw_points[i],
        draw_points[1]
      )

      collision_lines[i] = Line.new(
        collision_points[i],
        collision_points[1]
      )
    end
  end

  local pos = spawn_asteroid(100)

  local asteroid = setmetatable({
    pos = pos,
    size = size,
    speed = Vec.new(
          math.random(150, WINDOW_WIDTH - 300),
          math.random(150, WINDOW_HEIGHT - 300)
        )
        :sub(pos)
        :normalized()
        :scale(200),
    draw_lines = draw_lines,
    collision_lines = collision_lines
  }, Asteroid)

  table.insert(Asteroid.all, asteroid)

  return asteroid
end

function Asteroid:update(dt)
  self.pos = self.pos:add(self.speed:scale(dt))

  -- teleport asteroid to the other side of the screen
  self.pos.x = self.pos.x % (WINDOW_WIDTH + 100)
  self.pos.y = self.pos.y % (WINDOW_HEIGHT + 100)
end

function Asteroid:draw()
  for _, line in ipairs(self.draw_lines) do
    line = line:addVec(self.pos):draw()
  end

  -- debug
  for _, line in ipairs(self.collision_lines) do
    love.graphics.setColor(255, 0, 0)
    line = line:addVec(self.pos):draw()
    love.graphics.setColor(255, 255, 255)
  end
end

return Asteroid
