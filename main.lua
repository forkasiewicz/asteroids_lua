local Vec = require("vector")
local Line = require("line")

SIZE = 0.6
SPEED = 15
DRAG = 0.02
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
local direction = Vec.new(0, 0)

function love.load()
    offset = Vec.new(love.graphics.getDimensions()):scale(0.5)
end

function love.update(dt)
    direction = Vec.new(math.cos(ship_rotation), math.sin(ship_rotation))

    if love.keyboard.isDown("w") then
        velocity = velocity:add(direction:scale(dt * SPEED))
    end

    velocity = velocity:scale(1 - DRAG)
    offset = offset:add(velocity)

    if love.keyboard.isDown("a") then
        ship_rotation = ship_rotation - ROT_SPEED * math.pi * 2 * dt
    end

    if love.keyboard.isDown("d") then
        ship_rotation = ship_rotation + ROT_SPEED * math.pi * 2 * dt
    end

    DetectEdges()
end

function love.draw()
    Line.new(Vec.new(0, 0), Vec.new(200, -400)):draw()
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

function DetectEdges()
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
