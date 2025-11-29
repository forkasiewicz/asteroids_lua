local Line = require("line")
local Vec = require("vector")

local Asteroid = {}
Asteroid.__index = Asteroid

function Asteroid.new(pos, size)
    local n = 10
    local lines = {}
    local points = {}
    for i = 1, n do
        local rand = math.random(size / 5, size)
        points[i] = Vec.new(rand, 0):rot(
        -- derived from 360 / n and pi / 180
            (2 / n) * i * math.pi
        )
    end
    for i = 1, n do
        if i < n then
            lines[i] = Line.new(
                points[i],
                points[i + 1]
            ):addVec(Vec.new(pos.x, pos.y))
        else
            lines[i] = Line.new(
                points[i],
                points[1]
            ):addVec(Vec.new(pos.x, pos.y))
        end
    end
    return setmetatable(lines, Asteroid)
end

return Asteroid
