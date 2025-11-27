local Vec = {}
Vec.__index = Vec

function Vec.new(x, y)
    return setmetatable({ x = x, y = y }, Vec)
end

function Vec:add(vector)
    return Vec.new(self.x + vector.x, self.y + vector.y)
end

function Vec:sub(vector)
    return Vec.new(self.x - vector.x, self.y - vector.y)
end

function Vec:normalized()
    local root = math.sqrt(self.x ^ 2 + self.y ^ 2)
    return Vec.new(
        self.x / root,
        self.y / root
    )
end

function Vec:rot(n)
    return Vec.new(
        self.x * math.cos(n) - self.y * math.sin(n),
        self.x * math.sin(n) + self.y * math.cos(n)
    )
end

function Vec:scale(n)
    return Vec.new(self.x * n, self.y * n)
end

return Vec
