local conf = require("conf")
local constants = require("src.core.constants")
local Creatures = require("src.entities.creatures.creatures")

local BattleList = {}

BattleList.new = function()
    local self = {}

    self.creatures = {}
    self.currentIndex = 0

    function self:getNext()
        if #self.creatures == 0 then
            return nil
        end

        self.currentIndex = self.currentIndex + 1
        if self.currentIndex > #self.creatures then
            self.currentIndex = 1
        end

        return self.creatures[self.currentIndex]
    end

    function self:update(camera)
        --print(love.timer.getTime() .. " " .. os.time())
        self.creatures = Creatures.getInCamera(camera, self)

        --[[ for k, creature in pairs(self.creatures) do
            creature.addedToBattleListTime = os.time()
        end ]]
    end

    function self:draw(playerTarget)
        love.graphics.print("Battle List:", conf.WINDOW_WIDTH - 100, conf.WINDOW_HEIGHT - 250)
        for k, creature in ipairs(self.creatures) do
            if creature == playerTarget then
                love.graphics.setColor(1, 0, 0)
            end
            love.graphics.print("- " .. creature.name, conf.WINDOW_WIDTH - 100, conf.WINDOW_HEIGHT - 250 + k * 20)
            if creature == playerTarget then
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    return self
end

return BattleList