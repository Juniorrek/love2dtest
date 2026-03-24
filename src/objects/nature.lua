local nature = {}

nature.tree = love.graphics.newImage("assets/images/objects/nature/tree.png")
nature.bush = love.graphics.newImage("assets/images/objects/nature/bush.png")

function nature.draw()
    love.graphics.draw(nature.tree, 256, 256)
end

return nature;