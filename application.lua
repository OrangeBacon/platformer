local logger = require "logger"
local app = {
    mode = {
        name = "NONE"
    }
}

function app:new()
    ret = {}
    setmetatable(ret, self)
    self.__index = self
    return ret
end

function app:start()
    logger.info("Application start")

    function love.update(dt)
        self.update(self.mode, dt)
    end

    function love.draw()
        if love.window.isVisible() then
            self.draw(self.mode)
        end
    end

    function love.keypressed(key)
        self.keypressed(self.mode, key)
    end

    function love.keyreleased(key)
        self.keyreleased(self.mode, key)
    end
end

function app:mode(mode)
    logger.info("Mode Change: " .. mode.name)
    self.mode = mode

    if mode.update ~= nil then
        self.update = mode.update
    else
        self.update = function() end
    end

    if mode.draw ~= nil then
        self.draw = mode.draw
    else
        self.draw = function() end
    end

    if mode.keypressed ~= nil then
        self.keypressed = mode.keypressed
    else
        self.keypressed = function() end
    end

    if mode.keyreleased ~= nil then
        self.keyreleased = mode.keyreleased
    else
        self.keyreleased = function() end
    end

    mode:start()
end

return app