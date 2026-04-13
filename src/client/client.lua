local enet = require("enet")
local serpent = require("libraries.serpent.serpent")

local Player = require("src.shared.Player")
local camera = require("src.client.camera")
local MapDefinition = require("src.client.map.MapDefinition")
local WorldState = require("src.shared.WorldState")
local MapRenderer = require("src.client.map.MapRenderer")

local Client = {}

function Client.connect()
    if not Client.connected() then
        Client.host = enet.host_create()
        Client.peer = Client.host:connect("localhost:6789")

        MapDefinition.load()

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
                    Client.worldState = WorldState.getFromMapData(packet.map)
                end
            end
        end

        Client.camera.update(Client.player)
    end
end

function Client.draw()
    if Client.worldState then
        MapRenderer.drawGround(Client.worldState.layers, Client.camera)
    end
end

return Client