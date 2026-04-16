local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local World = require("src.server.World")
local Entities = require("src.entities.entities")
local Player = require("src.shared.Player")
local constants = require("src.core.constants")

local Server = {
    status = "off"
}


local function getDirectionFromInput(inputState)
    if inputState.up then
        return constants.DIRECTIONS.UP
    elseif inputState.left then
        return constants.DIRECTIONS.LEFT
    elseif inputState.down then
        return constants.DIRECTIONS.DOWN
    elseif inputState.right then
        return constants.DIRECTIONS.RIGHT
    end

    return nil
end
local function hasFreshInput(player)
    local now = love.timer.getTime()
    return (now - player.lastInputTime) < 0.25
end


function Server.start()
    if not Server.online() then
        Server.host = enet.host_create("localhost:6789")
        Server.status = "on"

        World.load()
        print("Servidor Ligado")
    end
end

function Server.online()
    return Server.status == "on"
end

local player = nil
local peers = {}

function Server.update(dt)
    if Server.online() then
        local event = Server.host:service(100)

        if event then
            if event.type == "connect" then
                print(event.peer, "connected.")
                table.insert(peers, event.peer)

                player = Player.new()
                Entities.new(player)

                local packet = {
                    type = "initial",
                    map = {
                        width = World.state.width,
                        height = World.state.height,
                        layers = {
                            ground = World.state.layers.ground,
                            nature = World.state.layers.nature
                        },

                    },
                    player = {
                        id = player.id,
                        hp = player.hp,
                        position = player.position
                    }
                }

                --SERPENT   
                local serializedString = serpent.dump(packet)
                event.peer:send(serializedString)
            elseif event.type == "receive" then
                --print("Received message: ", event.data, event.peer)
                
                local serializedData = event.data
                local ok, packet = serpent.load(serializedData)

                if ok and packet.type == "input" then
                    --print("Received input: ", packet.input.direction)
                    player.inputState = packet.input
                    player.lastInputTime = love.timer.getTime()

                    player.desiredDirection = nil
                    if packet.input.up then
                        player.desiredDirection = constants.DIRECTIONS.UP
                    elseif packet.input.left then
                        player.desiredDirection = constants.DIRECTIONS.LEFT
                    elseif packet.input.down then
                        player.desiredDirection = constants.DIRECTIONS.DOWN
                    elseif packet.input.right then
                        player.desiredDirection = constants.DIRECTIONS.RIGHT
                    end

                    --[[ local packet = {
                        type = "update",
                        player = {
                            id = player.id,
                            hp = player.hp,
                            position = player.position,
                            desiredDirection = player.desiredDirection
                        }
                    }

                    --SERPENT   
                    local serializedString = serpent.dump(packet)
                    peers[1]:send(serializedString) ]]
                end
            end
        end

        if player then
            player:update(dt, function() 
                local nextDirection = nil

                if hasFreshInput(player) then
                    nextDirection = getDirectionFromInput(player.inputState)
                end

                if nextDirection then
                    --player:startMove(nextDirection)
                    --print("Continuing")
                    player.desiredDirection = nextDirection
                else
                    --print("Stoping")
                    --player:stopMove()
                    player.desiredDirection = nil
                    local packet = {
                        type = "update",
                        player = {
                            id = player.id,
                            hp = player.hp,
                            position = player.position,
                            desiredDirection = player.desiredDirection
                        }
                    }

                    --SERPENT   
                    local serializedString = serpent.dump(packet)
                    peers[1]:send(serializedString)
                end
            end)
        end
    end
end

return Server