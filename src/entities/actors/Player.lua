-- MODULE DEPENDENCIES
local constants = require("src.core.constants")
local map = require("src.world.map")
local Inventory = require("src.entities.actors.Inventory")
local items = require("src.items.items")
local util = require("src.util.util")
local Equipment = require("src.entities.actors.Equipment")
local sfx = require("src.sound.sfx")
local Entities = require("src.entities.entities")
local BattleList = require("src.entities.actors.BattleList")

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
            up = { util.makeQuadWithBorder(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.UP, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) },
            right = { util.makeQuadWithBorder(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.RIGHT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) },
            down = { util.makeQuadWithBorder(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.DOWN, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) },
            left = { util.makeQuadWithBorder(spritesheet, ROW_IDLE, ANIMATION_DIRECTION_COLUMNS.LEFT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT) }
        },
        walk = {
            up = {
                util.makeQuadWithBorder(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.UP, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuadWithBorder(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.UP, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            },
            right = {
                util.makeQuadWithBorder(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.RIGHT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuadWithBorder(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.RIGHT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            },
            down = {
                util.makeQuadWithBorder(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.DOWN, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuadWithBorder(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.DOWN, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            },
            left = {
                util.makeQuadWithBorder(spritesheet, ROW_WALK_1, ANIMATION_DIRECTION_COLUMNS.LEFT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT),
                util.makeQuadWithBorder(spritesheet, ROW_WALK_2, ANIMATION_DIRECTION_COLUMNS.LEFT, ANIMATION_FRAME_WIDTH, ANIMATION_FRAME_HEIGHT)
            }
        }
    }
end

-- CONSTRUCTOR
function Player.new()
    local spritesheet = love.graphics.newImage("assets/images/actors/orcSpritesheet.png")

    -- TABLE INSTANCE
    local player = {
        hp = 100,
        position = {
            draw = {
                x = (4-1) * constants.TILE_SIZE,
                y = (4-1) * constants.TILE_SIZE
            },
            grid = {
                x = 4,
                y = 4
            }
        },
        speed = 4,
        targetPosition = {
            grid = {
                x = 4,
                y = 4
            }
        },
        moving = false,
        direction = constants.DIRECTIONS.DOWN,
        desiredDirection = nil,
        spritesheet = spritesheet,
        animationFrame = 1,
        animationTimer = 0,
        animationSpeed = 0.2,
        animationsQuads = buildAnimations(spritesheet),
        inventory = Inventory.new(5),
        equipment = Equipment.new(),
        attack = {
            target = nil,
            damage = 5,
            speed = 2,
            cooldown = 2,
            timer = 0
        },
        battleList = BattleList.new()
    }

    -- METHODS
    function player:target(entity)
        self.attack.target = entity
    end

    function player:targetNextCreatureInBattleList()
        local nextTarget = self.battleList:getNext()
        if nextTarget then
            self:target(nextTarget)
        end
    end

    function player:takeDamage(damage)
        self.hp = self.hp - damage
        print("AAAAAAAA")
    end

    function player:equipItem(slotClicked)
        if self.equipment:canEquip(self.inventory.slots[slotClicked].id) then
            self.equipment:equip(self.inventory.slots[slotClicked])
            self.inventory:deleteItemFromSlot(slotClicked)
        end
    end


    function player:getCurrentQuad()
        local state = self.moving and "walk" or "idle"
        local frames = self.animationsQuads[state][self.direction]
        return frames[self.animationFrame]
    end

    function player:tryMove(x, y, direction)
        self.direction = direction
        if map.movableTile(x, y) and Entities.isFreeAt(x, y) then
            Entities.reserveTile(self, x, y)
            self.moving = true
        else 
            -- self.position.grid.x = self.targetPosition.grid.x
            -- self.position.grid.y = self.targetPosition.grid.y

            self.moving = false
            self.animationFrame = 1
            self.animationTimer = 0
        end
    end

    function player:moveFromDesiredDirection()
        if self.desiredDirection == constants.DIRECTIONS.UP then
            self:tryMove(self.position.grid.x, self.position.grid.y - 1, constants.DIRECTIONS.UP)
        elseif self.desiredDirection == constants.DIRECTIONS.LEFT then
            self:tryMove(self.position.grid.x - 1, self.position.grid.y, constants.DIRECTIONS.LEFT)
        elseif self.desiredDirection == constants.DIRECTIONS.DOWN then
            self:tryMove(self.position.grid.x, self.position.grid.y + 1, constants.DIRECTIONS.DOWN)
        elseif self.desiredDirection == constants.DIRECTIONS.RIGHT then
            self:tryMove(self.position.grid.x + 1, self.position.grid.y, constants.DIRECTIONS.RIGHT)
        end
    end

    function player:update(dt, camera)
        self.battleList:update(camera)

        if not self.moving and self.desiredDirection then
            self:moveFromDesiredDirection()
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

            local move = self.speed * dt * constants.TILE_SIZE
            local targetDrawX = (self.targetPosition.grid.x-1) * constants.TILE_SIZE
            local targetDrawY = (self.targetPosition.grid.y-1) * constants.TILE_SIZE

            if self.direction == constants.DIRECTIONS.UP then
                self.position.draw.y = math.max(self.position.draw.y - move, targetDrawY)
            elseif self.direction == constants.DIRECTIONS.LEFT then
                self.position.draw.x = math.max(self.position.draw.x - move, targetDrawX)
            elseif self.direction == constants.DIRECTIONS.DOWN then
                self.position.draw.y = math.min(self.position.draw.y + move, targetDrawY)
            elseif self.direction == constants.DIRECTIONS.RIGHT then
                self.position.draw.x = math.min(self.position.draw.x + move, targetDrawX)
            end

            if self.position.draw.x == targetDrawX and self.position.draw.y == targetDrawY then
                Entities.commitMove(self)
                if not self.desiredDirection then

                    self.moving = false
                    self.animationFrame = 1
                    self.animationTimer = 0
                else
                    self:moveFromDesiredDirection()
                end
            end
        end

        if self.attack.target then
            if player:touchingTarget() then
                print("BAAAAM")
                --self:aggroPlayer(self.attack.target)
            else
                --self.attack.target = nil
            end
        end
    end

    function player:touchingTarget()
        if not self.attack.target then
            return false
        end

        local dx = self.attack.target.position.grid.x - self.position.grid.x
        local dy = self.attack.target.position.grid.y - self.position.grid.y

        if math.abs(dx) <= 1 and math.abs(dy) <= 1 then
            return true
        end
        return false
    end

    function player:lookingAt()
        if self.direction == constants.DIRECTIONS.UP then
            return { x = self.position.grid.x, y = self.position.grid.y - 1}
        elseif self.direction == constants.DIRECTIONS.RIGHT then
            return { x = self.position.grid.x + 1, y = self.position.grid.y}
        elseif self.direction == constants.DIRECTIONS.DOWN then
            return { x = self.position.grid.x, y = self.position.grid.y + 1}
        elseif self.direction == constants.DIRECTIONS.LEFT then
            return { x = self.position.grid.x - 1, y = self.position.grid.y}
        end
    end

    function player:interact(x, y)
        local type = map.interact(x, y)

        if type == "stone" then
            if self.inventory:hasFreeSlots(1) then
                map.removeObjectAt(x, y)

                self.inventory:addItem({
                    id = items.stone.id,
                    qnt = 1
                })

                sfx:playItemSfx("interaction", items.stone.id)
            end
        elseif type == "branch" then
            if self.inventory:hasFreeSlots(1) then
                map.removeTileAt(x, y)

                self.inventory:addItem({
                    id = items.branch.id,
                    qnt = 1
                })

                sfx:playItemSfx("interaction", items.branch.id)
            end
        elseif type == "tree" then
            if self.equipment:isEquiped(items.axe.id) then
                map.removeTreeAt(x, y)
                map.addObjAt({
                    id = items.wood.id,
                    qnt = 1
                }, x, y)

                --sfx:playItemSfx("interaction", items.axe.id)
            end
        end
    end

    function player:clickedOnInventory(x, y)
        return self.inventory:clickedOnInventory(x, y)
    end

    function player:draw()
        love.graphics.draw(
            self.spritesheet,
            self:getCurrentQuad(),
            self.position.draw.x,
            self.position.draw.y
        )

        if self.attack.target then
            player:drawTargetLine()
        end
    end

    function player:drawUi()
        self.inventory:draw()
        self.equipment:draw()

        love.graphics.print("HP: " .. self.hp, 10, 10)

        self.battleList:draw(self.attack.target)
    end

    function player:drawTargetLine()
        if self.attack.target then
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", self.attack.target.position.draw.x, self.attack.target.position.draw.y, constants.TILE_SIZE, constants.TILE_SIZE)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(1)
        end
    end

    function player:craftItem(recipe)
        if not self.inventory:hasItemsFromRecipe(recipe.ingredients) then
            return false
        end
        -- TODO consider the freed space from ingredients
        if not self.inventory:hasFreeSlots(#recipe.rewards) then
            return false
        end

        self.inventory:deleteItemsByRecipe(recipe.ingredients)
        self.inventory:addItems(recipe.rewards)

        return true
    end


    return player
end

return Player