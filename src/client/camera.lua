local conf = require("conf")
local constants = require("src.core.constants")
local WorldState = require("src.shared.WorldState")

local camera = {
    x = 0,
    y = 0,
    w = conf.WINDOW_WIDTH,
    h = conf.WINDOW_HEIGHT,
    startX = 0,
    startY = 0 ,
    endX = 0,
    endY = 0
}

function camera.update(player)
    camera.x = player.position.draw.x + 16 - conf.WINDOW_WIDTH / 2
    if camera.x < 0 then
        camera.x = 0
    elseif camera.x > WorldState.width * constants.TILE_SIZE - conf.WINDOW_WIDTH then
        camera.x = WorldState.width * constants.TILE_SIZE - conf.WINDOW_WIDTH
    end

    camera.y = player.position.draw.y + 16 - conf.WINDOW_HEIGHT / 2
    if camera.y < 0 then
        camera.y = 0
    elseif camera.y > WorldState.height * constants.TILE_SIZE - conf.WINDOW_HEIGHT then
        camera.y = WorldState.height * constants.TILE_SIZE - conf.WINDOW_HEIGHT
    end

    camera.startX = math.floor(camera.x / constants.TILE_SIZE) + 1
    camera.startY = math.floor(camera.y / constants.TILE_SIZE) + 1
    camera.endX = math.ceil((camera.x + camera.w) / constants.TILE_SIZE)
    camera.endY = math.ceil((camera.y + camera.h) / constants.TILE_SIZE)
    --camera.endX = math.floor((camera.x + camera.w - 1) / constants.TILE_SIZE) + 1
    --camera.endY = math.floor((camera.y + camera.h - 1) / constants.TILE_SIZE) + 1
end

return camera