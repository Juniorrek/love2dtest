local nature = require("src.objects.nature")

local map = {}

map.tilemap = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 2, 0, 1, 0, 0, 0, 2, 5, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 3, 4, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 4, 3, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1},
    {1, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 2, 0, 0, 1, 0, 0, 2, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}

function map.movableTile(x, y)
    return map.tilemap[y][x] == 0
end

function map.hasTreeAt(x, y)
    return map.tilemap[y][x] == 2
end

function map.removeAt(x, y)
    map.tilemap[y][x] = 0
end

function map.draw()
    for y, row in ipairs(map.tilemap) do
        for x, tile in ipairs(row) do
            if tile ~= 0 then
                if tile == 1 then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.draw(nature.bush, x * 32, y * 32)
                elseif tile == 2 then
                    love.graphics.setColor(1, 1, 1)
                    nature.draw(tile, x, y)
                elseif tile == 3 then
                    love.graphics.setColor(1, 0, 1)
                    love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
                elseif tile == 4 then
                    love.graphics.setColor(0, 0, 1)
                    love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
                elseif tile == 5 then
                    love.graphics.setColor(0, 1, 1)
                    love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
                end
            else
                love.graphics.setColor(1, 1, 1)
            end
        end
    end
end

return map