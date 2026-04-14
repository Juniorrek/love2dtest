local Player = require("src.shared.Player")
local map = require("src.world.map")
local mouse = require("src.core.mouse")
local keyboard = require("src.core.keyboard")
local Creatures = require("src.entities.creatures.creatures")
local Entities = require("src.entities.entities")
local camera = require("src.client.camera")
local conf = require("conf")

local Server = require("src.server.server")
local Client = require("src.client.client")

local game = {}

local player

function game.load()
    --[[ love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(0, 0.7, 1)

    local ambienceSound = love.audio.newSource("assets/audio/music/meadowAmbience.ogg", "stream")
    if conf.sound == "on" then
        love.audio.play(ambienceSound)
    end
    map.load()

    player = Player.new()
    Entities.new(player)

    local bug = Creatures.new("bug", 10, 10)
    Entities.new(bug)
    local bug2 = Creatures.new("bug", 28, 2)
    Entities.new(bug2) ]]
end

function game.keypressed(key)
    -- keyboard.handleKeyPressed(key, player)

    if key == "f1" then -- Starts server and connects to it
        Server.start()
        Client.connect()
    elseif key == "f2" then -- Only connects to the hardcoded server
        print("QUEICO")
    end

    if key == "escape" then
        love.event.quit()
    end
end

function game.mousepressed(x, y, button)
    -- mouse.handleMousePressed(x, y, button, player)
end
function game.mousereleased(x, y, button)
    -- mouse.handleMouseReleased(x, y, button, player)
end

function game.update(dt)
   --[[  keyboard.update(player)
    Entities.update(dt)
    player:update(dt, camera)
    Creatures.update(dt, player)
    camera.update(player) ]]

    Server.update(dt)
    Client.update(dt)
end

function game.draw()
    --[[ love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)

    xx map.drawGround(camera)
    Entities.draw(camera)
    map.drawAbove(camera)

    love.graphics.pop()

    player:drawUi()

    if conf.debug == "on" then
        love.graphics.line(0, conf.WINDOW_HEIGHT/2, conf.WINDOW_WIDTH, conf.WINDOW_HEIGHT/2)
        love.graphics.line(conf.WINDOW_WIDTH/2, 0, conf.WINDOW_WIDTH/2, conf.WINDOW_HEIGHT)
    end ]]

    Client.draw()
end

return game