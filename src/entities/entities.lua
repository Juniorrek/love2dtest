local Entities = {}

local entities_grid = {}

function Entities.new(entity)
    local entity = entity

    if entities_grid[entity.position.grid.y] == nil then
        entities_grid[entity.position.grid.y] = {}
    end
    entities_grid[entity.position.grid.y][entity.position.grid.x] = entity

    return entity
end

function Entities.moveEntity(entity, newX, newY)
    local oldX = entity.position.grid.x
    local oldY = entity.position.grid.y
    entities_grid[oldY][oldX] = nil

    if entities_grid[newY] == nil then
        entities_grid[newY] = {}
    end

    entities_grid[newY][newX] = entity

    entity.position.grid.x = entity.targetPosition.grid.x
    entity.position.grid.y = entity.targetPosition.grid.y
end

function Entities.update(dt)
    for k, v in pairs(entities_grid) do
        for j, vv in pairs(v) do
            print(j)
        end
    end
end

function Entities.hasEntityAt(x, y)
    return entities_grid[y] and entities_grid[y][x]
end

return Entities