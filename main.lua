local logger = require "logger"
local application = require "application"
local titlescreen = require "titlescreen"

function love.load()
    logger.start()

    local app = application:new()
    app:mode(titlescreen)
    app:start()
end