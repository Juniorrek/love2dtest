local constants = require("src.core.constants")
local player = require("src.actors.player")
local nature = require("src.objects.nature")
local map = require("src.world.map")

local game = {}

function game.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    love.graphics.setBackgroundColor(0, 0.7, 1)

    sound = love.audio.newSource("assets/audio/music/meadow_ambience.ogg", "stream")
    love.audio.play(sound)
end

function game.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function game.update(dt)
    player.update(dt)
end

function game.draw()
    player.draw()

    map.draw()
    
    nature.draw()
end

return game