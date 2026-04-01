local constants = require("src.core.constants")

local nature = {}

nature.spriteSheet = love.graphics.newImage("assets/other/otsp_nature_01.png")
nature.stoneQuad = love.graphics.newQuad(
    7 * constants.TILE_SIZE,
    39 * constants.TILE_SIZE,
    constants.TILE_SIZE,
    constants.TILE_SIZE,
    nature.spriteSheet:getDimensions()
)

nature.tiles = {
    TREE = 22,
    BUSH = 27,
    BRANCH = 173,
    STONE = 631
}

function nature.generateStones(map)
    local maxStones = 10
    local stonesToGenerate = 10 - #map.stones
    for i = 1, stonesToGenerate do
        local stoneGenerated = false
        repeat
            -- TODO give preference to stone tiles
            local randomX = love.math.random(11) + 1
            local randomY = love.math.random(11) + 1
            if map.tilemap.layers["Nature.Nature"].data[randomY][randomX] == nil then
                table.insert(map.stones, {
                    x = randomX,
                    y = randomY
                })
                stoneGenerated = true
            end
        until stoneGenerated
    end
end

return nature;