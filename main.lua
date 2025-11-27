local Vec = require("vector")
local Line = require("line")

SIZE = 0.75
SPEED = 5
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
local thrustVec = Vec.new(SPEED, 0)
local offset = Vec.new(0, 0)

function love.load()
    WindowCenter = Vec.new(love.graphics.getDimensions()):scale(0.5)
    offset = WindowCenter
end

function love.update(dt)
    -- have two vectors:
    --      max speed vector
    --      current speed vector
    -- upon pressing w we will add the max speed vector to the current speed vector
    -- every frame current speed vector will be constantly going down

    if love.keyboard.isDown("up") then
        offset = offset:add(thrustVec)
    end

    if love.keyboard.isDown("left") then
        thrustVec = thrustVec:rot(-ROT_SPEED * math.pi * 2 * dt)
        ship_rotation = ship_rotation - ROT_SPEED * math.pi * 2 * dt
    end

    if love.keyboard.isDown("right") then
        thrustVec = thrustVec:rot(ROT_SPEED * math.pi * 2 * dt)
        ship_rotation = ship_rotation + ROT_SPEED * math.pi * 2 * dt
    end
end

function love.draw()
    love.graphics.circle("fill", offset.x, offset.y, 1)

    for _, line in ipairs(ship) do
        line = line:scale(SIZE)
        line = line:rot(ship_rotation)
        line = line:addVec(offset)
        line:draw()
    end
end
