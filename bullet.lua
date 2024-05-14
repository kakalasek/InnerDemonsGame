Bullet = Object:extend()

function Bullet:new(x, y, velocity_x, velocity_y)
    self.x = x
    self.y = y
    self.velocity_x = velocity_x
    self.velocity_y = velocity_y

    self.starting_x = x
    self.starting_y = y

    self.disappear = 300

end

function Bullet:update(dt)
    self.x = self.x + (self.velocity_x * dt)
    self.y = self.y + (self.velocity_y * dt)
end

function Bullet:draw()
    love.graphics.circle("fill", self.x, self.y, 5)
end

