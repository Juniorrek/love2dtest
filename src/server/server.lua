local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local map = require("src.world.map")

local Server = {
    status = "off"
}

function Server.start()
    if not Server.online() then
        Server.host = enet.host_create("localhost:6789")
        Server.status = "on"

        Server.map = map
        if not Server.map.isLoaded() then
            Server.map.load()
        end
        print("Servidor Ligado")
    end
end

function Server.online()
    return Server.status == "on"
end

function Server.update()
    if Server.online() then
        local event = Server.host:service(100)

        if event then
            if event.type == "connect" then
                print(event.peer, "connected.")

                local packet = {
                    type = "map",
                    width = map.tilemap.width,
                    height = map.tilemap.height,
                    map = {
                        layers = {
                            ground = {},
                            nature = {}
                        }
                    }
                }

                local groundData = map.tilemap.layers["Ground"].data
                local natureData = map.tilemap.layers["Nature.Nature"].data
                for y = 1, map.tilemap.height do
                    for x = 1, map.tilemap.width do
                        if groundData[y] and groundData[y][x] then
                            if not packet.map.layers.ground[y] then
                                packet.map.layers.ground[y] = {}
                            end
                            packet.map.layers.ground[y][x] = groundData[y][x].gid
                        end

                        if natureData[y] and natureData[y][x] then
                            if not packet.map.layers.nature[y] then
                                packet.map.layers.nature[y] = {}
                            end
                            packet.map.layers.nature[y][x] = natureData[y][x].gid
                        end
                    end
                end

                --SERPENT   
                local serializedString = serpent.dump(packet)
                event.peer:send(serializedString)

                --[[ 
                {
                    type = "map",
                    width = map.tilemap.width,
                    height = map.tilemap.height,
                    ground = {
                        {1, 1, 1, 1},
                        {1, 2, 2, 1},
                        {1, 1, 1, 1},
                    }
                }
                ]]
            elseif event.type == "receive" then
                print("Received message: ", event.data, event.peer)
            end
        end

        --event = Server.host:service()
    end
end

return Server