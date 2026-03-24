local constants = require("src.core.constants")
local map = require("src.world.map")

local player = {}

local function new_quad(spritesheet, row, column)
    return love.graphics.newQuad(1 + (column - 1) * player.ANIMATION_FRAME_WIDTH + (column - 1) * 1
                        , 1 + (row - 1) * player.ANIMATION_FRAME_HEIGHT + (row - 1) * 1
                        , player.ANIMATION_FRAME_WIDTH
                        , player.ANIMATION_FRAME_HEIGHT
                        , spritesheet:getDimensions())
end

local function current_quad()
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

function move(x, y, direction)
    if map.movable_tile(x, y) then
        player.target_position.x = x
        player.target_position.y = y
        player.direction = direction
        player.moving = true
    end
end

function handle_player_input()
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        move(player.position.x, player.position.y - 1, constants.DIRECTIONS.UP)
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        move(player.position.x - 1, player.position.y, constants.DIRECTIONS.LEFT)
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        move(player.position.x, player.position.y + 1, constants.DIRECTIONS.DOWN)
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        move(player.position.x + 1, player.position.y, constants.DIRECTIONS.RIGHT)
    end
end

function player.update(dt)
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

        if player.direction == constants.DIRECTIONS.UP then
            player.position.y = math.max(player.position.y - move, player.target_position.y)
        elseif player.direction == constants.DIRECTIONS.LEFT then
            player.position.x = math.max(player.position.x - move, player.target_position.x)
        elseif player.direction == constants.DIRECTIONS.DOWN then
            player.position.y = math.min(player.position.y + move, player.target_position.y)
        elseif player.direction == constants.DIRECTIONS.RIGHT then
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

function player.draw()
    love.graphics.draw(player.spritesheet, current_quad(), player.position.x * constants.TILESIZE, player.position.y * constants.TILESIZE)
end

player.ANIMATION_FRAME_WIDTH = 32
player.ANIMATION_FRAME_HEIGHT = 32
player.ROW_IDLE = 1
player.ROW_WALK_1 = 2
player.ROW_WALK_2 = 3
player.ANIMATION_DIRECTION_COLUMNS = {
    UP = 1,
    RIGHT = 2,
    DOWN = 3,
    LEFT = 4
}


player_spritesheet = love.graphics.newImage("assets/images/actors/orc_spritesheet.png")
player.position = {
    x = 10,
    y = 10
}
player.speed = 3
player.target_position = {}
player.moving = false
player.direction = constants.DIRECTIONS.DOWN
player.spritesheet = player_spritesheet
player.animation_frame = 1
player.animation_timer = 0
player.animation_speed = 0.2
player.animations_quads = {
    idle = {
        up = {new_quad(player_spritesheet, player.ROW_IDLE, player.ANIMATION_DIRECTION_COLUMNS.UP)},
        right = {new_quad(player_spritesheet, player.ROW_IDLE, player.ANIMATION_DIRECTION_COLUMNS.RIGHT)},
        down = {new_quad(player_spritesheet, player.ROW_IDLE, player.ANIMATION_DIRECTION_COLUMNS.DOWN)},
        left = {new_quad(player_spritesheet, player.ROW_IDLE, player.ANIMATION_DIRECTION_COLUMNS.LEFT)}
    },
    walk = {
        up = {
            new_quad(player_spritesheet, player.ROW_WALK_1, player.ANIMATION_DIRECTION_COLUMNS.UP),
            new_quad(player_spritesheet, player.ROW_WALK_2, player.ANIMATION_DIRECTION_COLUMNS.UP),
        },
        right = {
            new_quad(player_spritesheet, player.ROW_WALK_1, player.ANIMATION_DIRECTION_COLUMNS.RIGHT),
            new_quad(player_spritesheet, player.ROW_WALK_2, player.ANIMATION_DIRECTION_COLUMNS.RIGHT),
        },
        down = {
            new_quad(player_spritesheet, player.ROW_WALK_1, player.ANIMATION_DIRECTION_COLUMNS.DOWN),
            new_quad(player_spritesheet, player.ROW_WALK_2, player.ANIMATION_DIRECTION_COLUMNS.DOWN),
        },
        left = {
            new_quad(player_spritesheet, player.ROW_WALK_1, player.ANIMATION_DIRECTION_COLUMNS.LEFT),
            new_quad(player_spritesheet, player.ROW_WALK_2, player.ANIMATION_DIRECTION_COLUMNS.LEFT),
        },
    }
}

return player