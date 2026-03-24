if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
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

    ANIMATION_FRAME_WIDTH = 32
    ANIMATION_FRAME_HEIGHT = 32
    ROW_IDLE = 1
    ROW_WALK_1 = 2
    ROW_WALK_2 = 3
    ANIMATION_DIRECTION_COLUMNS = {
        UP = 1,
        RIGHT = 2,
        DOWN = 3,
        LEFT = 4
    }

    --
    -- Graphics
    --
    tree = love.graphics.newImage("tree.png")
    bush = love.graphics.newImage("bush.png")

    love.graphics.setNewFont(12)
    --love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(4, 11, 3)

    --
    -- Audio
    --
    sound = love.audio.newSource("meadow_ambience.ogg", "stream")
    love.audio.play(sound)

    --
    -- Player
    --
    player_spritesheet = love.graphics.newImage("orc_spritesheet.png")
    player = {
        sprite = love.graphics.newImage("orc.png"),
        position = {
            x = 10,
            y = 10
        },
        speed = 3,
        target_position = {},
        moving = false,
        direction = DIRECTIONS.DOWN,
        spritesheet = player_spritesheet,
        animation_frame = 1,
        animation_timer = 0,
        animation_speed = 0.2,
        animations_quads = {
            idle = {
                up = {new_quad(player_spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.UP)},
                right = {new_quad(player_spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.RIGHT)},
                down = {new_quad(player_spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.DOWN)},
                left = {new_quad(player_spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.LEFT)}
            },
            walk = {
                up = {
                    new_quad(player_spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.UP),
                    new_quad(player_spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.UP),
                },
                right = {
                    new_quad(player_spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.RIGHT),
                    new_quad(player_spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.RIGHT),
                },
                down = {
                    new_quad(player_spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.DOWN),
                    new_quad(player_spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.DOWN),
                },
                left = {
                    new_quad(player_spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.LEFT),
                    new_quad(player_spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.LEFT),
                },
            }
        }
    }

    
    --
    -- Map
    --
    tilemap = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 1, 0, 0, 0, 2, 5, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 3, 4, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 4, 3, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    }
end

function new_quad(spritesheet, row, column)
    return love.graphics.newQuad(1 + (column - 1) * ANIMATION_FRAME_WIDTH + (column - 1) * 1
                        , 1 + (row - 1) * ANIMATION_FRAME_HEIGHT + (row - 1) * 1
                        , ANIMATION_FRAME_WIDTH
                        , ANIMATION_FRAME_HEIGHT
                        , spritesheet:getDimensions())
end

function current_quad()
    if player.moving then
        state = 'walk'
    else
        state = 'idle'
    end
    frames = player.animations_quads[state][player.direction]
    ff= frames[player.animation_frame]
    if ff == nil then
        print("trest")
    end
    return ff
end

function movable_tile(x, y)
    return tilemap[y][x] == 0
end

function move(x, y, direction)
    if movable_tile(x, y) then
        player.target_position.x = x
        player.target_position.y = y
        player.direction = direction
        player.moving = true
    end
end

function handle_player_input()
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        move(player.position.x, player.position.y - 1, DIRECTIONS.UP)
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        move(player.position.x - 1, player.position.y, DIRECTIONS.LEFT)
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        move(player.position.x, player.position.y + 1, DIRECTIONS.DOWN)
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        move(player.position.x + 1, player.position.y, DIRECTIONS.RIGHT)
    end
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
        handle_player_input()
    end

    if player.moving then
        player.animation_timer = player.animation_timer + dt
        if player.animation_timer >= player.animation_speed then
            player.animation_timer = 0
            player.animation_frame = player.animation_frame + 1

            if player.animation_frame > 2 then
                player.animation_frame = 1
            end
        end
        ------
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
            player.animation_frame = 1
            player.animation_timer = 0

            handle_player_input()
        end
    end
end

function love.draw()
    --love.graphics.draw(player.sprite, player.position((.x * TILE_SIZE, player.position.y * TILE_SIZE)
    love.graphics.draw(player.spritesheet, current_quad(), player.position.x * TILE_SIZE, player.position.y * TILE_SIZE)

    for i, row in ipairs(tilemap) do
        for j, tile in ipairs(row) do
            if tile ~= 0 then
                if tile == 1 then
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.draw(bush, j * 32, i * 32)
                elseif tile == 2 then
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                elseif tile == 3 then
                    love.graphics.setColor(1, 0, 1)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                elseif tile == 4 then
                    love.graphics.setColor(0, 0, 1)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                elseif tile == 5 then
                    love.graphics.setColor(0, 1, 1)
                    love.graphics.rectangle("fill", j * 32, i * 32, 32, 32)
                end
            else
                love.graphics.setColor(1, 1, 1)
            end
        end
    end
    
    love.graphics.draw(tree, 256, 256)
end
