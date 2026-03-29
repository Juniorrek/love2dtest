local nature = require("src.objects.nature")

local sti = require("libraries.sti")

local map = {}

function map.load()
    map.tilemap = sti("assets/map.lua")
end

local chopTreeSfx = love.audio.newSource("assets/audio/sfx/secretaria.mp3", "static")

function map.movableTile(x, y)
    return map.tilemap.layers["Collision"].data[y][x] == nil
end

function map.hasTreeAt(x, y)
    if map.tilemap.layers["Nature.Nature"].data[y][x] == nil then
        return false
    end
    return map.tilemap.layers["Nature.Nature"].data[y][x].id == nature.tiles.TREE
end

function map.removeAt(x, y)
    map.tilemap:setLayerTile("Nature.Nature", x, y, 0)

    map.tilemap:setLayerTile("Nature.Above Nature", x, y-1, 0)
    map.tilemap:setLayerTile("Nature.Above Nature", x-1, y-1, 0)
    map.tilemap:setLayerTile("Nature.Above Nature", x-1, y, 0)

    map.tilemap:setLayerTile("Collision", x, y, 0)

    love.audio.play(chopTreeSfx)
end

function map.drawGround()
    map.tilemap:drawTileLayer("Ground")
    map.tilemap:drawTileLayer("Nature.Nature")
end

function map.drawAbove()
    map.tilemap:drawTileLayer("Nature.Above Nature")
end

return map