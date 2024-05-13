Bullet = Object:extend()

function Bullet:new(x, y, velocity)
    self.x = x
    self.y = y
    self.velocity = velocity

    self.starting_x = x
    self.starting_y = y

    self.disappear = 200

end

function Bullet:update()
    self.x = self.x + self.velocity
    self.y = self.y + self.velocity

end

function Bullet:draw()
    love.graphics.circle("fill", self.x, self.y, 10) 
end

