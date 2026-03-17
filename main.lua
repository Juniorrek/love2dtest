if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    --
    -- Constants
    --
    TILE_SIZE = 32
    DIRECTIONS = {
        UP = "up",
        DOWN = "down",
        LEFT = "left",
        RIGHT = "right"
    }

    --
    -- Graphics
    --
    tree = love.graphics.newImage("tree.png")

    love.graphics.setNewFont(12)
    --love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(4, 11, 3)

    --
    -- Audio
    --
    sound = love.audio.newSource("meadow_ambience.ogg", "stream")
    love.audio.play(sound)

    --
    -- Gameplay
    --
    player = {
        sprite = love.graphics.newImage("orc.png"),
        position = {
            x = 10,
            y = 10
        },
        speed = 3,
        target_position = {},
        moving = false,
        direction = DIRECTIONS.DOWN
    }
end

--
-- Gameloop
--
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    if not player.moving then
        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            player.target_position.x = player.position.x
            player.target_position.y = player.position.y - 1
            player.direction = DIRECTIONS.UP
            player.moving = true
        elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            player.target_position.x = player.position.x - 1
            player.target_position.y = player.position.y
            player.direction = DIRECTIONS.LEFT
            player.moving = true
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            player.target_position.x = player.position.x
            player.target_position.y = player.position.y + 1
            player.direction = DIRECTIONS.DOWN
            player.moving = true
        elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            player.target_position.x = player.position.x + 1
            player.target_position.y = player.position.y
            player.direction = DIRECTIONS.RIGHT
            player.moving = true
        end
    end

    if player.moving then
        local move = player.speed * dt

        if player.direction == DIRECTIONS.UP then
            player.position.y = math.max(player.position.y - move, player.target_position.y)
        elseif player.direction == DIRECTIONS.LEFT then
            player.position.x = math.max(player.position.x - move, player.target_position.x)
        elseif player.direction == DIRECTIONS.DOWN then
            player.position.y = math.min(player.position.y + move, player.target_position.y)
        elseif player.direction == DIRECTIONS.RIGHT then
            player.position.x = math.min(player.position.x + move, player.target_position.x)
        end

        if player.position.x == player.target_position.x and player.position.y == player.target_position.y then
            player.moving = false
        end
    end
end

function love.draw()
    love.graphics.draw(player.sprite, player.position.x * TILE_SIZE, player.position.y * TILE_SIZE)

    love.graphics.draw(tree, 400, 300)
end
