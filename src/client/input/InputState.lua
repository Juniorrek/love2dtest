local LastInputState = {
    up = false,
    down = false,
    left = false,
    right = false
}

local InputState = {
    up = false,
    down = false,
    left = false,
    right = false
}

function InputState:hasChanged()
    local result = self.up ~= LastInputState.up or
           self.down ~= LastInputState.down or
           self.left ~= LastInputState.left or
           self.right ~= LastInputState.right

    if result then
        LastInputState.up = self.up
        LastInputState.down = self.down
        LastInputState.left = self.left
        LastInputState.right = self.right
    end

    return result
end

function InputState:update()
    self.up = love.keyboard.isDown("up") or love.keyboard.isDown("w")
    self.down = love.keyboard.isDown("down") or love.keyboard.isDown("s")
    self.left = love.keyboard.isDown("left") or love.keyboard.isDown("a")
    self.right = love.keyboard.isDown("right") or love.keyboard.isDown("d")
end

return InputState