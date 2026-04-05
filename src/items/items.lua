local util = require("src.util.util")
local c = require("src.core.constants")
local spts = require("src.util.sprites")

local items = {
    branch = {
        id = "branch",
        name = "Branch",
        stackable = true,
        maxStack = 16,
        spritesheet = spts.nature,
        sptsQuad = util.makeQuad(spts.nature, 11, 14,c.TILE_SIZE,c.TILE_SIZE),
        sound = {
            interaction = love.audio.newSource("assets/audio/sfx/mine_drinking.mp3", "static")
        }
    },
    stone = {
        id = "stone",
        name = "Stone",
        stackable = true,
        maxStack = 8,
        spritesheet = spts.nature,
        sptsQuad = util.makeQuad(spts.nature, 40, 8,c.TILE_SIZE,c.TILE_SIZE),
        sound = {
            interaction = love.audio.newSource("assets/audio/sfx/okay-meme.mp3", "static")
        }
    },
    axe = {
        id = "axe",
        name = "Axe",
        stackable = false,
        spritesheet = spts.items,
        sptsQuad = util.makeQuad(spts.items,14, 16,c.TILE_SIZE,c.TILE_SIZE),
        type = "weapon",
        sound = {
            --interaction = love.audio.newSource("assets/audio/sfx/secretaria.mp3", "static"),
            craft = love.audio.newSource("assets/audio/sfx/vine_boom.mp3", "static")
        }
    }
}

return items