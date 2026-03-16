if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    --
-- Graphics
    --
    tree = love.graphics.newImage("tree.png")

    love.graphics.setNewFont(12)
    --love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(4,11,3)

    --
-- Audio
    --
    sound = love.audio.newSource("meadow_ambience.ogg", "stream")
    love.audio.play(sound)

    --
-- Gameplay
    --
    num = 0

    player = {
        sprite = love.graphics.newImage("orc.png"),
		position = {
            x = 256,
            y = 256
        }
    }
end

--
-- Gameloop
--
function love.keypressed(key)
    if key == "up" or key == "w" then
        player.position.y = player.position.y - 32
    end
    if key == "left" or key == "a" then
        player.position.x = player.position.x - 32
    end
    if key == "down" or key == "s" then
        player.position.y = player.position.y + 32
    end
    if key == "right" or key == "d" then
        player.position.x = player.position.x + 32
    end
end

function love.update(dt)
   if love.keyboard.isDown("up") then
        num = num + 1 -- this would increment num by 100 per second
        print(num)
   end

end

function love.draw()
love.graphics.draw(player.sprite, player.position.x, player.position.y)

love.graphics.draw(tree, 400, 300)
end
