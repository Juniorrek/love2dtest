local util = {}

function util.makeQuadWithBorder(spritesheet, row, column, width, height)
    return love.graphics.newQuad(
        1 + (column - 1) * width + (column - 1) * 1,
        1 + (row - 1) * height + (row - 1) * 1,
        width,
        height,
        spritesheet:getDimensions()
    )
end

function util.makeQuad(spritesheet, row, column, width, height)
    return love.graphics.newQuad(
        (column - 1) * width,
        (row - 1) * height,
        width,
        height,
        spritesheet:getDimensions()
    )
end

return util