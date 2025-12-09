local Vec = require "libs.vector"
local Line = require "libs.line"

local Particle = {}
Particle.__index = Particle

Particle.all = {}

function Particle.new(object, --[[optional]] duration)
  local lines = {}
  local size = object.size or 1
  local rot = object.rot or 0
  local dur = duration or 0
  for _, line in ipairs(object.lines) do
    table.insert(lines, {
      line = line
          :scale(size)
          :rot(rot)
          :addVec(object.pos),
      speed = line.vector1
          :normalized()
          :scale(math.random(50, 100))
          :rot(math.random(-50, 50) * (PI / 180)),
      lifetime = dur + math.random(2, 4) * 0.1,
      age = 0,
    })
  end

  local particle = setmetatable({
    lines = lines,
    pos = object.pos,
  }, Particle)

  table.insert(Particle.all, particle)
  return particle
end

function Particle:update(dt)
  for i, line in ipairs(self.lines) do
    line.line = line.line:addVec(line.speed:scale(dt))
    line.age = line.age + dt

    if line.age > line.lifetime then
      if i == #self.lines then
        for j, particle in ipairs(Particle.all) do
          if particle == self then
            table.remove(Particle.all, j)
            break
          end
        end
      end
      table.remove(self.lines, i)
    end
  end
end

function Particle:draw()
  for _, line in ipairs(self.lines) do
    line.line:draw()
  end
end

return Particle
