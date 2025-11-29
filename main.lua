local Vec = require("vector")
local Line = require("line")
local Asteroid = require("asteroid")

SIZE = 0.6
SPEED = 15
DRAG = 0.02
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

ship.pos = Vec.new(0, 0)
ship.rot = 0

WINDOW_CENTER = Vec.new(0, 0)
WINDOW_WIDTH = 0
WINDOW_HEIGHT = 0

local velocity = Vec.new(0, 0)

function love.load()
    ship.pos = Vec.new(love.graphics.getDimensions()):scale(0.5)
    WINDOW_CENTER = Vec.new(love.graphics.getDimensions()):scale(0.5)

    WINDOW_WIDTH = love.graphics.getWidth()
    WINDOW_HEIGHT = love.graphics.getHeight()

    TEST_ASTEROID = Asteroid.new(WINDOW_CENTER, 50)
end

local thruster = false
local t = 0

function love.update(dt)
    local direction = Vec.new(math.cos(ship.rot), math.sin(ship.rot))

    if love.keyboard.isDown("w") then
        velocity = velocity:add(direction:scale(dt * SPEED))
        t = t + dt
        thruster = true
    end

    function love.keyreleased(key)
        if key == "w" then
            thruster = false
        end
    end

    velocity = velocity:scale(1 - DRAG)
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

function love.draw()
    local on = math.floor(t / 0.08) % 2 == 1
    if thruster then
        if on then
            for _, line in ipairs(ship.tail) do
                line = line:scale(SIZE)
                line = line:rot(ship.rot)
                line = line:addVec(ship.pos)
                line:draw()
            end
        end
    end

    for _, line in ipairs(ship) do
        line = line:scale(SIZE)
        line = line:rot(ship.rot)
        line = line:addVec(ship.pos)
        line:draw()
    end

    for _, line in ipairs(TEST_ASTEROID) do
        line:draw()
    end
end
