local items = require("src.items.items")
local constants = require("src.core.constants")

local light = {}

function light.draw(objs)
    for y,v in pairs(objs) do
        for x, obj in pairs(v) do
            if obj ~= nil then
                local tileX = (x - 1) * constants.TILE_SIZE
                local tileY = (y - 1) * constants.TILE_SIZE

                if items[obj.id].light then
                    local _, __, w, h = items[obj.id].sptsQuad:getViewport()
                    love.graphics.setColor(1, 1, 0, 0.25)
                    love.graphics.circle("fill", tileX + w/2, tileY + h/2, items[obj.id].lightRadius)
                    love.graphics.setColor(1, 1, 1)
                end
            end
        end
    end
end

return light