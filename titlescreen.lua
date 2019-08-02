local titlescreen = {
    name = "titlescreen",
    x = 400,
    y = 300
}

function titlescreen:update(dt)
    if love.keyboard.isDown("left") then
        self.x = self.x - 50 * dt
    end
    if love.keyboard.isDown("right") then
        self.x = self.x + 50 * dt
    end
    if love.keyboard.isDown("up") then
        self.y = self.y - 50 * dt
    end
    if love.keyboard.isDown("down") then
        self.y = self.y + 50 * dt
    end
end

function titlescreen:draw()
    love.graphics.clear(0.1, 0.5, 0.8)
    love.graphics.setColor(0.7, 0.2, 0.2)
    love.graphics.rectangle("fill", 10, 10, love.graphics.getWidth() - 20, love.graphics.getHeight() - 20, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Hello world", self.x, self.y)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

return titlescreen