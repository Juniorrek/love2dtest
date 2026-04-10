local constants = require("src.core.constants")
local map = require("src.world.map")
local Entities = require("src.entities.entities")
local util = require("src.util.util")

local Creatures = {}

local creatures = {
    bug = require("src.entities.creatures.bug")
}

-- Creature manager and constructor
local creatures_list = {}
local creatures_grid = {}

local uidCounter = 0
local function getUID()
    uidCounter = uidCounter + 1
    return uidCounter
end

function Creatures.new(creatureId, x, y)
    local creature = {
        uid = getUID(),
        id = creatureId,
        name = creatures[creatureId].name,
        hp = creatures[creatureId].hp,
        position = {
            draw = {
                x = (x-1) * constants.TILE_SIZE,
                y = (y-1) * constants.TILE_SIZE
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

    util.setOnGrid(creatures_grid, x, y, creature)

    --[[ function creature:die()
        --remover da grid
        if creatures_grid[self.position.grid.y] then
            creatures_grid[self.position.grid.y][self.position.grid.x] = nil
        end

        --remover da lista
        for k, v in pairs(creatures_list) do
            if v == self then
                table.remove(creatures_list, k)
                break
            end
        end
    end ]]

    function creature:takeDamage(damage)
        self.hp = self.hp - damage
        print("UÉÉÉÉÉÉÉ")
    end

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

            local move = self.speed * dt * constants.TILE_SIZE
            local targetDrawX = (self.targetPosition.grid.x-1) * constants.TILE_SIZE
            local targetDrawY = (self.targetPosition.grid.y-1) * constants.TILE_SIZE

            if self.facing == constants.DIRECTIONS.UP then
                self.position.draw.y = math.max(self.position.draw.y - move, targetDrawY)
            elseif self.facing == constants.DIRECTIONS.LEFT then
                self.position.draw.x = math.max(self.position.draw.x - move, targetDrawX)
            elseif self.facing == constants.DIRECTIONS.DOWN then
                self.position.draw.y = math.min(self.position.draw.y + move, targetDrawY)
            elseif self.facing == constants.DIRECTIONS.RIGHT then
                self.position.draw.x = math.min(self.position.draw.x + move, targetDrawX)
            end

            if self.position.draw.x == targetDrawX and self.position.draw.y == targetDrawY then
                --updates the creatures_grid
                if creatures_grid[self.position.grid.y] then
                    creatures_grid[self.position.grid.y][self.position.grid.x] = nil
                end
                util.setOnGrid(creatures_grid, self.targetPosition.grid.x, self.targetPosition.grid.y, self)

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
            self.position.draw.x,
            self.position.draw.y
        )
    end

    return creature
end

function Creatures.update(dt, player)
    for k, v in ipairs(creatures_list) do
        v:update(dt, player)
    end
end

function Creatures.getClosestTo(x, y, callback)
    for i = x - 5, x + 5 do
        for j = y - 5, y + 5 do
            if creatures_grid[j] and creatures_grid[j][i] then
                local creature = creatures_grid[j][i]
                --local distance = math.abs(creature.position.grid.x - x) + math.abs(creature.position.grid.y - y)
                --if distance < 10 then
                    callback(creature)
                    return
                --end
            end
        end
    end
end

function Creatures.getInCamera(camera)
    local inCamera = {}
     for y = camera.startY, camera.endY do
        for x = camera.startX, camera.endX do
            if creatures_grid[y] and creatures_grid[y][x] then
                local creature = creatures_grid[y][x]
                table.insert(inCamera, creature)
            end
        end
    end
    return inCamera
end

return Creatures