local Vec = require "libs.vector"
local Line = require "libs.line"
local Particle = require "libs.particle"
local Ship = require "src.ship"
local Asteroid = require "src.asteroid"
local Bullet = require "src.bullet"

PI, TAU = math.pi, math.pi * 2

SHIP_SIZE = 0.6
SHIP_DRAG = 3
SHIP_SPEED = 20
-- rotations per sec
SHIP_ROT_SPEED = 1

ASTEROID_SIZE = 50

BULLET_SPEED = 500

-- credit to https://www.pixelsagas.com/?download=hyperspace
FONT_PATH = "assets/hyperspace.ttf"
local fonts = {}

WINDOW_CENTER, WINDOW_WIDTH, WINDOW_HEIGHT = nil, nil, nil
local ship
local t = 0
local respawn_timer_max

local function fontSize(size)
  for _, font in ipairs(fonts) do
    if font.size == size then
      love.graphics.setFont(font.font)
      return font.font
    end
  end
  local new_font = love.graphics.newFont(FONT_PATH, size)
  love.graphics.setFont(new_font)
  table.insert(fonts, { font = new_font, size = size })
  return new_font
end

local function centerText(text, pos, size)
  local x = fontSize(size):getWidth(text)
  local y = fontSize(size):getHeight()

  love.graphics.print(text, pos.x - (x / 2), pos.y - (y / 2))
end

function Reset()
  math.randomseed(os.time())

  Asteroid.all = {}
  Particle.all = {}

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

  GAME_OVER = false
  WAVE = 1
  SCORE = 0
  LIVES = 3
  t = 0
  respawn_timer_max = ship.respawn_timer

  for _ = 1, 4 do
    Asteroid.new(ASTEROID_SIZE)
  end
end

function love.load()
  Reset()
end

function love.update(dt)
  t = t + dt

  for _, asteroid in ipairs(Asteroid.all) do
    for _, asteroid_line in ipairs(asteroid.lines) do
      -- if bullet collides with asteroid
      for i, bullet in ipairs(Bullet.all) do
        if bullet.line
            :rot(bullet.rot)
            :addVec(bullet.pos)
            :intersects(
              asteroid_line
              :addVec(asteroid.pos)
            ) then
          asteroid.split = true
          Particle.new(asteroid)
          table.remove(Bullet.all, i)
        end
      end

      -- if ship collides with asteroid
      if not GAME_OVER then
        for _, ship_line in ipairs(ship.lines) do
          if ship_line
              :scale(ship.size)
              :rot(ship.rot)
              :addVec(ship.pos)
              :intersects(
                asteroid_line
                :addVec(asteroid.pos)
              ) then
            if not ship.immortal then
              asteroid.split = true
              Particle.new(ship, 2)
              ship = Ship:respawn(ship)
              break
            end
          end
        end
      end
    end
  end

  if ship.respawn_timer == respawn_timer_max then
    for _, asteroid in ipairs(Asteroid.all) do
      if Line.new(ship.pos, asteroid.pos):len() < 200 then
        ship.immortal = true
      else
        ship.immortal = false
      end
    end
  end

  if ship.respawn_timer > 0 then
    ship.respawn_timer = ship.respawn_timer - dt
  end

  if ship.respawn_timer <= 0 then
    ship.immortal = false
  end

  if not GAME_OVER then
    ship:update(dt)
    if t >= 10 then
      if #Asteroid.all < 11 then
        WAVE = WAVE + 1
        Asteroid.new(ASTEROID_SIZE)
        Asteroid.new(ASTEROID_SIZE)
      end
      t = 0
    end
  end

  -- update all asteroids
  for _, asteroid in ipairs(Asteroid.all) do
    asteroid:update(dt)
  end

  -- update all bullets
  for _, bullet in ipairs(Bullet.all) do
    bullet:update(dt)
  end

  -- update all particles
  for _, particle in ipairs(Particle.all) do
    particle:update(dt)
  end
end

function love.keypressed(key)
  if key == "space" then
    if GAME_OVER then
      Reset()
    else
      Bullet.new(ship.pos, ship.rot)
    end
  end
end

function love.draw()
  if LIVES <= 0 then
    GAME_OVER = true
  end

  if not GAME_OVER then
    ship:draw()
  else
    centerText("GAME OVER", WINDOW_CENTER:sub(Vec.new(0, 50)), 80)
    centerText("PRESS SPACE TO RESPAWN", WINDOW_CENTER:add(Vec.new(0, 40)), 40)
  end

  fontSize(35)
  love.graphics.print(SCORE, 10, 0)

  for i = 1, LIVES do
    for _, line in ipairs(ship.lines) do
      line:rot(-(PI / 2)):addVec(Vec.new(i * 70, 120)):scale(SHIP_SIZE):draw()
    end
  end

  for _, asteroid in ipairs(Asteroid.all) do
    asteroid:draw()
  end

  for _, bullet in ipairs(Bullet.all) do
    bullet:draw()
  end

  for _, particle in ipairs(Particle.all) do
    particle:draw()
  end
end
