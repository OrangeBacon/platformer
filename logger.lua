local logger = {}

function logger.start(message)
    logger.file = "log-" .. os.date("%Y%m%d%H%M%S") .. ".txt"
end

function logger.info(message)
    love.filesystem.append(logger.file, "[*] " .. message .. "\n")
end

function logger.error(message)
    love.filesystem.append(logger.file, "[ERROR]" .. message .. "\n")
end

return logger