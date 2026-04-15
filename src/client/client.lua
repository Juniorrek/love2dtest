local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local Player = require("src.shared.Player")
local camera = require("src.client.camera")
local MapDefinition = require("src.client.map.MapDefinition")
local WorldState = require("src.shared.WorldState")
local MapRenderer = require("src.client.map.MapRenderer")
local constants = require("src.core.constants")
local InputState = require("src.client.input.InputState")

local Client = {
    player = {}
}

function Client.connect()
    if not Client.connected() then
        Client.host = enet.host_create()
        Client.peer = Client.host:connect("localhost:6789")

        MapDefinition.load()

        Client.inputState = InputState

        --Client.player = Player.new()
        --Client.camera = camera
    end
end

function Client.connected()
    return Client.peer
end

function Client.sendInput(input)
    local packet = {
        type = "input",
        input = input,
        playerId = Client.player.id
    }

    --SERPENT   
    local serializedString = serpent.dump(packet)
    Client.peer:send(serializedString)
end

local timer = 0
function Client.update(dt)
    if Client.connected() then
        local event = Client.host:service(100)
        timer = timer + dt

        if timer > 2 then
            Client.peer:send("Hi")
            timer = 0
        end

        --Messages from server
        if event then
            if event.type == "receive" then
                local serializedData = event.data

                local ok, packet = serpent.load(serializedData)

                if ok and packet.type == "initial" then
                    Client.worldState = WorldState.getFromMapData(packet.map)
                    Client.player = Player.new() -- Refactor so server create in a way and the client just instantiates it with the data and have the functions like draw.
                    Client.player.id = packet.player.id
                    Client.player.hp = packet.player.hp
                    Client.player.position = packet.player.position
                elseif ok and packet.type == "update" then
                    Client.player.id = packet.player.id
                    Client.player.hp = packet.player.hp
                    Client.player.position = packet.player.position
                end
            end
        end

        --Client.camera.update(Client.player)

        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            Client.sendInput({direction = constants.DIRECTIONS.UP})
        elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            Client.sendInput({direction = constants.DIRECTIONS.LEFT})
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            Client.sendInput({direction = constants.DIRECTIONS.DOWN})
        elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            Client.sendInput({direction = constants.DIRECTIONS.RIGHT})
        end

        Client.inputState:update()
        
        if Client.inputState:hasChanged() then
            print("Input changed on client.")
        end
    end
end

function Client.draw()
    if Client.worldState then
        MapRenderer.drawGround(Client.worldState)--, Client.camera)
    end

    if Client.player.position then
        Client.player:draw()
    end
end

return Client