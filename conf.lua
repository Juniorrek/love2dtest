local conf = {}

conf.WINDOW_WIDTH = 800
conf.WINDOW_HEIGHT = 608

function love.conf(t)
    t.window.width = conf.WINDOW_WIDTH
    t.window.height = conf.WINDOW_HEIGHT
end

return conf