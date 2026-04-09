local keyboard = {}
local Recipes = require("src.items.recipes")
local items = require("src.items.items")
local sfx = require("src.sound.sfx")
local constants = require("src.core.constants")
local map = require("src.world.map")
local Creatures = require("src.entities.creatures.creatures")

function keyboard.handleKeyPressed(key, player)
    if key == "c" then
        local success = player:craftItem(Recipes.axe)
        if success then
            sfx:playItemSfx("craft", items.axe.id)
        end
    elseif key == "f" then
        local success = player:craftItem(Recipes.bonfire)
        if success then
            sfx:playItemSfx("craft", items.bonfire.id)
        end
    elseif key == "g" then
        if not player.moving then
            --TODO looking at return the upper object ID
            local lookingAt = player:lookingAt()

            player:interact(lookingAt.x, lookingAt.y)
        end
    elseif key == "space" then
        --callback ou como feito acima retornando e verificando se é nil ou não
        player:targetNextCreatureInBattleList()
        --[[ Creatures.getClosestTo(player.position.grid.x, player.position.grid.y, function(creature)
            player:target(creature)
        end) ]]
    end
end

function keyboard.update(player)
    player.desiredDirection = nil
    if love.keyboard.isDown("lctrl") 
        and (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
        player.direction = constants.DIRECTIONS.UP
    elseif love.keyboard.isDown("lctrl") 
        and (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then
        player.direction = constants.DIRECTIONS.LEFT
    elseif love.keyboard.isDown("lctrl") 
        and (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
        player.direction = constants.DIRECTIONS.DOWN
    elseif love.keyboard.isDown("lctrl") 
        and (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
        player.direction = constants.DIRECTIONS.RIGHT
    -------------------
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        player.desiredDirection = constants.DIRECTIONS.UP
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        player.desiredDirection = constants.DIRECTIONS.LEFT
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        player.desiredDirection = constants.DIRECTIONS.DOWN
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.desiredDirection = constants.DIRECTIONS.RIGHT
    end
end

return keyboard