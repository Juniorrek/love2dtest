local enet = require("enet")
local serpent = require("libraries.serpent.serpent")
local map = require("src.world.map")

local Client = {}

function Client.connect()
    if not Client.connected() then
        Client.host = enet.host_create()
        Client.peer = Client.host:connect("localhost:6789")
    end
end

function Client.connected()
    return Client.peer
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

                local ok, copy = serpent.load(serializedData)
                print(ok)
                Client.groundData = copy
            end
        end
    end
end

function Client.draw()
    if Client.groundData then
        map.drawGroundByParameter(Client.groundData)
    end
end

return Client