local items = require("src.items.items")

local Recipes = {
    axe = {
        ingredients = {
            {
                id = items.branch.id,
                qnt = 2
            },
            {
                id = items.stone.id,
                qnt = 1
            }
        },
        rewards = {
            {
                id = items.axe.id,
                qnt = 1
            }
        }
    },
    bonfire = {
        ingredients = {
            {
                id = items.wood.id,
                qnt = 1
            },
            {
                id = items.fiber.id,
                qnt = 2
            }
        },
        rewards = {
            {
                id = items.bonfire.id,
                qnt = 1
            }
        }
    }
}

return Recipes