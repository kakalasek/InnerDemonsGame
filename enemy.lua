-- Enemy object
-- NOTE: All library objects are defined in a different file (world, anim8, etc. )

Enemy = Object:extend() -- creates the enemey object

function Enemy:new(x, y)    -- constructor for the Enemy object
    -- setting the dimensions for the enemy
    self.animWidth = 12
    self.animHeight = 18
    self.scale = 3


    self.collider = world:newRectangleCollider(x, y, self.animWidth * self.scale, self.animHeight * self.scale)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(true)

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.speed = 100 -- setting the movement speed of the enemy

    self.spriteSheet = love.graphics.newImage('textures/better-enemy-sheet.png')

    self.grid = anim8.newGrid(self.animWidth, self.animHeight, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.2)
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.2)

    self.anim = self.animations.left
end

-- update function for the Enemy object
function Enemy:update(dt)
    local isMoving = false

    local vx = 0 -- velocity in the x direction .. used to for movement .. unexpectedly

    -- simple checking for enemy position against the player .. if it does not match, the enemy will move towards the player
    if player.x - self.x > 0 then
        vx = self.speed
        self.anim = self.animations.right
        isMoving = true
    elseif player.x - self.x < 0 then
        vx = -self.speed
        self.anim = self.animations.left
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, 200) -- moves the collider and sets the velocity of the movement .. in both directions

    -- sets the x and y postion of the enemy according to its collider
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if not isMoving then self.anim:gotoFrame(2) end

    if self.collider:enter('Player') then
        gameState.deathScreen = true
        gameState.runningScreen = false
        player.collider:destroy()
    end

    self.anim:update(dt)
end

-- draw function for the Enemy object
function Enemy:draw()

    self.anim:draw(self.spriteSheet, self.x, self.y, nil, self.scale, nil, self.animWidth/2, self.animHeight/2)

end
