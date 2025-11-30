local Vec = require("vector")
local Line = require("line")
local Asteroid = require("asteroid")

local pi, tau = math.pi, math.pi * 2

SIZE = 0.6
SPEED = 10
DRAG = 3
-- for mac
SPEED = 20
-- rotations per sec
ROT_SPEED = 1

-- used to draw the ship
local ship = {
  Line.new(Vec.new(-30, 30), Vec.new(45, 0)),
  Line.new(Vec.new(-30, -30), Vec.new(-25, -25)),
  Line.new(Vec.new(-25, 25), Vec.new(-25, -25)),
  Line.new(Vec.new(-25, 25), Vec.new(-30, 30)),
  Line.new(Vec.new(-30, -30), Vec.new(45, 0)),
}

ship.tail = {
  Line.new(Vec.new(-25, 20), Vec.new(-45, 0)),
  Line.new(Vec.new(-25, -20), Vec.new(-45, 0))
}

ship.rot = 0
math.randomseed(os.time())

WINDOW_CENTER = Vec.new(0, 0)
WINDOW_WIDTH = 0
WINDOW_HEIGHT = 0

local velocity = Vec.new(0, 0)

function love.load()
  WINDOW_CENTER = Vec.new(love.graphics.getDimensions()):scale(0.5)

  WINDOW_WIDTH = love.graphics.getWidth()
  WINDOW_HEIGHT = love.graphics.getHeight()

  ship.pos = WINDOW_CENTER
end

local thruster = false
local t = 0

local bullets = {}

local function shoot()
  table.insert(bullets, Line.new(
    ship.pos,
    Vec.new(10, 0)
    :scale(SIZE)
    :rot(ship.rot)
    :add(ship.pos)
  ))
  bullets[#bullets].pos = Vec.new(0, 0)
  bullets[#bullets].rot = ship.rot
end

function love.update(dt)
  for _, asteroid in ipairs(Asteroid.all) do
    asteroid.pos = asteroid.pos:add(asteroid.speed:scale(dt))

    asteroid.pos.x = asteroid.pos.x % (WINDOW_WIDTH + 100)
    asteroid.pos.y = asteroid.pos.y % (WINDOW_HEIGHT + 100)
  end

  for _, bullet in ipairs(bullets) do
    bullet.pos = bullet.pos:add(Vec.new(500, 0):scale(dt):rot(bullet.rot))
  end

  -- constant timer that goes from 0-1s and resets
  t = (t + dt) % 1

  -- spawn randomly (for testing purposes only)
  if math.random(1, 600) == 600 and #Asteroid.all < 5 then
    Asteroid.new(50)
  end

  local direction = Vec.new(math.cos(ship.rot), math.sin(ship.rot))

  if love.keyboard.isDown("w") then
    velocity = velocity:add(direction:scale(dt * SPEED))
  end

  thruster = love.keyboard.isDown("w")

  velocity = velocity:scale(1 - (DRAG * dt))
  ship.pos = ship.pos:add(velocity)

  if love.keyboard.isDown("a") then
    ship.rot = ship.rot - ROT_SPEED * tau * dt
  end

  if love.keyboard.isDown("d") then
    ship.rot = ship.rot + ROT_SPEED * tau * dt
  end

  -- teleport the ship to edges
  ship.pos.x = ship.pos.x % WINDOW_WIDTH
  ship.pos.y = ship.pos.y % WINDOW_HEIGHT
end

function love.keypressed(key)
  if key == "space" then
    shoot()
  end
end

function love.draw()
  -- love.graphics.rectangle("line", 150, 150, WINDOW_WIDTH - 300, WINDOW_HEIGHT - 300)
  -- love.graphics.print(t)

  -- draw thruster
  local on = math.floor(t / 0.08) % 2 == 1
  if thruster then
    if on then
      for _, line in ipairs(ship.tail) do
        line = line:scale(SIZE):rot(ship.rot):addVec(ship.pos):draw()
      end
    end
  end

  for _, line in ipairs(ship) do
    line = line
        :scale(SIZE)
        :rot(ship.rot)
        :addVec(ship.pos)
        :draw()
  end

  for _, asteroid in ipairs(Asteroid.all) do
    for _, line in ipairs(asteroid) do
      line = line
          :addVec(asteroid.pos)
          :draw()
    end
  end

  for _, bullet in ipairs(bullets) do
    bullet = bullet
        :addVec(bullet.pos)
        :draw()
  end
end
