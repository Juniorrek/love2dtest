local nature = require("src.objects.nature")
local constants = require("src.core.constants")

local sti = require("libraries.sti")

local map = {}

function map.load()
    map.tilemap = sti("assets/map.lua")

    map.stones = {}
    for y,v in ipairs(map.tilemap.layers["Nature.Objects"].data) do
        for x, tile in pairs(v) do
            if tile ~= nil then
                if tile.id == nature.tiles.STONE then
                    table.insert(map.stones, {
                        x = x,
                        y = y
                    })
                end
            end
        end
    end

    nature.generateStones(map)
end

local chopTreeSfx = love.audio.newSource("assets/audio/sfx/secretaria.mp3", "static")

function map.movableTile(x, y)
    return map.tilemap.layers["Collision"].data[y][x] == nil
end

function map.hasAt(tileId, x, y)
    if tileId == nature.tiles.STONE then
        for k, v in ipairs(map.stones) do
            if x == v.x and y == v.y then
                return true
            end
        end
    end

    return false
end

function map.hasTileAt(tileId, x, y)
    if map.tilemap.layers["Nature.Nature"].data[y][x] == nil then
        return false
    end
    return map.tilemap.layers["Nature.Nature"].data[y][x].id == tileId
end

function map.hasTreeAt(x, y)
    if map.tilemap.layers["Nature.Nature"].data[y][x] == nil then
        return false
    end
    return map.tilemap.layers["Nature.Nature"].data[y][x].id == nature.tiles.TREE
end

function map.removeTreeAt(x, y)
    map.tilemap:setLayerTile("Nature.Nature", x, y, 0)

    map.tilemap:setLayerTile("Nature.Above Nature", x, y-1, 0)
    map.tilemap:setLayerTile("Nature.Above Nature", x-1, y-1, 0)
    map.tilemap:setLayerTile("Nature.Above Nature", x-1, y, 0)

    map.tilemap:setLayerTile("Collision", x, y, 0)

    love.audio.play(chopTreeSfx)
end

function map.removeTileAt(x, y)
    map.tilemap:setLayerTile("Nature.Nature", x, y, 0)
end

function map.removeAt(tileId, x, y)
    if tileId == nature.tiles.STONE then
        for k, v in ipairs(map.stones) do
            if x == v.x and y == v.y then
                table.remove(map.stones, k)
            end
        end
    end
end

function map.removeStoneAt(x, y)
    map.tilemap:setLayerTile("Nature.Nature", x, y, 0)
end

function map.drawStones(self)
    for i, v in ipairs(self.stones) do
        love.graphics.draw(
            nature.spriteSheet,
            nature.stoneQuad,
            (v.x - 1) * constants.TILE_SIZE,
            (v.y - 1) * constants.TILE_SIZE
        )
    end
end

function map.drawGround()
    map.tilemap:drawTileLayer("Ground")
    map.tilemap:drawTileLayer("Nature.Nature")

    map:drawStones()
end

function map.drawAbove()
    map.tilemap:drawTileLayer("Nature.Above Nature")
end

return map