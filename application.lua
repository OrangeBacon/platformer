local logger = require "logger"
local app = {
    mode = {
        name = "NONE"
    },
    functions = {
        "update",
        "draw",
        "keypressed",
        "keyreleased",
        "resize",
        "mousereleased"
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

    for _, name in ipairs(self.functions) do
        if name == "draw" then
            love[name] = function()
                if love.window.isVisible() then
                    self[name](self.currentMode)
                end
            end
        else
            love[name] = function(...)
                self[name](self.currentMode, ...)
            end
        end
    end
end

function app:mode(mode)
    logger.info("Mode Change: " .. mode.name)
    self.currentMode = mode
    self.currentMode.app = self

    for _, name in ipairs(self.functions) do
        if mode[name] ~= nil then
            self[name] = mode[name]
        else
            self[name] = function() end
        end
    end

    mode:start()
end

return app