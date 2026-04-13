local enet = require("enet")
local serpent = require("libraries.serpent.serpent")


local World = require("src.server.World")

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

function Server.update()
    if Server.online() then
        local event = Server.host:service(100)

        if event then
            if event.type == "connect" then
                print(event.peer, "connected.")

                local packet = {
                    type = "map",
                    map = {
                        width = World.state.width,
                        height = World.state.height,
                        layers = {
                            ground = World.state.layers.ground,
                            nature = World.state.layers.nature
                        }
                    }
                }

                --SERPENT   
                local serializedString = serpent.dump(packet)
                event.peer:send(serializedString)
            elseif event.type == "receive" then
                print("Received message: ", event.data, event.peer)
            end
        end
    end
end

return Server