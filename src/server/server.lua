local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local World = require("src.server.World")
local Entities = require("src.entities.entities")
local Player = require("src.shared.Player")
local constants = require("src.core.constants")

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

local player
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
                print("Received message: ", event.data, event.peer)
                
                local serializedData = event.data
                local ok, packet = serpent.load(serializedData)

                if ok and packet.type == "input" then
                    print("Received input: ", packet.input.direction)

                    if packet.input.direction == constants.DIRECTIONS.UP then
                        player.position.grid.y = player.position.grid.y - 1
                    elseif packet.input.direction == constants.DIRECTIONS.LEFT then
                        player.position.grid.x = player.position.grid.x - 1
                    elseif packet.input.direction == constants.DIRECTIONS.DOWN then
                        player.position.grid.y = player.position.grid.y + 1
                    elseif packet.input.direction == constants.DIRECTIONS.RIGHT then
                        player.position.grid.x = player.position.grid.x + 1
                    end

                    local packet = {
                        type = "update",
                        player = {
                            id = player.id,
                            hp = player.hp,
                            position = player.position
                        }
                    }

                    --SERPENT   
                    local serializedString = serpent.dump(packet)
                    peers[1]:send(serializedString)
                end
            end
        end
    end
end

return Server