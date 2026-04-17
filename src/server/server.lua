local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local World = require("src.server.World")
local Entities = require("src.entities.entities")
local Player = require("src.shared.Player")
local constants = require("src.core.constants")
local protocol = require("src.shared.protocol")

local Server = {
    status = "off"
}


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

function Server.pollNetwork()
    local event = Server.host:service(0)
    while event do
        if event.type == "connect" then
            print(event.peer, "connected.")
            table.insert(peers, event.peer)

            player = Player.new()
            player.lastProcessedInputSequence = 0
            Entities.new(player)

            local packet = {
                type = protocol.INITIAL,
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
            local serializedData = event.data
            local ok, packet = serpent.load(serializedData)

            if ok and packet.type == protocol.INPUT then
                if player then
                    player.lastestInputState = packet.input
                    player.lastInputTime = love.timer.getTime()
                    player.lastProcessedInputSequence = packet.sequence
                end
            end
        end

        event = Server.host:service(0)
    end
end

function Server.sendPlayerUpdate(player, peer)
    local packet = {
        type = protocol.UPDATE,
        player = {
            id = player.id,
            hp = player.hp,
            position = player.position,
            targetPosition = player.targetPosition,
            desiredDirection = player.desiredDirection,
            direction = player.direction,
            moving = player.moving
        },
        lastProcessedInputSequence = player.lastProcessedInputSequence
    }

    --SERPENT   
    local serializedString = serpent.dump(packet)
    peer:send(serializedString)
end

function Server.updatePlayers(dt)
    if player and player.lastestInputState then
        player.desiredDirection = Player.getDirectionFromInput(player.lastestInputState, true, player.lastInputTime)

        player:update(dt, function ()
            Server.sendPlayerUpdate(player, peers[1])
        end)
    end
end

function Server.update(dt)
    if Server.online() then
        Server.pollNetwork()

        Server.updatePlayers(dt)
    end
end

return Server