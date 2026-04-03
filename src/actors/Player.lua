-- MODULE DEPENDENCIES
local constants = require("src.core.constants")
local map = require("src.world.map")
local nature = require("src.objects.nature")
local Recipes = require("src.items.recipes")
local Inventory = require("src.actors.Inventory")
local items = require("src.items.items")
local util = require("src.util.util")

-- MODULE
local Player = {}

-- LOCAL CONSTANTS
local ANIMATION_FRAME_WIDTH = 32
local ANIMATION_FRAME_HEIGHT = 32

local ROW_IDLE = 1
local ROW_WALK_1 = 2
local ROW_WALK_2 = 3

local ANIMATION_DIRECTION_COLUMNS = {
    UP = 1,
    RIGHT = 2,
    DOWN = 3,
    LEFT = 4
}

-- HELPERS

local function buildAnimations(spritesheet)
    return {
        idle = {
            up = { util.makeQuad(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.UP, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) },
            right = { util.makeQuad(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.RIGHT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) },
            down = { util.makeQuad(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.DOWN, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) },
            left = { util.makeQuad(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.LEFT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) }
        },
        walk = {
            up = {
                util.makeQuad(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.UP, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuad(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.UP, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            },
            right = {
                util.makeQuad(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.RIGHT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuad(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.RIGHT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            },
            down = {
                util.makeQuad(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.DOWN, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuad(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.DOWN, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            },
            left = {
                util.makeQuad(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.LEFT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuad(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.LEFT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            }
        }
    }
end

-- CONSTRUCTOR
function Player.new()
    local spritesheet = love.graphics.newImage("assets/images/actors/orcSpritesheet.png")

    -- TABLE INSTANCE
    local player = {
        position = {
            x = 4,
            y = 4
        },
        speed = 4,
        targetPosition = {
            x = 4,
            y = 4
        },
        moving = false,
        direction = constants.DIRECTIONS.DOWN,
        spritesheet = spritesheet,
        animationFrame = 1,
        animationTimer = 0,
        animationSpeed = 0.2,
        animationsQuads = buildAnimations(spritesheet),
        branches = 0,
        stones = 0,
        inventory = Inventory.new(5)
    }

    -- METHODS
    function player:getCurrentQuad()
        local state = self.moving and "walk" or "idle"
        local frames = self.animationsQuads[state][self.direction]
        return frames[self.animationFrame]
    end

    function player:tryMove(x, y, direction)
        self.direction = direction
        if map.movableTile(x, y) then
            self.targetPosition.x = x
            self.targetPosition.y = y
            self.moving = true
        end
    end

    function player:handleInput()
        if love.keyboard.isDown("lctrl") 
            and (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
            self.direction = constants.DIRECTIONS.UP
        elseif love.keyboard.isDown("lctrl") 
            and (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then
            self.direction = constants.DIRECTIONS.LEFT
        elseif love.keyboard.isDown("lctrl") 
            and (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
            self.direction = constants.DIRECTIONS.DOWN
        elseif love.keyboard.isDown("lctrl") 
            and (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
            self.direction = constants.DIRECTIONS.RIGHT
        -------------------
        elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            self:tryMove(self.position.x, self.position.y - 1, constants.DIRECTIONS.UP)
        elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            self:tryMove(self.position.x - 1, self.position.y, constants.DIRECTIONS.LEFT)
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            self:tryMove(self.position.x, self.position.y + 1, constants.DIRECTIONS.DOWN)
        elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            self:tryMove(self.position.x + 1, self.position.y, constants.DIRECTIONS.RIGHT)
        end
    end

    function player:update(dt)
        if not self.moving then
            self:handleInput()
        end

        if self.moving then
            self.animationTimer = self.animationTimer + dt

            if self.animationTimer >= self.animationSpeed then
                self.animationTimer = 0
                self.animationFrame = self.animationFrame + 1

                if self.animationFrame > 2 then
                    self.animationFrame = 1
                end
            end

            local move = self.speed * dt

            if self.direction == constants.DIRECTIONS.UP then
                self.position.y = math.max(self.position.y - move, self.targetPosition.y)
            elseif self.direction == constants.DIRECTIONS.LEFT then
                self.position.x = math.max(self.position.x - move, self.targetPosition.x)
            elseif self.direction == constants.DIRECTIONS.DOWN then
                self.position.y = math.min(self.position.y + move, self.targetPosition.y)
            elseif self.direction == constants.DIRECTIONS.RIGHT then
                self.position.x = math.min(self.position.x + move, self.targetPosition.x)
            end

            if self.position.x == self.targetPosition.x and self.position.y == self.targetPosition.y then
                self.moving = false
                self.animationFrame = 1
                self.animationTimer = 0
                self:handleInput()
            end
        end
    end

    function player:lookingAt()
        if self.direction == constants.DIRECTIONS.UP then
            return { x = self.position.x, y = self.position.y - 1}
        elseif self.direction == constants.DIRECTIONS.RIGHT then
            return { x = self.position.x + 1, y = self.position.y}
        elseif self.direction == constants.DIRECTIONS.DOWN then
            return { x = self.position.x, y = self.position.y + 1}
        elseif self.direction == constants.DIRECTIONS.LEFT then
            return { x = self.position.x - 1, y = self.position.y}
        end
    end

    function player:handleKeyPressed(key)
        if key == "c" then
            local success = self:craftItem(Recipes.axe)

            if success then
                print("axe crafted")
            else
                print("no items")
            end
        elseif key == "space" then
            if not self.moving then
                --TODO looking at return the upper object ID
                local lookingAt = self:lookingAt()
                if map.hasTreeAt(lookingAt.x, lookingAt.y) then
                    map.removeTreeAt(lookingAt.x, lookingAt.y)
                elseif map.hasTileAt(nature.tiles.BRANCH, lookingAt.x, lookingAt.y) then
                    map.removeTileAt(lookingAt.x, lookingAt.y)
                    player.branches = player.branches + 1
                elseif map.hasAt(nature.tiles.STONE, lookingAt.x, lookingAt.y) then
                    if self.inventory:hasFreeSlots(1) then
                        map.removeAt(nature.tiles.STONE, lookingAt.x, lookingAt.y)
                        player.stones = player.stones + 1

                        self.inventory:addItem({
                            id = items.stone.id,
                            qnt = 1
                        })
                    end
                end
            end
        end
    end

    function player:draw()
        love.graphics.draw(
            self.spritesheet,
            self:getCurrentQuad(),
            (self.position.x-1) * constants.TILE_SIZE,
            (self.position.y-1) * constants.TILE_SIZE
        )

        love.graphics.print("Branches: " .. player.branches .. " | Stones: " .. player.stones)

        self.inventory:draw()
    end

    function player:craftItem(recipe)
        if not self.inventory:hasItems(recipe.ingredients) then
            return false
        end
        if not self.inventory:hasFreeSlots(recipe.rewards) then
            return false
        end

        self.inventory:deleteItems(recipe.ingredients)
        self.inventory:addItems(recipe.results)

        return true
    end


    return player
end

return Player