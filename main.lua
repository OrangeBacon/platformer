local logger = require "logger"

function love.load()
    logger.start()
    logger.info("Hello, World!")
    logger.info("Starting Platformer")
end

function love.draw()
    love.graphics.print("Hello, World", 400, 300)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end