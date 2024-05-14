Bullet = Object:extend()

function Bullet:new(x, y, velocity_x, velocity_y)
    self.x = x
    self.y = y
    self.velocity_x = velocity_x
    self.velocity_y = velocity_y

    self.radius = 5

    self.starting_x = x
    self.starting_y = y

    self.disappear = 300

    self.collider = world:newCircleCollider(x, y, self.radius)
    self.collider:setCollisionClass('Bullet')
    self.collider:setFixedRotation(true)

end

function Bullet:update(dt)

    self.collider:setLinearVelocity(self.velocity_x * dt, self.velocity_y * dt)

    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Bullet:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

