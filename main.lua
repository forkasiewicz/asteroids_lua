local Vec = require "vector"
local Line = require "line"
local Ship = require "ship"
local Asteroid = require "asteroid"
local Bullet = require "bullet"

GAME_OVER = false

SHIP_SIZE = 0.6
SHIP_DRAG = 3
SHIP_SPEED = 20
-- rotations per sec
SHIP_ROT_SPEED = 1

ASTEROID_SIZE = 50

BULLET_SPEED = 500

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

function love.update(dt)
  if not GAME_OVER then
    ship:update(dt)
  end

  -- debug
  -- randomly spawn an asteroid (for testing purposes only)
  if math.random(1, 600) == 600 and #Asteroid.all < 5 then
    Asteroid.new(ASTEROID_SIZE)
  end

  -- update all asteroids
  for _, asteroid in ipairs(Asteroid.all) do
    asteroid:update(dt)
  end

  for _, bullet in ipairs(Bullet.all) do
    bullet:update(dt)
  end
end

function love.keypressed(key)
  if not GAME_OVER then
    if key == "space" then
      Bullet.new(ship.pos, ship.rot)
    end
    if key == "p" then
      Asteroid.new(50)
    end
  end
end

function love.draw()
  if not GAME_OVER then
    ship:draw()

    for _, asteroid in ipairs(Asteroid.all) do
      for _, asteroid_line in ipairs(asteroid.lines) do
        for _, ship_line in ipairs(ship.lines) do
          if ship_line
              :scale(ship.size)
              :rot(ship.rot)
              :addVec(ship.pos)
              :intersects(
                asteroid_line
                :addVec(asteroid.pos)
              ) then
            asteroid.split = true
            GAME_OVER = true
          end
        end
      end
    end
  end

  for _, asteroid in ipairs(Asteroid.all) do
    for _, asteroid_line in ipairs(asteroid.lines) do
      for i, bullet in ipairs(Bullet.all) do
        if bullet.line:rot(bullet.rot):addVec(bullet.pos)
            :intersects(asteroid_line:addVec(asteroid.pos)) then
          asteroid.split = true
          table.remove(Bullet.all, i)
        end
      end
    end
  end

  for _, asteroid in ipairs(Asteroid.all) do
    asteroid:draw()
  end

  for _, bullet in ipairs(Bullet.all) do
    bullet:draw()
  end
end
