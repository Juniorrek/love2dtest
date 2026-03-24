local defaults = {
    cols = 16,
    rows = 9,
    margin = 4,
    padding = 3,
    cellWidth = 32,
    cellHeight = 32,
    opacity = 255,
    lockGrid = true,
    collapseGrid = true,
    sizeChecker = 16
}

local dlg = Dialog { title = "Rect Grid" }

dlg:number {
    id = "cellWidth",
    label = "Cell:",
    text = string.format("%d", defaults.cellWidth),
    decimals = 0
}

dlg:number {
    id = "cellHeight",
    text = string.format("%d", defaults.cellHeight),
    decimals = 0
}

dlg:newrow { always = false }

dlg:slider {
    id = "cols",
    label = "Columns:",
    min = 1,
    max = 32,
    value = defaults.cols
}

dlg:newrow { always = false }

dlg:slider {
    id = "rows",
    label = "Rows:",
    min = 1,
    max = 32,
    value = defaults.rows
}

dlg:newrow { always = false }

dlg:slider {
    id = "margin",
    label = "Margin:",
    min = 0,
    max = 32,
    value = defaults.margin
}

dlg:newrow { always = false }

dlg:slider {
    id = "padding",
    label = "Padding:",
    min = 0,
    max = 32,
    value = defaults.padding
}

dlg:newrow { always = false }

dlg:slider {
    id = "sizeChecker",
    label = "Checker:",
    min = 0,
    max = 64,
    value = defaults.sizeChecker,
    onchange = function()
        local args = dlg.data
        local sizeChecker = args.sizeChecker
        local validSize = sizeChecker > 0
        dlg:modify { id ="bChecker", visible = validSize }
    end
}

dlg:newrow { always = false }

dlg:color {
    id = "aChecker",
    label = "Color:",
    color = Color { r = 55, g = 55, b = 55 }
}

dlg:color {
    id = "bChecker",
    color = Color { r = 102, g = 102, b = 102 },
    visible = defaults.sizeChecker > 0
}

dlg:newrow { always = false }

dlg:color {
    id = "bkgClr",
    label = "Background:",
    color = Color { r = 40, g = 40, b = 40, a = 255 }
}

dlg:newrow { always = false }

dlg:slider {
    id = "opacity",
    label = "Opacity:",
    min = 0,
    max = 255,
    value = defaults.opacity
}

dlg:newrow { always = false }

dlg:button {
    id = "confirm",
    text = "&OK",
    onclick = function()
        local args = dlg.data
        local cellWidth = args.cellWidth
            or defaults.cellWidth --[[@as number]]
        local cellHeight = args.cellHeight
            or defaults.cellHeight --[[@as number]]
        local cols = args.cols
            or defaults.cols --[[@as integer]]
        local rows = args.rows
            or defaults.rows --[[@as integer]]
        local margin = args.margin
            or defaults.margin --[[@as integer]]
        local padding = args.padding
            or defaults.padding --[[@as integer]]
        local opacity = args.opacity
            or defaults.opacity --[[@as integer]]
        local sizeChecker = args.sizeChecker
            or defaults.sizeChecker --[[@as integer]]

        local aChecker = args.aChecker --[[@as Color]]
        local bChecker = args.bChecker --[[@as Color]]
        local bkgClr = args.bkgClr --[[@as Color]]

        local cwVrf = math.floor(0.5 + math.abs(cellWidth))
        local chVrf = math.floor(0.5 + math.abs(cellHeight))
        local aHex = aChecker.rgbaPixel
        local bHex = bChecker.rgbaPixel
        local margin2 = margin + margin
        local colsn1 = cols - 1
        local rowsn1 = rows - 1
        local rowToGreen = 255.0 / rowsn1
        local colToRed = 255.0 / colsn1
        local useBkg = bkgClr.alpha > 0

        local spriteWidth = margin2 + cwVrf * cols
            + padding * colsn1
        local spriteHeight = margin2 + chVrf * rows
            + padding * rowsn1
        local activeSprite = Sprite(spriteWidth, spriteHeight)
        local activeLayer = activeSprite.layers[1]
        app.command.LoadPalette { preset = "default" }

        local spriteSpec = activeSprite.spec
        local cellSpec = ImageSpec(spriteSpec)
        cellSpec.width = cwVrf
        cellSpec.height = chVrf
        local cellImage = Image(cellSpec)

        if sizeChecker > 0 then
            local pxItr = cellImage:pixels()
            for pixel in pxItr do
                local hex = bHex
                if (((pixel.x // sizeChecker)
                    + (pixel.y // sizeChecker)) % 2) ~= 1 then
                    hex = aHex
                end
                pixel(hex)
            end
        else
            cellImage:clear(aHex)
        end

        local gridGroup = nil
        app.transaction(function()
            gridGroup = activeSprite:newGroup()
            gridGroup.stackIndex = 1
            gridGroup.name = "Grid"
            gridGroup.isCollapsed = true
            gridGroup.isEditable = false
        end)

        local bkgLayer = nil
        local bkgImg = Image(spriteSpec)
        bkgImg:clear(bkgClr)
        if useBkg then
            app.transaction(function()
                bkgLayer = activeSprite:newLayer()
                bkgLayer.name = "Bkg"
                bkgLayer.parent = gridGroup
                bkgLayer.opacity = opacity
            end)
        end

        ---@type Point[]
        local points = {}

        ---@type Layer[]
        local layers = {}

        local row = -1
        while row < rowsn1 do
            row = row + 1

            local yOffset = margin + row * padding
            local y = row * chVrf + yOffset
            local green = math.floor(row * rowToGreen + 0.5)

            local rowGroup = nil
            app.transaction(function()
                rowGroup = activeSprite:newGroup()
                rowGroup.name = "Row " .. row
                rowGroup.parent = gridGroup
                rowGroup.isCollapsed = true
            end)

            local col = -1
            while col < colsn1 do
                col = col + 1

                local xOffset = margin + col * padding
                local x = col * cwVrf + xOffset
                local red = math.floor(col * colToRed + 0.5)

                local colColor = Color {
                    r = red,
                    g = green,
                    b = 128,
                    a = 128
                }

                local colLayer = nil
                app.transaction(function()
                    colLayer = activeSprite:newLayer()
                    colLayer.name = "Col " .. col
                    colLayer.parent = rowGroup
                    colLayer.color = colColor
                    colLayer.opacity = opacity
                end)

                local flatIdx = col + row * cols
                points[1 + flatIdx] = Point(x, y)
                layers[1 + flatIdx] = colLayer
            end
        end

        local lenFrames = #activeSprite.frames
        local gridFlat = cols * rows

        if useBkg then
            app.transaction(function()
                local h = 0
                while h < lenFrames do
                    h = h + 1
                    activeSprite:newCel(bkgLayer, h, bkgImg)
                end
            end)
        end

        app.transaction(function()
            local i = 0
            while i < gridFlat do
                i = i + 1
                local point = points[i]
                local layer = layers[i]

                local j = 0
                while j < lenFrames do
                    j = j + 1
                    activeSprite:newCel(
                        layer, j, cellImage, point)
                end
            end
        end)

        app.activeLayer = activeLayer
        app.refresh()
    end
}

dlg:button {
    id = "cancel",
    text = "&CANCEL",
    focus = false,
    onclick = function()
        dlg:close()
    end
}

dlg:show { wait = false }