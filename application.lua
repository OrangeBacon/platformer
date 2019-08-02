local logger = require "logger"
local app = {
    update = function() end,
    draw = function() end,
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
end

function app:mode(mode)
    logger.info("Mode Change: " .. mode.name)
    self.mode = mode
    self.update = mode.update
    self.draw = mode.draw
end

return app