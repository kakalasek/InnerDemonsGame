-- Player object
-- NOTE: All library objects are defined in a different file (world, anim8, etc. )

Player = Object:extend(); -- creates the player object


function Player:new() -- constructor for the Player object

    -- defining width and height of one animation frame .. and defining the scale
    self.animWidth = 12
    self.animHeight = 18
    self.scale = 3

    -- creating a collider for the player
    self.collider = world:newRectangleCollider(100, 360, self.animWidth * self.scale, self.animHeight * self.scale) -- 'world' is an object created with the windfield library
                                                                                                                    -- this object adds gravity to the game
    self.collider:setFixedRotation(true) -- since we have a 2D game, we dont want our collider to rotate

    self.speed = 200 -- sets the speed of our player

    self.spriteSheet = love.graphics.newImage('textures/player-sheet.png')  -- load our spirtesheet into a property AKA variable AKA to hell with OOP

    self.grid = anim8.newGrid(self.animWidth, self.animHeight, self.spriteSheet:getWidth(), self.spriteSheet:getHeight()) -- creates a grid for our player animation
                                                                                                                          -- we need to define the width and height of our animation and the width and height of our spritesheet
                                                                                                                          -- we are using the anim8 library to do that
    -- creating the different animations                                                                                                                    
    self.animations = {} -- we will store the animations in a table using different key to access each set
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.2) -- first attribute are the frames to be used for the animation (we get them from our grid), second argument sets the duration of the animatiion
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.2)

    self.anim = self.animations.right -- sets the default animation to 'right' (basically means the player will look right at the start of the game)
end

-- update function for the Player object
function Player:update(dt)
    local isMoving = false  -- so the player animation will stop after the player stops moving

    local vx = 0 -- so the player velocity in the x direction will reset to 0 if the player stops moving

    -- a simple else if to check which direction the player is moving
    if love.keyboard.isDown("a") then
        vx = - self.speed
        self.anim = self.animations.left
        isMoving = true
    elseif love.keyboard.isDown("d") then
        vx = self.speed
        self.anim = self.animations.right
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, 200) -- since the player is actually locked in the collider, we need to move the collider, not the player
                                             -- first argument is the velocity in the x direction the second one in the y direction (so basically how fast will our player fall)

    if not isMoving then self.anim:gotoFrame(2) end -- if our player is not moving, we want to display this frame of our animation
                                                    -- here the beaty of Lua .. everything can be written on one line .. not that we want that everytime .. but it can save space and make the code more readable

    -- Now we set our cords according to our collider .. we wil use them later in the draw function 
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    -- we update our animation
    self.anim:update(dt)
end

-- draw function for our player object
function Player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, self.scale, nil, self.animWidth/2, self.animHeight/2) -- will draw our player
                                                                                                                -- the random nil values are there, because there are positional arguments, which we dont want to set
end