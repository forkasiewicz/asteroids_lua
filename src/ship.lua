local Vec = require "libs.vector"
local Line = require "libs.line"

local Ship = {}
Ship.__index = Ship

function Ship.new(pos, speed, rot_speed, drag, size)
  local lines = {
    Line.new(Vec.new(-30, 30), Vec.new(45, 0)),
    Line.new(Vec.new(-30, -30), Vec.new(-25, -25)),
    Line.new(Vec.new(-25, 25), Vec.new(-25, -25)),
    Line.new(Vec.new(-25, 25), Vec.new(-30, 30)),
    Line.new(Vec.new(-30, -30), Vec.new(45, 0)),
  }

  local thruster_lines = {
    Line.new(Vec.new(-25, 20), Vec.new(-45, 0)),
    Line.new(Vec.new(-25, -20), Vec.new(-45, 0))
  }

  return setmetatable({
    pos            = pos,
    rot            = -(PI / 2),
    speed          = speed,
    rot_speed      = rot_speed,
    drag           = drag,
    size           = size,
    lines          = lines,
    thruster_lines = thruster_lines,
    velocity       = Vec.new(0, 0),
    immortal       = true,
    respawn_timer  = 2
  }, Ship)
end

local thruster = false
local t = 0

function Ship:update(dt)
  local direction = Vec.new(math.cos(self.rot), math.sin(self.rot))

  if love.keyboard.isDown("w") then
    self.velocity = self.velocity:add(direction:scale(dt * self.speed))
  end

  thruster = love.keyboard.isDown("w")

  self.velocity = self.velocity:scale(1 - (self.drag * dt))
  self.pos = self.pos:add(self.velocity)

  if love.keyboard.isDown("a") then
    self.rot = self.rot - self.rot_speed * TAU * dt
  end

  if love.keyboard.isDown("d") then
    self.rot = self.rot + self.rot_speed * TAU * dt
  end

  -- constant timer that goes from 0-1s and resets
  t = (t + dt) % 1

  -- teleport the ship to edges
  self.pos.x = self.pos.x % WINDOW_WIDTH
  self.pos.y = self.pos.y % WINDOW_HEIGHT
end

function Ship:draw()
  -- draw thruster
  if thruster and math.floor(t / 0.08) % 2 == 1 then
    for _, line in ipairs(self.thruster_lines) do
      line = line:scale(self.size):rot(self.rot):addVec(self.pos):draw()
    end
  end

  for _, line in ipairs(self.lines) do
    if (not self.immortal) or math.floor(t / 0.08) % 2 == 1 then
      line = line
          :scale(self.size)
          :rot(self.rot)
          :addVec(self.pos)
          :draw()
    end
  end
end

function Ship:respawn(ship)
  LIVES = LIVES - 1
  return Ship.new(
    WINDOW_CENTER,
    ship.speed,
    ship.rot_speed,
    ship.drag,
    ship.size
  )
end

return Ship
