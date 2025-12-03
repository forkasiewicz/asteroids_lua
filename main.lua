local Vec = require "vector"
local Line = require "line"
local Asteroid = require "asteroid"
local Ship = require "ship"

SHIP_SIZE = 0.6
SHIP_DRAG = 3
SHIP_SPEED = 20
-- rotations per sec
SHIP_ROT_SPEED = 1


math.randomseed(os.time())

WINDOW_CENTER, WINDOW_WIDTH, WINDOW_HEIGHT = nil, nil, nil
local ship

function love.load()
  WINDOW_CENTER = Vec.new(love.graphics.getDimensions()):scale(0.5)
  WINDOW_WIDTH = love.graphics.getWidth()
  WINDOW_HEIGHT = love.graphics.getHeight()
  ship = Ship.new(
    WINDOW_CENTER,
    SHIP_SPEED,
    SHIP_ROT_SPEED,
    SHIP_DRAG,
    SHIP_SIZE
  )
end

local bullets = {}

local function shoot()
  table.insert(bullets, Line.new(
    ship.pos,
    Vec.new(10, 0)
    :scale(SHIP_SIZE)
    :rot(ship.rot)
    :add(ship.pos)
  ))
  bullets[#bullets].pos = Vec.new(0, 0)
  bullets[#bullets].rot = ship.rot
end

function love.update(dt)
  ship:update(dt)

  -- randomly spawn an asteroid (for testing purposes only)
  if math.random(1, 600) == 600 and #Asteroid.all < 5 then
    Asteroid.new(50)
  end

  -- update all asteroids
  for _, asteroid in ipairs(Asteroid.all) do
    asteroid:update(dt)
  end

  for _, bullet in ipairs(bullets) do
    bullet.pos = bullet.pos:add(Vec.new(500, 0):scale(dt):rot(bullet.rot))
  end
end

function love.keypressed(key)
  if key == "space" then
    shoot()
  end
end

function love.draw()
  -- debug
  -- love.graphics.rectangle("line",
  -- 150, 150,
  -- WINDOW_WIDTH - 300, WINDOW_HEIGHT - 300)

  ship:draw()

  for _, asteroid in ipairs(Asteroid.all) do
    asteroid:draw()
  end

  for _, bullet in ipairs(bullets) do
    bullet = bullet:addVec(bullet.pos):draw()
  end
end
