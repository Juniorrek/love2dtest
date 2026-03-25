local tiles = {
    TREE = 2
}

local nature = {}

nature.tree = love.graphics.newImage("assets/images/objects/nature/tree.png")
nature.bush = love.graphics.newImage("assets/images/objects/nature/bush.png")

function nature.draw(tile, x, y)
    if tile == tiles.TREE then
        love.graphics.draw(nature.tree, x * 32 - 32, y * 32 - 32)
    end
end

return nature;