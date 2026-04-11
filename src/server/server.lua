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

                if not Server.map.isLoaded() then
                    Server.map.load()
                end

                --SERPENT   
                local serializedString = serpent.dump(map.tilemap.layers["Ground"].data)
                event.peer:send(serializedString)

                --BITSER   
            elseif event.type == "receive" then
                print("Received message: ", event.data, event.peer)
            end
        end

        --event = Server.host:service()
    end
end

return Server