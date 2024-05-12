Menu = Object:extend()

function Menu:new()
    self.buttonWidth = 200
    self.buttonHeight = 40

    self.gap = 50
    
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()

    playButton = Button(self.buttonWidth, self.buttonHeight, self.screenWidth/2 - self.buttonWidth/2, self.screenHeight/2 - self.buttonHeight/2 - self.gap, 'PLAY', function ()
        gameState.menuScreen = false
        gameState.runningScreen = true
    end)
    exitButton = Button(self.buttonWidth, self.buttonHeight, self.screenWidth/2 - self.buttonWidth/2, self.screenHeight/2 - self.buttonHeight/2, 'EXIT', function ()
        love.event.quit(0)
    end)
end

function Menu:update(dt)
    playButton:update()
    exitButton:update()
end

function Menu:draw()
    playButton:draw()
    exitButton:draw()
end