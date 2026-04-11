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
                    ground = {}
                }

                for y, row in ipairs(map.tilemap.layers["Ground"].data) do
                    for x, tile in ipairs(row) do
                        if tile then
                            if not packet.ground[y] then
                                packet.ground[y] = {}
                            end

                            packet.ground[y][x] = tile.gid
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