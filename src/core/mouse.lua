local map = require("src.world.map")

local mouse = {}

mouse.action = {
    source = {},
    target = {}
}

function mouse.getActionKind(x, y, player)
    local kind = nil
    if player:clickedOnInventory(x, y) then
        kind = {}
        kind.id = "inventory"
        kind.slot = player.inventory.getSlotAtMouse(x, y)
    elseif x > 0 and y > 0 and x < 32*13 and y < 32*13 then
        kind = {}
        kind.id = "map"
        kind.x, kind.y = map.getTileAtMouse(x, y)
    end

    return kind
end

function mouse.transfer(player)
    if mouse.action.source.kind.id == "inventory" and mouse.action.target.kind.id == "map" then
        if not map.hasObjAt(0, mouse.action.target.kind.x, mouse.action.target.kind.y) 
            and not map.hasTileAt(0, mouse.action.target.kind.x, mouse.action.target.kind.y) 
        then
            map.addObjAt(player.inventory.slots[mouse.action.source.kind.slot], 
                mouse.action.target.kind.x,
                mouse.action.target.kind.y
            )
            player.inventory:deleteItemFromSlot(mouse.action.source.kind.slot)
        end
    elseif mouse.action.source.kind.id == "map" and mouse.action.target.kind.id == "inventory" then
        if map.objects[mouse.action.source.kind.y][mouse.action.source.kind.x] ~= nil
            and player.inventory.slots[mouse.action.target.kind.slot] == nil
        then
            player.inventory.slots[mouse.action.target.kind.slot] = map.objects[mouse.action.source.kind.y][mouse.action.source.kind.x]
            map.objects[mouse.action.source.kind.y][mouse.action.source.kind.x] = nil
        end
    elseif mouse.action.source.kind.id == "map" and mouse.action.target.kind.id == "map" then
        if not map.hasObjAt(0, mouse.action.target.kind.x, mouse.action.target.kind.y) 
            and not map.hasTileAt(0, mouse.action.target.kind.x, mouse.action.target.kind.y) 
        then
            map.addObjAt(map.objects[mouse.action.source.kind.y][mouse.action.source.kind.x], 
                mouse.action.target.kind.x,
                mouse.action.target.kind.y
            )            
            map.objects[mouse.action.source.kind.y][mouse.action.source.kind.x] = nil
        end
    elseif mouse.action.source.kind.id == "inventory" and mouse.action.target.kind.id == "inventory" then
        if player.inventory.slots[mouse.action.target.kind.slot] == nil
        then
            player.inventory.slots[mouse.action.target.kind.slot] = player.inventory.slots[mouse.action.source.kind.slot]
            player.inventory:deleteItemFromSlot(mouse.action.source.kind.slot)
        end
    end
end

function mouse.handleMousePressed(x, y, button, player)
    mouse.action.source.x = x
    mouse.action.source.y = y
    mouse.action.source.kind = mouse.getActionKind(x, y, player)
end

function mouse.handleMouseReleased(x, y, button, player)
    mouse.action.target.x = x
    mouse.action.target.y = y
    mouse.action.target.kind = mouse.getActionKind(x, y, player)

    if mouse.action.source.kind ~= nil then
        if mouse.action.source.x ~= mouse.action.target.x or mouse.action.source.y ~= mouse.action.target.y then
            if mouse.action.source.kind and mouse.action.target.kind then
                mouse.transfer(player)
            end
        else
            if mouse.action.source.kind.id == "inventory" then
                --USAR clickedOnInventory E getSlotAtMouse
                 player.inventory:handleMousepressed(x, y, button, function(slotClicked)
                    player:equipItem(slotClicked)
                end)
            end
        end
    end
end

return mouse