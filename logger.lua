local logger = {}

function logger.start(message)
    love.filesystem.createDirectory("log")
    logger.file = "log/log-" .. os.date("%Y%m%d%H%M%S") .. ".txt"
    love.filesystem.write(logger.file, "[*] Created Log")

    local maxLogs = 5
    local logs = love.filesystem.getDirectoryItems("log")

    if #logs > maxLogs then
        local oldestName = ""
        local oldestAge = 2 ^ 64
        for i,v in ipairs(logs) do
            local age = love.filesystem.getInfo("log/" .. v).modtime
            if oldestAge > age then
                oldestName = v
                oldestAge = age
            end
        end
        love.filesystem.remove("log/" .. oldestName)
    end
end

function logger.info(message)
    love.filesystem.append(logger.file, "\n[*] " .. message)
end

function logger.error(message)
    love.filesystem.append(logger.file, "\n[ERROR]" .. message)
end

return logger