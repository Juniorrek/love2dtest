local constants = require("src.core.constants")
local map = require("src.world.map")
local Entities = require("src.entities.entities")

local Creatures = {}

local creatures = {
    bug = require("src.entities.creatures.bug")
}

-- Creature manager and constructor
local creatures_list = {}

function Creatures.new(creatureId, x, y)
    local creature = {
        id = creatureId,
        position = {
            draw = {
                x = x,
                y = y
            },
            grid = {
                x = x,
                y = y
            }
        },
        targetPosition = {
            grid = {
                x = x,
                y = y
            }
        },
        timers = {
            attack = {
                cooldown = creatures[creatureId].attackCooldown,
                timer = 0,
                speed = creatures[creatureId].attackSpeed
            },
            check = {
                cooldown = 0.5,
                timer = 0
            }
        },
        animationFrame = creatures[creatureId].animationFrame,
        animationTimer = creatures[creatureId].animationTimer,
        animationSpeed = creatures[creatureId].animationSpeed,
        facing = constants.DIRECTIONS.UP,
        state = "idle",
        speed = creatures[creatureId].speed,
        attackDamage = creatures[creatureId].attackDamage
    }

    table.insert(creatures_list, creature)

    function creature:getCurrentQuad()
        local frames = creatures[self.id].animationQuads[self.state][self.facing]
        return frames[self.animationFrame]
    end

    function creature:playerClose(player)
        local dx = player.position.grid.x - self.position.grid.x
        local dy = player.position.grid.y - self.position.grid.y

        if math.abs(dx) <= creatures[self.id].aggroRange 
            and math.abs(dy) <= creatures[self.id].aggroRange then
            return true
        end
        return false
    end

    function creature:touchingPlayer(player)
        local dx = player.position.grid.x - self.position.grid.x
        local dy = player.position.grid.y - self.position.grid.y

        if math.abs(dx) <= 1 and math.abs(dy) <= 1 then
            return true
        end
        return false
    end

    function creature:tryMove(x, y, direction)
        self.facing = direction
        if map.movableTile(x, y) and Entities.isFreeAt(x, y) then
            Entities.reserveTile(self, x, y)
        end
    end

    function creature:aggroPlayer(player)
        local dx = player.position.grid.x - self.position.grid.x
        local dy = player.position.grid.y - self.position.grid.y

        if math.abs(dx) > math.abs(dy) then
            if player.position.grid.x > self.position.grid.x then
                self:tryMove(self.position.grid.x+1, 
                    self.position.grid.y, 
                    constants.DIRECTIONS.RIGHT
                )
            else
                self:tryMove(self.position.grid.x-1, self.position.grid.y, constants.DIRECTIONS.LEFT)
            end
        else
            if player.position.grid.y > self.position.grid.y then
                self:tryMove(self.position.grid.x, self.position.grid.y+1, constants.DIRECTIONS.DOWN)
            else
                self:tryMove(self.position.grid.x, self.position.grid.y-1, constants.DIRECTIONS.UP)
            end
        end
    end

    function creature:attack(dt, player)
        self.timers.check.timer = self.timers.check.timer + dt
        --self.timers.attack.timer = self.timers.attack.timer + dt * self.timers.attack.speed

        if self.timers.check.timer >= self.timers.check.cooldown then
            self.timers.check.timer = 0
            local dx = player.position.grid.x - self.position.grid.x
            local dy = player.position.grid.y - self.position.grid.y

            if player.position.grid.x > self.position.grid.x then
                self.facing = constants.DIRECTIONS.RIGHT
            elseif player.position.grid.x < self.position.grid.x then
                self.facing = constants.DIRECTIONS.LEFT
            elseif player.position.grid.y > self.position.grid.y then
                self.facing = constants.DIRECTIONS.DOWN
            elseif player.position.grid.y < self.position.grid.y then
                self.facing = constants.DIRECTIONS.UP
            end
        end

        if self.timers.attack.timer >= self.timers.attack.cooldown then
            self.timers.attack.timer = 0
            player:takeDamage(self.attackDamage)
        end
    end

    function creature:update(dt, player)
        self.timers.attack.timer = self.timers.attack.timer + dt * self.timers.attack.speed

        if self.timers.attack.timer > self.timers.attack.cooldown then
            self.timers.attack.timer = self.timers.attack.cooldown
        end

        print(self.state)
        if self.state == "idle" then
            if self:playerClose(player) then
                self.state = "chasing"
                self:aggroPlayer(player)
            end
        end

        if self.state == "chasing" then
            self.animationTimer = self.animationTimer + dt

            if self.animationTimer >= self.animationSpeed then
                self.animationTimer = 0
                self.animationFrame = self.animationFrame + 1

                if self.animationFrame > #creatures[self.id].animationQuads[self.state][self.facing] then
                    self.animationFrame = 1
                end
            end

            local move = self.speed * dt

            if self.facing == constants.DIRECTIONS.UP then
                self.position.draw.y = math.max(self.position.draw.y - move, self.targetPosition.grid.y)
            elseif self.facing == constants.DIRECTIONS.LEFT then
                self.position.draw.x = math.max(self.position.draw.x - move, self.targetPosition.grid.x)
            elseif self.facing == constants.DIRECTIONS.DOWN then
                self.position.draw.y = math.min(self.position.draw.y + move, self.targetPosition.grid.y)
            elseif self.facing == constants.DIRECTIONS.RIGHT then
                self.position.draw.x = math.min(self.position.draw.x + move, self.targetPosition.grid.x)
            end

            if self.position.draw.x == self.targetPosition.grid.x and self.position.draw.y == self.targetPosition.grid.y then
                Entities.commitMove(self)

                if self:touchingPlayer(player) then
                    self.state = "attacking"
                    self.animationFrame = 1
                    self.animationTimer = 0
                elseif self:playerClose(player) then
                    self.state = "chasing"
                    self:aggroPlayer(player)
                else
                    self.state = "idle"
                    self.animationFrame = 1
                    self.animationTimer = 0
                end
            end
        end

        if self.state == "attacking" then
            if self:touchingPlayer(player) then
                self:attack(dt, player)
            else
                if self:playerClose(player) then
                    self.state = "chasing"
                    self:aggroPlayer(player)
                else
                    self.state = "idle"
                    self.animationFrame = 1
                    self.animationTimer = 0
                end
            end
        end
    end

    function creature:draw()
        love.graphics.draw(
            creatures[self.id].spritesheet,
            self:getCurrentQuad(),
            (self.position.draw.x-1) * constants.TILE_SIZE,
            (self.position.draw.y-1) * constants.TILE_SIZE
        )
    end

    return creature
end

function Creatures.update(dt, player)
    for k, v in ipairs(creatures_list) do
        v:update(dt, player)
    end
end

--[[ function Creatures.draw()
    for k, v in ipairs(creatures_list) do
        v:draw()
    end
end ]]

return Creatures