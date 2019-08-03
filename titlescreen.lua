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
    love.graphics.setFont(love.graphics.newFont(20))
end

function titlescreen:update(dt)
    
end

function titlescreen:draw()
    love.graphics.clear(0.1, 0.5, 0.8)
    love.graphics.setColor(0.7, 0.2, 0.2)
    love.graphics.rectangle("fill", 10, 10, love.graphics.getWidth() - 20, love.graphics.getHeight() - 20, 10)
    
    local y = 200
    for i,v in ipairs(self.options) do
        if i == self.selected then
            love.graphics.setColor(0, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(v, 0, y, love.graphics.getWidth(), "center")
        y = y + 40
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if key == 'down' and titlescreen.selected < #titlescreen.options then
        titlescreen.selected = titlescreen.selected + 1
    end
    if key == 'up' and titlescreen.selected > 1 then
        titlescreen.selected = titlescreen.selected - 1
    end
end

return titlescreen