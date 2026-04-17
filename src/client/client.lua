local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local Player = require("src.shared.Player")
local camera = require("src.client.camera")
local MapDefinition = require("src.client.map.MapDefinition")
local WorldState = require("src.shared.WorldState")
local MapRenderer = require("src.client.map.MapRenderer")
local constants = require("src.core.constants")
local InputState = require("src.client.input.InputState")
local protocol = require("src.shared.protocol")

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

local inputSequence = 0
local pendingInputs = {}
function Client.sendInput()
    inputSequence = inputSequence + 1

    local inputSnapshot = {
        up = Client.inputState.up,
        left = Client.inputState.left,
        down = Client.inputState.down,
        right = Client.inputState.right
    }

    local packet = {
        type = protocol.INPUT,
        sequence = inputSequence,
        input = inputSnapshot,
        playerId = Client.player.id
    }

    --SERPENT   
    local serializedString = serpent.dump(packet)
    Client.peer:send(serializedString)

    table.insert(pendingInputs, {
        sequence = inputSequence,
        input = inputSnapshot
    })
end

local reconciledDirectionForThisFrame = nil
function Client.pollNetwork()
    local event = Client.host:service(0)
    --Messages from server
    while event do
        if event.type == "receive" then
            local serializedData = event.data

            local ok, packet = serpent.load(serializedData)

            if ok and packet.type == protocol.INITIAL then
                Client.worldState = WorldState.getFromMapData(packet.map)
                Client.player = Player.new() -- Refactor so server create in a way and the client just instantiates it with the data and have the functions like draw.
                Client.player.id = packet.player.id
                Client.player.hp = packet.player.hp
                Client.player.position = packet.player.position
            elseif ok and packet.type == protocol.UPDATE then
                Client.player.id = packet.player.id
                Client.player.hp = packet.player.hp

                -- DAMMNED RECONCILIATION !!!!!
                Client.player.position.grid.x = packet.player.position.grid.x
                Client.player.position.grid.y = packet.player.position.grid.y
                Client.player.position.draw.x = packet.player.position.draw.x
                Client.player.position.draw.y = packet.player.position.draw.y

                Client.player.targetPosition.grid.x = packet.player.targetPosition.grid.x
                Client.player.targetPosition.grid.y = packet.player.targetPosition.grid.y
                Client.player.desiredDirection = packet.player.desiredDirection
                Client.player.direction = packet.player.direction
                Client.player.moving = packet.player.moving

                local lastProcessedInputSequence = packet.lastProcessedInputSequence
                while #pendingInputs > 0 and pendingInputs[1].sequence <= lastProcessedInputSequence do
                    table.remove(pendingInputs, 1)
                end

                local latestPending = pendingInputs[#pendingInputs]
                if latestPending then
                    reconciledDirectionForThisFrame = Player.getDirectionFromInput(latestPending.input, false)
                else
                    reconciledDirectionForThisFrame = nil
                end
            end
        end

        event = Client.host:service(0)
    end
end

local inputStateTimer = 0
function Client.handleInput(dt)
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

function Client.predictLocalPlayer(dt)
     --Client.camera.update(Client.player)

    if Client.player.id then
        Client.player:update(dt)
        Client.player:updateAnimation(dt)
    end
end

function Client.update(dt)
    if Client.connected() then
        Client.pollNetwork()

        Client.handleInput(dt)

        if Client.player.id then
            if reconciledDirectionForThisFrame ~= nil then
                Client.player.desiredDirection = reconciledDirectionForThisFrame
                reconciledDirectionForThisFrame = nil
            else
                Client.player.desiredDirection = Player.getDirectionFromInput(Client.inputState, false)
            end
        end
        Client.predictLocalPlayer(dt)
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