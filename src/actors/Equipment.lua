local util = require("src.util.util")
local c = require("src.core.constants")

local Equipment = {}

local equipDefaultSpts = love.graphics.newImage("assets/images/items/equipments_default.png")

function Equipment.new()
    local equipment = {}
    local oy = 10

    function equipment.drawSlots()
        --AMULET/HEAD/BACKPACK
        love.graphics.rectangle("line", love.graphics.getWidth() - 50,  (love.graphics.getHeight()/3)-16, 32, 32)
        love.graphics.rectangle("line", love.graphics.getWidth() - 82,  (love.graphics.getHeight()/3)-16-oy, 32, 32)
        love.graphics.rectangle("line", love.graphics.getWidth() - 114,  (love.graphics.getHeight()/3)-16, 32, 32)
        --RHAND/TORSO/LHAND
        love.graphics.rectangle("line", love.graphics.getWidth() - 50,  (love.graphics.getHeight()/3)-16+32, 32, 32)
        love.graphics.rectangle("line", love.graphics.getWidth() - 82,  (love.graphics.getHeight()/3)-16-oy+32, 32, 32)
        love.graphics.rectangle("line", love.graphics.getWidth() - 114,  (love.graphics.getHeight()/3)-16+32, 32, 32)
        --RRING/LEGS/LRING
        love.graphics.rectangle("line", love.graphics.getWidth() - 50,  (love.graphics.getHeight()/3)-16+64, 32, 32)
        love.graphics.rectangle("line", love.graphics.getWidth() - 82,  (love.graphics.getHeight()/3)-16-oy+64, 32, 32)
        love.graphics.rectangle("line", love.graphics.getWidth() - 114,  (love.graphics.getHeight()/3)-16+64, 32, 32)
        --BOOTS
        love.graphics.rectangle("line", love.graphics.getWidth() - 82,  (love.graphics.getHeight()/3)-16-oy+96, 32, 32)
    end

    function equipment.drawEquipments()
        --AMULET/HEAD/BACKPACK
        if equipment.amulet == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,1, 1,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16
                    )
        else 

        end
        if equipment.head == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,1, 2,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 82,
                        (love.graphics.getHeight()/3)-16-oy
                    )
        else

        end
        if equipment.backpack == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,1, 3,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 50,
                        (love.graphics.getHeight()/3)-16
                    )
        else
            
        end
        --RHAND/TORSO/LHAND
        if equipment.rhand == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,2, 1,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16+32
                    )
        else 

        end
        if equipment.torso == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,2, 2,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 82,
                        (love.graphics.getHeight()/3)-16-oy+32
                    )
        else

        end
        if equipment.lhand == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,2, 3,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 50,
                        (love.graphics.getHeight()/3)-16+32
                    )
        else
            
        end
        --RRING/LEGS/LRING
        if equipment.rring == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,3, 1,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16+64
                    )
        else 

        end
        if equipment.legs == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,3, 2,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 82,
                        (love.graphics.getHeight()/3)-16-oy+64
                    )
        else

        end
        if equipment.zzzzz == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,3, 3,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 50,
                        (love.graphics.getHeight()/3)-16+64
                    )
        else
            
        end
        --BOOTS
        if equipment.boots == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,4, 2,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 82,
                        (love.graphics.getHeight()/3)-16-oy+96
                    )
        else

        end
    end

    function equipment:draw()
        self:drawSlots()
        self:drawEquipments()
    end

    return equipment
end

return Equipment