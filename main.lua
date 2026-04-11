if arg[2] == "debug" then
    require("lldebugger").start()
end

local game = require("src.core.game")
local Server = require("src.server.server")
local Client = require("src.client.client")

function love.load()
    --game.load()
end

function love.keypressed(key)
    if key == "f1" then -- Starts server and connects to it
        Server.start()
        Client.connect()
    elseif key == "f2" then -- Only connects to the hardcoded server
        print("QUEICO")
    end

    if key == "escape" then
        love.event.quit()
    end

    --game.keypressed(key)
end

function love.mousepressed(x, y, button)
    --game.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
    --game.mousereleased(x, y, button)
end

function love.update(dt)
    Server.update()
    Client.update(dt)

    --game.update(dt)
end

function love.draw()
    Client.draw()
    --game.draw()
end
