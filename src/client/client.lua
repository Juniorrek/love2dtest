local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local map = require("src.world.map")
local Player = require("src.entities.actors.Player")
local camera = require("src.core.camera")

local Client = {}

function Client.connect()
    if not Client.connected() then
        Client.host = enet.host_create()
        Client.peer = Client.host:connect("localhost:6789")

        -- RELOAD THE MAP again in the client side but to use the tiles and tilesets info, not the currect state of the map/data, that I given by the server
        Client.map = map
        if not Client.map.isTilemapLoaded() then
            Client.map.loadTilemap()
        end

        Client.player = Player.new()
        Client.camera = camera
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

                local ok, packet = serpent.load(serializedData)
                print(ok)

                if ok and packet.type == "map" then
                    Client.map.setLayerData("ground", packet.map.layers.ground)
                    Client.map.setLayerData("nature", packet.map.layers.nature)
                end
            end
        end

        Client.camera.update(Client.player)
    end
end

function Client.draw()
    if Client.map and Client.map.layers and Client.map.layers.ground then
        Client.map.drawGround(Client.camera)
    end
end

return Client