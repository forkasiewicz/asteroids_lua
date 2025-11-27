local Vec = require("vector")
local Line = require("line")

SIZE = 0.6
SPEED = 50
-- rotations per sec
ROT_SPEED = 1

local ship = {
    Line.new(Vec.new(-30, 30), Vec.new(45, 0)),
    Line.new(Vec.new(-30, -30), Vec.new(-25, -25)),
    Line.new(Vec.new(-25, 25), Vec.new(-25, -25)),
    Line.new(Vec.new(-25, 25), Vec.new(-30, 30)),
    Line.new(Vec.new(-30, -30), Vec.new(45, 0)),
}

local ship_rotation = 0
local offset = Vec.new(0, 0)
local velocity = Vec.new(0, 0)
local delta_time = 0

function love.load()
    offset = Vec.new(love.graphics.getDimensions()):scale(0.5)
end

function love.update(dt)
    delta_time = dt
    -- lerp function
    -- offset = offset:add(destination:sub(offset):scale(dt))

    offset = offset:add(velocity:scale(dt * 5))

    if love.keyboard.isDown("up") then
        local thrust = Vec.new(SPEED, 0):rot(ship_rotation)
        velocity = velocity:add(thrust:scale(dt))
    end

    if love.keyboard.isDown("left") then
        ship_rotation = ship_rotation - ROT_SPEED * math.pi * 2 * dt
    end

    if love.keyboard.isDown("right") then
        ship_rotation = ship_rotation + ROT_SPEED * math.pi * 2 * dt
    end

    if offset.x >= love.graphics.getWidth() then
        offset.x = 1
    end

    if offset.y >= love.graphics.getHeight() then
        offset.y = 1
    end

    if offset.x <= 0 then
        offset.x = love.graphics.getWidth()
    end

    if offset.y <= 0 then
        offset.y = love.graphics.getHeight()
    end
end

function love.draw()
    love.graphics.print(string.format("FPS: %i\ndelta_time: %f", 1 / delta_time, delta_time))

    -- debug dot to check the center of the ship
    -- love.graphics.circle("fill", offset.x, offset.y, 1)

    -- debug line to check the current direction
    -- Line.new(offset, Vec.new(100, 0):rot(ship_rotation):add(offset)):draw()

    for _, line in ipairs(ship) do
        line = line:scale(SIZE)
        line = line:rot(ship_rotation)
        line = line:addVec(offset)
        line:draw()
    end
end
