local conf = require("conf")
local map = require("src.world.map")

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
    elseif camera.x > map.width - conf.WINDOW_WIDTH then
        camera.x = map.width - conf.WINDOW_WIDTH
    end

    camera.y = player.position.draw.y + 16 - conf.WINDOW_HEIGHT / 2
    if camera.y < 0 then
        camera.y = 0
    elseif camera.y > map.height - conf.WINDOW_HEIGHT then
        camera.y = map.height - conf.WINDOW_HEIGHT
    end

    camera.startX = math.floor(camera.x / map.tilemap.tilewidth) + 1
    camera.startY = math.floor(camera.y / map.tilemap.tileheight) + 1
    camera.endX = math.ceil((camera.x + camera.w) / map.tilemap.tilewidth)
    camera.endY = math.ceil((camera.y + camera.h) / map.tilemap.tileheight)
    --camera.endX = math.floor((camera.x + camera.w - 1) / map.tilemap.tilewidth) + 1
    --camera.endY = math.floor((camera.y + camera.h - 1) / map.tilemap.tileheight) + 1
end

return camera