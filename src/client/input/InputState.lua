local InputState = {}

function InputState.new()
    local inputState = {
        up = false,
        left = false,
        down = false,
        right = false
    }

    function inputState:update()
        --print("a")
        self.up = love.keyboard.isDown("up") or love.keyboard.isDown("w")
        self.down = love.keyboard.isDown("down") or love.keyboard.isDown("s")
        self.left = love.keyboard.isDown("left") or love.keyboard.isDown("a")
        self.right = love.keyboard.isDown("right") or love.keyboard.isDown("d")

       --[[  if  love.keyboard.isDown("up") or love.keyboard.isDown("w") or
            love.keyboard.isDown("down") or love.keyboard.isDown("s") or
            love.keyboard.isDown("left") or love.keyboard.isDown("a") or
            love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            print("a")
        end ]]
    end

    function inputState:copyFrom(otherInputState)
        self.up = otherInputState.up
        self.left = otherInputState.left
        self.down = otherInputState.down
        self.right = otherInputState.right
    end

    function inputState:equals(otherInputState)
        return self.up == otherInputState.up and
                self.left == otherInputState.left and
                self.down == otherInputState.down and
                self.right == otherInputState.right
    end

    return inputState
end

return InputState