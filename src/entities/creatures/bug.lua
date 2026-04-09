local sprites = require("src.util.sprites")
local util = require("src.util.util")

local bug = {
    name = "Bug",
    hp = 15,
    spritesheet = sprites.creatures,
    aggroRange = 3,
    animationFrame = 1,
    animationTimer = 0,
    animationSpeed = 0.6,
    speed = 1,
    frameWidth = 32,
    frameHeight = 32,
    animationQuads = {
        idle = {
            down = {util.makeQuad(sprites.creatures, 1, 2, 32, 32)},
            right = {util.makeQuad(sprites.creatures, 1, 5, 32, 32)},
            up = {util.makeQuad(sprites.creatures, 1, 8, 32, 32)},
            left = {util.makeQuad(sprites.creatures, 1, 11, 32, 32)}
        },
        walking = {
            down = {
                util.makeQuad(sprites.creatures, 1, 3, 32, 32),
                util.makeQuad(sprites.creatures, 1, 4, 32, 32)
            },
            right = {
                util.makeQuad(sprites.creatures, 1, 6, 32, 32),
                util.makeQuad(sprites.creatures, 1, 7, 32, 32)
            },
            up = {
                util.makeQuad(sprites.creatures, 1, 9, 32, 32),
                util.makeQuad(sprites.creatures, 1, 10, 32, 32)
            },
            left = {
                util.makeQuad(sprites.creatures, 1, 12, 32, 32),
                util.makeQuad(sprites.creatures, 1, 13, 32, 32)
            }
        }
    },
    attackDamage = 3,
    attackCooldown = 2,
    attackSpeed = 1
}

bug.animationQuads.chasing = bug.animationQuads.walking
bug.animationQuads.attacking = bug.animationQuads.idle

return bug