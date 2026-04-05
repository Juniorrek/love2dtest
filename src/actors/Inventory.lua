local items = require("src.items.items")
local util = require("src.util.util")

local Inventory = {}

function Inventory.new(maxSize)
    local inventory = {
        slots = {
            {
                id = items.axe.id,
                qnt = 1
            }
        },
        max = maxSize
    }

    local X_INV = (love.graphics.getWidth() - (inventory.max*32))/2 -- center
            
    local Y_INV = love.graphics.getHeight() - 50

    function inventory:hasItem(item)

    end

    function inventory:countItem(itemId)
        local count = 0
        for k, v in pairs(self.slots) do
            if v.id == itemId then
                count = count + 1
            end
        end
        return count
    end

    function inventory:hasItemsFromRecipe(ingredients)
        for k, item in pairs(ingredients) do
            
            local qntOwned = self:countItem(item.id)
            if qntOwned < item.qnt then
                return false
            end
        end

        return true
    end

    function inventory:deleteItem()
    end

    function inventory:deleteItemFromSlot(slot)
        self.slots[slot] = nil
    end

    function inventory:deleteItemsByRecipe(ingredients)
        for k, ing in pairs(ingredients) do
            local qntRemove = ing.qnt
            for j, slot in pairs(self.slots) do
                if slot.id == ing.id then
                    if slot.qnt - qntRemove > 0 then
                        slot.qnt = slot.qnt - qntRemove
                        qntRemove = 0
                    else
                        qntRemove = qntRemove - slot.qnt
                        slot.qnt = 0
                        self.slots[j] = nil
                    end
                end

                if qntRemove == 0 then
                    break
                end
            end
        end
    end

    function inventory:hasFreeSlots(qnt)
        --[[ local slotsNeeded = 0
        for k, rew in pairs(rewards) do
            if not items[rew.id].stackable then
                slotsNeeded = slotsNeeded + 1
            else
                -- TODO improve latter treat each reward as one, catching stacking, if someone can't be picked it doesn't pick and get in the ground
                slotsNeeded = slotsNeeded + 
                    items[rew.id].maxSize --TODO check where can stack or need a slot
            end
        end ]]


        local slotAvailable = self.max - util.countElementsSparseTable(self.slots)
        if slotAvailable >= qnt then return true
        else return false end
    end

    function inventory:nextSlotAvailable()
        local rest = self.max - util.countElementsSparseTable(self.slots)
        local nextSlot = self.max - rest + 1
        return nextSlot
    end

    function inventory:addItem(item)
        local nextSlot = self:nextSlotAvailable()
        self.slots[nextSlot] = item
    end

    function inventory:addItems(rewards)
        for k, rew in pairs(rewards) do
            local nextSlot = self:nextSlotAvailable()
            self.slots[nextSlot] = rew
        end
    end

    function inventory:clickedOnInventory(x, y)
        --TODO +32 ESQUISITO
        if x > X_INV+32 and x < X_INV + inventory.max*32+32 and y > Y_INV and y < Y_INV + 32 then
            return true
        end

        return false
    end

    function inventory.getSlotAtMouse(x, y)
        local diff = x-(X_INV+32)
        local slotClicked = (math.floor((diff+32)/32))

        return slotClicked
    end

    function inventory:handleMousepressed(x, y, button, callback)
        --TODO +32 ESQUISITO
        if x > X_INV+32 and x < X_INV + inventory.max*32+32 and y > Y_INV and y < Y_INV + 32 then
            if button == 1 then
                local diff = x-(X_INV+32)
                local slotClicked = (math.floor((diff+32)/32))
                
                if self.slots[slotClicked] ~= nil then
                    if self.slots[slotClicked].id == items.axe.id then-- TODO REMOVE PLAYER  FAZ
                        callback(slotClicked)
                    end
                end
            end
        end
    end

    function inventory:draw()
        for i = 1, self.max do
            local X_INV_OFF = X_INV + (32*i) --per slot offset

            love.graphics.rectangle("line", X_INV_OFF, Y_INV, 32, 32)

            if self.slots[i] then
                love.graphics.draw(
                    items[self.slots[i].id].spritesheet,
                    items[self.slots[i].id].sptsQuad,
                    X_INV_OFF,
                    Y_INV
                )
            end
        end
    end


    return inventory
end

return Inventory