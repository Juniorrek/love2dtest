local WorldState = {}

local function getLayerGidData(layerData)
    local uidData = {}

    for y, row in pairs(layerData) do
        for x, tile in pairs(row) do
            if tile then
                if not uidData[y] then
                    uidData[y] = {}
                end
                uidData[y][x] = tile.gid
            end
        end
    end

    return uidData
end

function WorldState.getFromTilemap(tilemap)
    local state = {
        width = tilemap.width,
        height = tilemap.height,
        layers = {
            ground = getLayerGidData(tilemap.layers["Ground"].data),
            nature = getLayerGidData(tilemap.layers["Nature.Nature"].data)
        }
    }
    return state
end

function WorldState.getFromMapData(mapData)
    return {
        width = mapData.width,
        height = mapData.height,
        layers = {
            ground = mapData.layers.ground,
            nature = mapData.layers.nature
        }
    }
end

function WorldState.setLayers(layers)
    WorldState.layers = layers
end

return WorldState