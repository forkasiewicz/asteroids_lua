local Vec = require "vector"
local Line = require "line"

local Bullet = {}
Bullet.__index = Bullet

Bullet.all = {}

function Bullet.new(pos, rot)
  local line = Line.new(
    Vec.new(0, 0),
    Vec.new(35, 0):scale(SHIP_SIZE):rot(rot)
  ):addVec(Vec.new(30, 0):scale(SHIP_SIZE):rot(rot))

  local speed = Vec.new(BULLET_SPEED, 0):rot(rot)
  local lifetime = 1
  local t = 0

  local bullet = setmetatable({
    line = line,
    pos = pos,
    rot = rot,
    speed = speed,
    lifetime = lifetime,
    t = t
  }, Bullet)

  table.insert(Bullet.all, bullet)

  return bullet
end

function Bullet:update(dt)
  self.t = (self.t + dt)

  if self.t > self.lifetime then
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
  self.line:addVec(self.pos):draw()
end

return Bullet
