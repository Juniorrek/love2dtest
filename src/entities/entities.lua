local util = require("src.util.util")

local Entities = {}

local entities_grid = {}
local reserved_grid = {}

local entities_list = {}

function Entities.new(entity)
    local entity = entity

    table.insert(entities_list, entity)

    util.setOnGrid(entities_grid, entity.position.grid.x, entity.position.grid.y, entity)

    return entity
end

function Entities.hasEntityAt(x, y)
    return entities_grid[y] and entities_grid[y][x]
end

function Entities.hasReservationAt(x, y)
    return reserved_grid[y] and reserved_grid[y][x]
end

function Entities.isFreeAt(x, y)
    return not Entities.hasEntityAt(x, y) and not Entities.hasReservationAt(x, y)
end

function Entities.reserveTile(entity, newX, newY)
    util.setOnGrid(reserved_grid, newX, newY, entity)
    entity.targetPosition.grid.x = newX
    entity.targetPosition.grid.y = newY
end

function Entities.commitMove(entity)
    local oldX = entity.position.grid.x
    local oldY = entity.position.grid.y
    local newX = entity.targetPosition.grid.x
    local newY = entity.targetPosition.grid.y

    if reserved_grid[newY] then
        reserved_grid[newY][newX] = nil
    end
    if entities_grid[oldY] then
        entities_grid[oldY][oldX] = nil
    end

    util.setOnGrid(entities_grid, newX, newY, entity)

    entity.position.grid.x = newX
    entity.position.grid.y = newY
end

function Entities.update(dt)
    for k, v in pairs(entities_grid) do
        for j, vv in pairs(v) do
            --print(j)
        end
    end
end

function Entities.draw(camera)
    for y = camera.startY, camera.endY do
        for x = camera.startX, camera.endX do
            if entities_grid[y] and entities_grid[y][x] then
                entities_grid[y][x]:draw()
            end
        end
    end
end

return Entities