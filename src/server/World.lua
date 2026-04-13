local sti = require("libraries.sti")

local WorldState = require("src.shared.WorldState")

local World = {}

function World.load()
    World.tilemap = sti("assets/map.lua")
    World.state = WorldState.getFromTilemap(World.tilemap)
end

return World