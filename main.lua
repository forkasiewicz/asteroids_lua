local Vec = require("vector")
local Line = require("line")
local Asteroid = require("asteroid")

SIZE = 0.6
SPEED = 10
DRAG = 3
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
  Asteroid.new(WINDOW_CENTER, 50)
  Asteroid.new(WINDOW_CENTER, 50)
  Asteroid.new(WINDOW_CENTER, 50)
end

local thruster = false
local t = 0

function love.update(dt)
  for i, asteroid in ipairs(Asteroid.all) do
    asteroid.pos = asteroid.pos:add(asteroid.speed:scale(dt))

    if asteroid.pos.x >= WINDOW_WIDTH + 50
        or asteroid.pos.y >= WINDOW_HEIGHT + 50
        or asteroid.pos.x <= 0 - 50
        or asteroid.pos.y <= 0 - 50 then
      table.remove(Asteroid.all, i)
    end
  end

  local direction = Vec.new(math.cos(ship.rot), math.sin(ship.rot))

  if love.keyboard.isDown("w") then
    velocity = velocity:add(direction:scale(dt * SPEED))
    t = (t + dt) % 1
    thruster = true
  end

  velocity = velocity:scale(1 - (DRAG * dt))
  ship.pos = ship.pos:add(velocity)

  if love.keyboard.isDown("a") then
    ship.rot = ship.rot - ROT_SPEED * math.pi * 2 * dt
  end

  if love.keyboard.isDown("d") then
    ship.rot = ship.rot + ROT_SPEED * math.pi * 2 * dt
  end

  -- teleport the ship to edges
  ship.pos.x = ship.pos.x % WINDOW_WIDTH
  ship.pos.y = ship.pos.y % WINDOW_HEIGHT
end

function love.keyreleased(key)
  if key == "w" then
    thruster = false
  end
end

function love.draw()
  local on = math.floor(t / 0.08) % 2 == 1
  if thruster then
    if on then
      for _, line in ipairs(ship.tail) do
        line = line:scale(SIZE):rot(ship.rot):addVec(ship.pos):draw()
      end
    end
  end

  for _, line in ipairs(ship) do
    line = line:scale(SIZE):rot(ship.rot):addVec(ship.pos):draw()
  end

  for _, asteroid in ipairs(Asteroid.all) do
    for _, line in ipairs(asteroid) do
      line = line:addVec(asteroid.pos):draw()
    end
  end
end
