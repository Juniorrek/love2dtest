local nature = require("src.objects.nature")
local util = require("src.util.util")
local c = require("src.core.constants")

local items = {
    branch = {
        id = "branch",
        name = "Branch",
        stackable = true,
        maxStack = 16,
        spritesheet = nature.spriteSheet,
        sptsQuad = util.makeQuad(nature.spriteSheet,11, 14,c.TILE_SIZE,c.TILE_SIZE)
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