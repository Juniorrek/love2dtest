local nature = require("src.objects.nature")

local items = {
    branch = {
        id = "branch",
        name = "Branch",
        stackable = true,
        maxStack = 16
    },
    stone = {
        id = "stone",
        name = "Stone",
        stackable = true,
        maxStack = 8,
        spritesheet = nature.spriteSheet,
        sptsQuad = nature.stoneQuad
    },
    axe = {
        id = "axe",
        name = "Axe",
        stackable = false
    }
}

return items