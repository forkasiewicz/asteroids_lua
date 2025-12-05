local Vec = require "vector"
local Line = require "line"

local Bullet = {}
Bullet.__index = Bullet

Bullet.all = {}

function Bullet.new(pos, rot)
  local line = Line.new(
    Vec.new(0, 0),
    Vec.new(10, 0)
  ):addVec(Vec.new(10, 0))

  local bullet = setmetatable({
    line = line,
    pos = pos,
    rot = rot,
    speed = Vec.new(BULLET_SPEED, 0):rot(rot),
    lifetime = 1,
    age = 0
  }, Bullet)

  table.insert(Bullet.all, bullet)

  return bullet
end

function Bullet:update(dt)
  self.age = self.age + dt

  if self.age > self.lifetime then
    for i, bullet in ipairs(Bullet.all) do
      if bullet == self then
        table.remove(Bullet.all, i)
        break
      end
    end
  end

  self.pos = self.pos:add(self.speed:scale(dt))

  self.pos.x = self.pos.x % (WINDOW_WIDTH)
  self.pos.y = self.pos.y % (WINDOW_HEIGHT)
end

function Bullet:draw()
  self.line
      :rot(self.rot)
      :addVec(self.pos)
      :draw()
end

return Bullet
