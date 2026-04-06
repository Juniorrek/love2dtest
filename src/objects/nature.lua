local constants = require("src.core.constants")
local s = require("src.util.sprites")
local items = require("src.items.items")

local nature = {}

nature.tiles = {
    TREE = 22,
    BUSH = 27,
    BRANCH = 173,
    STONE = 631
}

function nature.randomGeneration(map, itemId)
    local itemsOnMap = 0
    for y, row in pairs(map.objects) do
        for x, col in pairs(row) do
            if map.objects[y][x].id == itemId then
                itemsOnMap = itemsOnMap + 1
            end
        end
    end

    local maxItems = 10
    local itemsToGenerate = maxItems - itemsOnMap

    for i = 1, itemsToGenerate do
        local itemGenerated = false
        repeat
            -- TODO give preference to specific tiles (stony grassy..)
            local rX = love.math.random(11) + 1
            local rY = love.math.random(11) + 1

            local natureEmpty = map.tilemap.layers["Nature.Nature"].data[rY][rX] == nil
            if (map.objects[rY] == nil or map.objects[rY][rX] == nil) and natureEmpty then
                if map.objects[rY] == nil then
                    map.objects[rY] = {}
                end
                map.objects[rY][rX] = {
                    id = itemId,
                    qnt = 1
                }
                itemGenerated = true
            end
        until itemGenerated
    end
end

return nature