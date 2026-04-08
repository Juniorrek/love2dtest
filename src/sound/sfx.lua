local items = require("src.items.items")
local conf = require("conf")

local sfx = {}

function sfx:playItemSfx(soundType, itemId)
    if conf.sfx == "on" and items[itemId].sound and items[itemId].sound[soundType] then
        love.audio.stop(items[itemId].sound[soundType])
        love.audio.play(items[itemId].sound[soundType])
    end
end

return sfx