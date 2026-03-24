if arg[2] == "debug" then
    require("lldebugger").start()
end

local game = require("src.core.game")

function love.load()
    game.load()
end

function love.keypressed(key)
    game.keypressed(key)
end

function love.update(dt)
    game.update(dt)
end

function love.draw()
    game.draw()
end
