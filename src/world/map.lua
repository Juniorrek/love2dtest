local nature = require("src.objects.nature")
local constants = require("src.core.constants")
local items = require("src.items.items")
local light = require("src.world.light")

local sti = require("libraries.sti")

local map = {}

function map.loadObjectsFromTiles()
    for y,v in ipairs(map.tilemap.layers["Nature.Objects"].data) do
        for x, tile in pairs(v) do
            if tile ~= nil then
                if tile.id == nature.tiles.STONE then
                    if map.objects[y] == nil then
                        map.objects[y] = {}
                    end

                    map.objects[y][x] = {
                        id = items.stone.id,
                        qnt = 1
                    }
                elseif tile.id == nature.tiles.BRANCH then
                    if map.objects[y] == nil then
                        map.objects[y] = {}
                    end

                    map.objects[y][x] = {
                        id = items.branch.id,
                        qnt = 1
                    }
                end
            end
        end
    end
end

function map.load()
    map.tilemap = sti("assets/map.lua")

    map.objects = {}
    map.loadObjectsFromTiles()

    nature.randomGeneration(map, items.stone.id)
    nature.randomGeneration(map, items.fiber.id)

    map.width = map.tilemap.width * map.tilemap.tilewidth
    map.height = map.tilemap.height * map.tilemap.tileheight
end

local chopTreeSfx = love.audio.newSource("assets/audio/sfx/secretaria.mp3", "static")

function map.movableTile(x, y)
    return map.tilemap.layers["Collision"].data[y][x] == nil
end

function map.addObjAt(obj, x, y)
    if map.objects[y] == nil then
        map.objects[y] = {}
    end
    map.objects[y][x] = obj
end

function map.hasObjAt(objId, x, y)
    if map.objects[y] == nil or map.objects[y][x] == nil then
        return false
    end
    if objId == 0 then
        return map.objects[y][x] ~= nil
    end

    return map.objects[y][x].id == items[objId].id
end

function map.hasTileAt(tileId, x, y)
    if map.tilemap.layers["Nature.Nature"].data[y][x] == nil then
        return false
    end
    if tileId == 0 then
        return map.tilemap.layers["Nature.Nature"].data[y][x] ~= nil
    end

    return map.tilemap.layers["Nature.Nature"].data[y][x].id == tileId
end

function map.removeTreeAt(x, y)
    map.tilemap:setLayerTile("Nature.Nature", x, y, 0)

    map.tilemap:setLayerTile("Nature.Above Nature", x, y-1, 0)
    map.tilemap:setLayerTile("Nature.Above Nature", x-1, y-1, 0)
    map.tilemap:setLayerTile("Nature.Above Nature", x-1, y, 0)

    map.tilemap:setLayerTile("Collision", x, y, 0)

    --love.audio.play(chopTreeSfx)
end

function map.removeTileAt(x, y)
    map.tilemap:setLayerTile("Nature.Nature", x, y, 0)
end

function map.removeObjectAt(x, y)
    map.objects[y][x] = nil
end



function map.interact(x, y)
    local type = ""
    if map.hasObjAt(items.stone.id, x, y) then
        type = "stone"
    elseif map.hasTileAt(nature.tiles.BRANCH, x, y) then
        type = "branch"
    elseif map.hasTileAt(nature.tiles.TREE, x, y) then
        type = "tree"
    end

    return type
end

 function map.getTileAtMouse(x, y)
    local tileX = math.floor((x+32)/32)
    local tileY = math.floor((y+32)/32)
    return tileX, tileY
end

function map.drawObjects(camera)
    for y = camera.startY, camera.endY do
        for x = camera.startX, camera.endX do
            if map.objects[y] then
                local obj = map.objects[y][x]
                if obj ~= nil then
                    love.graphics.draw(
                        items[obj.id].spritesheet,
                        items[obj.id].sptsQuad,
                        (x-1) * constants.TILE_SIZE,
                        (y-1) * constants.TILE_SIZE
                    )
                end
            end
        end
    end
end

function map.drawGround(camera)
    for y = camera.startY, camera.endY do
        for x = camera.startX, camera.endX do
            local groundTile = map.tilemap.layers["Ground"].data[y][x]
            if groundTile ~= nil then
                love.graphics.draw(
                    map.tilemap.tilesets[groundTile.tileset].image,
                    groundTile.quad,
                    (x-1) * constants.TILE_SIZE,
                    (y-1) * constants.TILE_SIZE
                )
            end

            local natureTile = map.tilemap.layers["Nature.Nature"].data[y][x]
            if natureTile ~= nil then
                love.graphics.draw(
                    map.tilemap.tilesets[natureTile.tileset].image,
                    natureTile.quad,
                    (x-1) * constants.TILE_SIZE,
                    (y-1) * constants.TILE_SIZE
                )
            end
        end
    end

    map.drawObjects(camera)
end

function map.drawAbove(camera)
    for y = camera.startY, camera.endY do
        for x = camera.startX, camera.endX do
            local natureAbove = map.tilemap.layers["Nature.Above Nature"].data[y][x]
            if natureAbove ~= nil then
                love.graphics.draw(
                    map.tilemap.tilesets[natureAbove.tileset].image,
                    natureAbove.quad,
                    (x-1) * constants.TILE_SIZE,
                    (y-1) * constants.TILE_SIZE
                )
            end
        end
    end

    light.draw(map.objects)
end

return map