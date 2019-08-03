local maprender = {
    name = "maprender",
    tiles = {},
    tileInstances = {},
}

function maprender:start()
    self:loadmap("graphics/map.lua")
end

function maprender:draw()
    love.graphics.clear(0.5, 0.5, 0.5)

    for _, layer in ipairs(self.map.layers) do
        layer.draw()
    end
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
                self.tiles[globalId] = {
                    gid = globalId,
                    tileset = tileset,
                    quad = love.graphics.newQuad(
                        (x - 1) * tileset.tilewidth, (y - 1) * tileset.tileheight,
                        tileset.tilewidth, tileset.tileheight,
                        tileset.imagewidth, tileset.imageheight
                    ),
                    width = tileset.tilewidth, 
                    height = tileset.tileheight
                }

                globalId = globalId + 1
            end
        end
    end
end

function maprender:initialiseLayers()
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
                    local tileX = (x - 1) * tile.tileset.tilewidth
                    local tileY = y * tile.tileset.tileheight
                    
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
        layer.draw = function() self:drawLayer(layer) end
    end
end

function maprender:drawLayer(layer)
    for _, batch in pairs(layer.batches) do
        love.graphics.draw(batch, layer.x, layer.y)
    end
end

return maprender