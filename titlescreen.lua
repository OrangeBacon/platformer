local titlescreen = {
    name = "titlescreen"
}

function titlescreen.update()

end

function titlescreen.draw()
    love.graphics.print("Hello world", 400, 300);
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

return titlescreen