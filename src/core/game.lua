local Player = require("src.actors.Player")
local map = require("src.world.map")
local config = require("src.core.config")

local game = {}

local player

function game.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0, 0.7, 1)

    local ambienceSound = love.audio.newSource("assets/audio/music/meadowAmbience.ogg", "stream")
    if config.sound == "on" then
        love.audio.play(ambienceSound)
    end

    --TODO game informs map lua
    map.load()

    player = Player.new()

end

function game.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    player:handleKeyPressed(key)
end

function game.mousepressed(x, y, button)
    player:handleMousepressed(x, y, button)
end

function game.update(dt)
    player:update(dt)
end

function game.draw()
    map.drawGround()
    player:draw()
    map.drawAbove()
end

return game