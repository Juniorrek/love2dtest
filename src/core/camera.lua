local conf = require("conf")
local map = require("src.world.map")

local camera = {
    x = 0,
    y = 0,
    w = conf.WINDOW_WIDTH,
    h = conf.WINDOW_HEIGHT
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
end

return camera