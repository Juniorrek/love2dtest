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

        Client.inputState = InputState.new()
        Client.previousInputState = InputState.new()

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
        input = {
            up = Client.inputState.up,
            left = Client.inputState.left,
            down = Client.inputState.down,
            right = Client.inputState.right
        },
        playerId = Client.player.id
    }

    --SERPENT   
    local serializedString = serpent.dump(packet)
    Client.peer:send(serializedString)
end

local inputStateTimer = 0
function Client.update(dt)
    if Client.connected() then
        local event = Client.host:service(0)

        --Messages from server
        while event do
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

            event = Client.host:service(0)
        end

        --Client.camera.update(Client.player)

        Client.inputState:update()

        local inputChanged = not Client.inputState:equals(Client.previousInputState)
        local hasActiveInput = Client.inputState:hasMovementInput()

        if inputChanged then
            Client.previousInputState:copyFrom(Client.inputState)
            Client.sendInput()
            inputStateTimer = 0
        elseif hasActiveInput then
            inputStateTimer = inputStateTimer + dt
            if inputStateTimer >= 0.1 then
                inputStateTimer = 0
                Client.sendInput()
            end
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


    local fps = love.timer.getFPS()
    love.graphics.print("FPS: " .. tostring(fps), 10, 10)
end

return Client