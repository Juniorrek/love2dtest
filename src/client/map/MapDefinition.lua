local sti = require("libraries.sti")

-- This module is responsible for loading the map definition, which includes the tiles and tilesets information, but not the current state of the map/data, that is given by the server
local MapDefinition = {
    loaded = false,
    layers = {}
}

function MapDefinition.load()
    if MapDefinition.loaded then return end

    local tilemap = sti("assets/map.lua")
    MapDefinition.tiles = tilemap.tiles
    MapDefinition.tilesets = tilemap.tilesets
    MapDefinition.loaded = true
end

function MapDefinition.getTileDrawData(gid)
    local tile = MapDefinition.tiles[gid]
    if tile then
        local tileset = MapDefinition.tilesets[tile.tileset]
        return {
            image = tileset.image,
            quad = tile.quad
        }
    end
    return nil
end

return MapDefinition