local nature = require("src.objects.nature")

local map = {}

function map.movableTile(x, y)
    return map.tilemap[y][x] == 0
end

map.tilemap = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 1, 0, 0, 0, 2, 5, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 3, 4, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 4, 3, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}

function map.draw()
    for i, row in ipairs(map.tilemap) do
        for j, tile in ipairs(row) do
            if tile ~= 0 then
                if tile == 1 then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.draw(nature.bush, j * 32, i * 32)
                elseif tile == 2 then
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                elseif tile == 3 then
                    love.graphics.setColor(1, 0, 1)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                elseif tile == 4 then
                    love.graphics.setColor(0, 0, 1)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                elseif tile == 5 then
                    love.graphics.setColor(0, 1, 1)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                end
            else
                love.graphics.setColor(1, 1, 1)
            end
        end
    end
end

return map