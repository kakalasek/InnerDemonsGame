-- Enemy object
-- NOTE: All library objects are defined in a different file (world, anim8, etc. )

Enemy = Object:extend() -- creates the enemey object

function Enemy:new(x, y)    -- constructor for the Enemy object
    -- setting the dimensions for the enemy
    self.width = 20
    self.height = 20

    self.collider = world:newRectangleCollider(x, y, self.width, self.height)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(true)

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.speed = 10 -- setting the movement speed of the enemy
end

-- update function for the Enemy object
function Enemy:update(dt)
    local vx = 0 -- velocity in the x direction .. used to for movement .. unexpectedly

    -- simple checking for enemy position against the player .. if it does not match, the enemy will move towards the player
    if player.x - self.x > 0 then
        vx = self.speed
    elseif player.x - self.x < 0 then
        vx = -self.speed
    end

    self.collider:setLinearVelocity(vx, 200) -- moves the collider and sets the velocity of the movement .. in both directions

    -- sets the x and y postion of the enemy according to its collider
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if self.collider:enter('Player') then
        gameState.deathScreen = true
        gameState.runningScreen = false
        player.collider:destroy()
    end
end

-- draw function for the Enemy object
function Enemy:draw()

    -- ALL CODE HERE IS SUBJECT TO CHANGE

    love.graphics.setColor(255, 0, 0)

    love.graphics.rectangle("fill", self.x-self.width/2, self.y-self.height/2, self.width, self.height)

    love.graphics.setColor(255, 255, 255)
end
