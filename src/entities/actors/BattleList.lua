local conf = require("conf")
local Creatures = require("src.entities.creatures.creatures")

local BattleList = {}

BattleList.new = function()
    local self = {}

    self.creaturesList = {}
    self.creaturesUidMap = {}
    self.currentIndex = 0
    self.nextAddedOrder = 0

    function self:getNext()
        if #self.creaturesList == 0 then
            return nil
        end

        self.currentIndex = self.currentIndex + 1
        if self.currentIndex > #self.creaturesList then
            self.currentIndex = 0
            return nil
        end

        return self.creaturesList[self.currentIndex]
    end

    function self:update(camera)
        local inCamera = Creatures.getInCamera(camera)

        for k, entry in ipairs(self.creaturesList) do
            entry.seenOnBattleList = false
        end

        for k, creature in ipairs(inCamera) do
            -- O(1) check if creature is already in battle list otherwise O(n) to verify if it's already in the list and add if not
            if self.creaturesUidMap[creature.uid] then
                self.creaturesUidMap[creature.uid].seenOnBattleList = true
            else
                local entry = {
                    creature = creature,
                    addedToBattleListOrder = self.nextAddedOrder,
                    seenOnBattleList = true
                }
                table.insert(self.creaturesList, entry)
                self.creaturesUidMap[creature.uid] = entry
                self.nextAddedOrder = self.nextAddedOrder + 1
            end
        end

        --BACKWARD TO PREVENT REMOVAL ISSUES
        for i = #self.creaturesList, 1, -1 do
            local entry = self.creaturesList[i]
            if not entry.seenOnBattleList then
                table.remove(self.creaturesList, i)
                self.creaturesUidMap[entry.creature.uid] = nil
            end
        end
    end

    function self:draw(player)
        local playerTarget = player.attack.target
        -- SORT BY TIME ADDDED TO BATTLELIST
        -- MAYBE UNNECESSARY AS THE LIST IS ALREADY IN THE ORDER THEY WERE ADDED, BUT THIS ENSURES IT
        -- ??IF UNNECESSARY MAYBE I COULD USE A NORMAL LIST WITHOUT OPTMIZZATION AND ONLY SORT HERE??
        table.sort(self.creaturesList, function(a, b)
            return a.addedToBattleListOrder < b.addedToBattleListOrder
        end)

        -- SORT BY DISTANCE
        --[[ table.sort(self.creaturesList, function(a, b)
            local distanceA = math.sqrt((a.creature.position.grid.x - player.position.grid.x)^2 + (a.creature.position.grid.y - player.position.grid.y)^2)
            local distanceB = math.sqrt((b.creature.position.grid.x - player.position.grid.x)^2 + (b.creature.position.grid.y - player.position.grid.y)^2)
            return distanceA < distanceB
        end) ]]

        love.graphics.print("Battle List:", conf.WINDOW_WIDTH - 100, conf.WINDOW_HEIGHT - 250)
        for k, entry in ipairs(self.creaturesList) do
            if playerTarget and entry.creature.uid == playerTarget.uid then
                love.graphics.setColor(1, 0, 0)
            end
            love.graphics.print("- " .. entry.creature.name .. " " .. entry.creature.uid, conf.WINDOW_WIDTH - 100, conf.WINDOW_HEIGHT - 250 + k * 20)
            if playerTarget and entry.creature.uid == playerTarget.uid then
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    return self
end

return BattleList