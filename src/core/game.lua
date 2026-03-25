local Player = require("src.actors.Player")
local nature = require("src.objects.nature")
local map = require("src.world.map")

local game = {}

local player

function game.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0, 0.7, 1)

    local ambienceSound = love.audio.newSource("assets/audio/music/meadowAmbience.ogg", "stream")
    love.audio.play(ambienceSound)

    player = Player.new()
end

function game.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    player:handleKeyPressed(key)
end

function game.update(dt)
    player:update(dt)
end

function game.draw()
    player:draw()
    map.draw()
end

return game