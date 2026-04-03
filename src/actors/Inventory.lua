local items = require("src.items.items")

local Inventory = {}

function Inventory.new(maxSize)
    local inventory = {
        slots = {},
        max = maxSize
    }

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

    function inventory:deleteItemsByRecipe(ingredients)
        for k, ing in pairs(ingredients) do
            local qntRemove = ing.qnt
            for j, slot in pairs(self.slots) do
                if slot.id == ing.id then
                    if slot.qnt - qntRemove > 0 then
                        slot.qnt = slot.qnt - qntRemove
                        qntRemove = 0
                    else
                        slot.qnt = 0
                        qntRemove = qntRemove - slot.qnt
                        slot = nil
                    end
                end

                if qntRemove == 0 then
                    break
                end
            end
        end
    end

    function inventory:hasFreeSlots(rewards)
        local slotsNeeded = 0
        for k, rew in pairs(rewards) do
            if not items[rew.id].stackable then
                slotsNeeded = slotsNeeded + 1
            else
                slotsNeeded = slotsNeeded + 
                    items[rew.id].maxSize --TODO check where can stack or need a slot
            end
        end


        local slotAvailable = self.max - #self.slots
        if slotAvailable > qnt then return true
        else return false end
    end

    function inventory:nextSlotAvailable()
        local rest = self.max - #self.slots
        local nextSlot = self.max - rest + 1
        return nextSlot
    end

    function inventory:addItems(rewards)
        for k, rew in pairs(rewards) do
            local nextSlot = self:nextSlotAvailable()
            self.inventory[nextSlot] = rew
        end
    end

    return inventory
end

return Inventory