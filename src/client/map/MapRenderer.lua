local constants = require("src.core.constants")
local MapDefinition = require("src.client.map.MapDefinition")

local MapRenderer = {}

function MapRenderer.drawGround(layers, camera)
    local groundData = layers.ground
    local natureData = layers.nature
    for y = camera.startY, camera.endY do
        for x = camera.startX, camera.endX do
            if groundData[y] then
                local groundTile = groundData[y][x]
                if groundTile ~= nil then
                    local drawData = MapDefinition.getTileDrawData(groundTile)
                    love.graphics.draw(
                        drawData.image,
                        drawData.quad,
                        (x-1) * constants.TILE_SIZE,
                        (y-1) * constants.TILE_SIZE
                    )
                end
            end

            if natureData[y] then
                local natureTile = natureData[y][x]
                if natureTile ~= nil then
                    local drawData = MapDefinition.getTileDrawData(natureTile)
                    love.graphics.draw(
                        drawData.image,
                        drawData.quad,
                        (x-1) * constants.TILE_SIZE,
                        (y-1) * constants.TILE_SIZE
                    )
                end
            end
        end
    end
end

return MapRenderer