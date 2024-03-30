Player = Object:extend();

function Player:new()
    self.animWidth = 12
    self.animHeight = 18
    self.scale = 3

    self.collider = world:newRectangleCollider(100, 360, self.animWidth * self.scale, self.animHeight * self.scale)
    self.collider:setFixedRotation(true)

    self.speed = 200

    self.spriteSheet = love.graphics.newImage('textures/player-sheet.png')

    self.grid = anim8.newGrid(self.animWidth, self.animHeight, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.2)
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.2)

    self.anim = self.animations.right
end

function Player:update(dt)
    local isMoving = false

    local vx = 0

    if love.keyboard.isDown("a") then
        vx = - self.speed
        self.anim = self.animations.left
        isMoving = true
    elseif love.keyboard.isDown("d") then
        vx = self.speed
        self.anim = self.animations.right
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, 200)

    if not isMoving then self.anim:gotoFrame(2) end

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.anim:update(dt)
end

function Player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, self.scale, nil, self.animWidth/2, self.animHeight/2)
end