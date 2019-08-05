local maprender = {
    name = "maprender",
    tiles = {},
    tileInstances = {},
    x = 0,
    y = 0,
}

function maprender:start()
    self:loadmap("graphics/map.lua")
end

function maprender:update(dt)
    if love.keyboard.isDown("down") then
        self.y = self.y - 100 * dt
    end
    if love.keyboard.isDown("up") then
        self.y = self.y + 100 * dt
    end
    if love.keyboard.isDown("right") then
        self.x = self.x - 100 * dt
    end
    if love.keyboard.isDown("left") then
        self.x = self.x + 100 * dt
    end

    for _, tile in pairs(self.tiles) do
        if tile.animation then
            local update = false
            tile.time = tile.time + dt * 1000

            while tile.time > tile.animation[tile.frame].duration do
                update = true
                tile.time = tile.time - tile.animation[tile.frame].duration

                tile.frame = tile.frame + 1
                if tile.frame > #tile.animation then 
                    tile.frame = 1 
                end
            end

            if update and self.tileInstances[tile.gid] then
                for _, instance in pairs(self.tileInstances[tile.gid]) do
                    local t = self.tiles[tile.animation[tile.frame].tileid + tile.tileset.firstgid]
                    instance.batch:set(instance.id, t.quad, instance.x, instance.y)
                    instance.layer.isdirty = true
                end
            end
        end
    end
end

function maprender:draw()
    love.graphics.clear(0.5, 0.5, 0.5)

    local isdirty = false
    for _, layer in ipairs(self.map.layers) do
        isdirty = isdirty or layer.isdirty
        if layer.isdirty then
            love.graphics.setCanvas(layer.canvas)
            for _, batch in pairs(layer.batches) do
                love.graphics.draw(batch, layer.x, layer.y)
            end
            layer.isdirty = false
        end
    end

    if isdirty then
        love.graphics.setCanvas(self.canvas)
        for _, layer in ipairs(self.map.layers) do
            love.graphics.draw(layer.canvas, 0, 0)
        end
        love.graphics.setCanvas()
    end

    love.graphics.draw(self.canvas, self.x, self.y)
end

function maprender:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- tiled map importer/renderer written using:
-- https://github.com/karai17/Simple-Tiled-Implementation

function maprender:loadmap(path)
    self:loadpath(path)
    self:initialiseTilesets()
    self:initialiseLayers()
end

function maprender:loadpath(path)
    assert(type(path) == "string", "Map path should be a string")

    local extension = path:sub(-4, -1)
    assert(extension == ".lua", string.format("Invalid file type: %s. Must be .lua", extension))

    assert(love.filesystem.getInfo(path), "Could not find map file")

    self.dir = path:reverse():find("[/\\]") or ""
    if self.dir ~= "" then
        self.dir = path:sub(1, 1 + (#path - self.dir))
    end

    self.path = path

    self.map = love.filesystem.load(path)()
end

function maprender:initialiseTilesets()
    for i, tileset in ipairs(self.map.tilesets) do

        tileset.image = love.graphics.newImage(self.dir .. tileset.image)

        local width = math.floor(tileset.imagewidth / tileset.tilewidth)
        local height = math.floor(tileset.imageheight / tileset.tileheight)

        local globalId = tileset.firstgid

        for y = 1, height do
            for x = 1, width do

                local animation
                for _, tile in pairs(tileset.tiles) do
                    if tile.id == globalId - tileset.firstgid then
                        animation = tile.animation
                    end
                end

                self.tiles[globalId] = {
                    gid = globalId,
                    tileset = tileset,
                    quad = love.graphics.newQuad(
                        (x - 1) * tileset.tilewidth, (y - 1) * tileset.tileheight,
                        tileset.tilewidth, tileset.tileheight,
                        tileset.imagewidth, tileset.imageheight
                    ),
                    width = tileset.tilewidth, 
                    height = tileset.tileheight,
                    animation = animation,
                    time = 0,
                    frame = 1
                }

                globalId = globalId + 1
            end
        end
    end
end

function maprender:initialiseLayers()
    local maxWidth = 0
    local maxHeight = 0

    for _, layer in ipairs(self.map.layers) do
        local data = {}

        local i = 1

        -- link layer to tileset
        for y = 1, layer.height do
            data[y] = {}
            for x = 1, layer.width do
                local gid = layer.data[i]

                if gid > 0 then
                    data[y][x] = self.tiles[gid]
                end

                i = i + 1
            end
        end

        layer.data = data
        layer.batches = {}

        for y = 1, layer.height do
            for x = 1, layer.width do
                local tile = layer.data[y][x]

                if tile then
                    local tileX = (x - 1) * self.map.tilewidth
                    local tileY = (y - 1) * self.map.tileheight

                    layer.batches[tile.tileset] = layer.batches[tile.tileset] or 
                        love.graphics.newSpriteBatch(tile.tileset.image, layer.height * layer.width)

                    local batch = layer.batches[tile.tileset]

                    local instance = {
                        layer = layer,
                        gid = tile.gid,
                        x = tileX,
                        y = tileY,
                        batch = batch,
                        id = batch:add(
                            tile.quad, tileX, tileY
                        )
                    }

                    self.tileInstances[tile.gid] = self.tileInstances[tile.gid] or {}
                    table.insert(self.tileInstances[tile.gid], instance)
                end
            end
        end

        self.map.layers[layer.name] = layer
        layer.isdirty = true

        local pixelWidth = layer.width * self.map.tilewidth
        local pixelHeight = layer.height * self.map.tileheight
        layer.canvas = love.graphics.newCanvas(pixelWidth, pixelHeight)
        layer.canvas:setFilter("nearest", "nearest")

        maxWidth = math.max(maxWidth, pixelWidth)
        maxHeight = math.max(maxHeight, pixelHeight)
    end

    self.canvas = love.graphics.newCanvas(maxWidth, maxHeight)
    self.canvas:setFilter("nearest", "nearest")
end

return maprender