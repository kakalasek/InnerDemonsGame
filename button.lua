Button = Object:extend()

function Button:new(width, height, x, y, text,  func)
    self.width = width;
    self.height = height
    self.x = x
    self.y = y
    self.text_string = text
    self.text = love.graphics.newText(love.graphics.getFont(), text)
    self.func = func
    
end

function Button:update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    if mouse_x > self.x and mouse_x < self.x + self.width and mouse_y > self.y and mouse_y < self.y + self.height then
        if love.mouse.isDown(1) then
            self.func()
        end
    end

end

function Button:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0,0,0)
    love.graphics.print(self.text_string, self.x + self.width/2 - self.text:getWidth()/2, self.y + self.height/2 - self.text:getHeight()/2)
    love.graphics.setColor(255,255,255)
end