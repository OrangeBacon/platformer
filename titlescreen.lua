local titlescreen = {
    name = "titlescreen",
    x = 400,
    y = 300,
    options = {
        "Play", "Quit", "Saves"
    },
    selected = 1
}

function titlescreen:start()
    love.graphics.setDefaultFilter("linear", "nearest")
    self.title = love.graphics.newImage("graphics/title.png")
    self:scale()
    love.graphics.setFont(love.graphics.newFont(20))
end

function titlescreen:update(dt)
    
end

function titlescreen:draw()
    love.graphics.clear(0.1, 0.5, 0.8)
    love.graphics.setColor(0.7, 0.2, 0.2)
    love.graphics.rectangle("fill", 10, 10, love.graphics.getWidth() - 20, love.graphics.getHeight() - 20, 10)
    love.graphics.draw(self.title, self.titleX, 40, 0, self.titleScale)

    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    local center = love.graphics.getWidth() / 2

    local y = self.titleHeight + 80
    for i,v in ipairs(self.options) do
        if mouseY < y + 30 and mouseY > y - 10 and mouseX < center + 100 and mouseX > center - 100 then
            if love.mouse.isDown(1) then
                love.graphics.setColor(0, 0, 1)
            else
                love.graphics.setColor(0, 1, 1)
            end
        elseif i == self.selected then
            love.graphics.setColor(0, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(v, 0, y, love.graphics.getWidth(), "center")
        y = y + 40
    end
end

function titlescreen:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function titlescreen:keyreleased(key)
    if key == 'down' and self.selected < #self.options then
        self.selected = self.selected + 1
    elseif key == 'up' and self.selected > 1 then
        self.selected = self.selected - 1
    elseif key == 'return' then
        self:selectOption(self.options[self.selected])
    end
end

function titlescreen:resize(w, h)
    self:scale()
end

function titlescreen:mousereleased(mouseX, mouseY)
    local center = love.graphics.getWidth() / 2
    local y = self.titleHeight + 80
    
    for _, v in ipairs(self.options) do
        if mouseY < y + 30 and mouseY > y - 10 and mouseX < center + 100 and mouseX > center - 100 then
            self:selectOption(v)
            return
        end
        y = y + 40
    end
end

function titlescreen:scale()
    local sf = (love.graphics.getWidth() - 75 ) / self.title:getWidth()
    local newHeight = math.ceil(self.title:getHeight() * sf)
    if newHeight > 100 then
        sf = 100 / self.title:getHeight()
    end
    self.titleHeight = math.ceil(self.title:getHeight() * sf)
    self.titleX = math.ceil((love.graphics.getWidth() - (self.title:getWidth() * sf)) / 2)
    self.titleScale = sf
end

function titlescreen:selectOption(opt)
    print(opt)
end

return titlescreen