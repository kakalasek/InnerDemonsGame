-- Enemy object
-- NOTE: All library objects are defined in a different file (world, anim8, etc. )

Enemy = Object:extend() -- creates the enemey object

function Enemy:new()    -- constructor for the Enemy object
    -- setting the dimensions for the enemy
    self.width = 20
    self.height = 20

    self.collider = world:newRectangleCollider(160, 360, self.width, self.height)
    self.collider:setCollisionClass('Solid')
    self.collider:setFixedRotation(true)

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.speed = 200 -- setting the movement speed of the enemy
end

-- update function for the Enemy object
function Enemy:update(dt)
    local vx = 0

    if player.x - self.x > 0 then
        vx = self.speed
    elseif player.x - self.x < 0 then
        vx = -self.speed
    end

    self.collider:setLinearVelocity(vx, 200)

    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Enemy:draw()
    love.graphics.setColor(255, 0, 0)

    love.graphics.rectangle("fill", self.x-self.width/2, self.y-self.height/2, self.width, self.height)

    love.graphics.setColor(255, 255, 255)
end
