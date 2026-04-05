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

function nature.generateStones(map)
    local stonesOnMap = 0
    for y, row in pairs(map.objects) do
        for x, col in pairs(row) do
            if map.objects[y][x].id == items.stone.id then
                stonesOnMap = stonesOnMap + 1
            end
        end
    end

    local maxStones = 10
    local stonesToGenerate = maxStones - stonesOnMap

    for i = 1, stonesToGenerate do
        local stoneGenerated = false
        repeat
            -- TODO give preference to stone tiles
            local rX = love.math.random(11) + 1
            local rY = love.math.random(11) + 1

            local natureEmpty = map.tilemap.layers["Nature.Nature"].data[rY][rX] == nil
            if (map.objects[rY] == nil or map.objects[rY][rX] == nil) and natureEmpty then
                if map.objects[rY] == nil then
                    map.objects[rY] = {}
                end
                map.objects[rY][rX] = {
                    id = items.stone.id,
                    qnt = 1
                }
                stoneGenerated = true
            end
        until stoneGenerated
    end
end

return nature