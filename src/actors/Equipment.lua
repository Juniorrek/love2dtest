local util = require("src.util.util")
local c = require("src.core.constants")
local items = require("src.items.items")

local Equipment = {}

local equipDefaultSpts = love.graphics.newImage("assets/images/items/equipments_default.png")

function Equipment.new()
    local equipment = {}
    local oy = 10

    function equipment:canEquip(itemId)
        if itemId == items.axe.id then
            if self.rhand == nil then
                return true
            elseif self.lhand == nil then
                return true
            end
            return false
        end
    end

    function equipment:equip(item)
        if item.id == items.axe.id then
            if self.rhand == nil then
                self.rhand = item
            elseif self.lhand == nil then
                self.lhand = item
            end
        end
    end

    function equipment:handleMousepressed(x, y, button, callback)
        -- TODO unequip

        --[[ if x > X_INV+32 and x < X_INV + inventory.max*32+32 and y > Y_INV and y < Y_INV + 32 then
            local diff = x-(X_INV+32)
            local slotClicked = (math.floor((diff+32)/32))
            
            if self.slots[slotClicked] ~= nil then
                if self.slots[slotClicked].id == items.axe.id then-- TODO REMOVE PLAYER  FAZ
                    callback(slotClicked)
                end
            end
        end ]]
    end

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

    function equipment:drawEquipments()
        --AMULET/HEAD/BACKPACK
        if self.amulet == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,1, 1,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16
                    )
        else 

        end
        if self.head == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,1, 2,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 82,
                        (love.graphics.getHeight()/3)-16-oy
                    )
        else

        end
        if self.backpack == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,1, 3,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 50,
                        (love.graphics.getHeight()/3)-16
                    )
        else
            
        end
        --RHAND/TORSO/LHAND
        if self.rhand == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,2, 1,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16+32
                    )
        else 
            love.graphics.draw(
                        items[self.rhand.id].spritesheet,
                        items[self.rhand.id].sptsQuad,
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16+32
                    )
        end
        if self.torso == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,2, 2,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 82,
                        (love.graphics.getHeight()/3)-16-oy+32
                    )
        else

        end
        if self.lhand == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,2, 3,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 50,
                        (love.graphics.getHeight()/3)-16+32
                    )
        else
            love.graphics.draw(
                        items[self.lhand.id].spritesheet,
                        items[self.lhand.id].sptsQuad,
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16+32
                    )
        end
        --RRING/LEGS/LRING
        if self.rring == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,3, 1,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 114,
                        (love.graphics.getHeight()/3)-16+64
                    )
        else 

        end
        if self.legs == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,3, 2,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 82,
                        (love.graphics.getHeight()/3)-16-oy+64
                    )
        else

        end
        if self.zzzzz == nil then
            love.graphics.draw(
                        equipDefaultSpts,
                        util.makeQuad(equipDefaultSpts,3, 3,c.TILE_SIZE,c.TILE_SIZE),
                        love.graphics.getWidth() - 50,
                        (love.graphics.getHeight()/3)-16+64
                    )
        else
            
        end
        --BOOTS
        if self.boots == nil then
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