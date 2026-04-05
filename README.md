# love2dtest

This is a small survival game made with Love2D.

The main inspiration is:
- Don't Starve for gameplay
- Tibia for graphics and map feeling

## TODO
- Be able to chop tree & get wood
- Get fiber
- Craft bonfire (wood and fiber)
- Light things up
- Add light system

## Improvements

- Separate tile position from draw position
- Replace "magic" numbers with named constants
- Simplify player movement and interaction logic ()
- Treat trees as full objects instead of separate tiles
- Animations
- Untie responsibility from player to handle all, it only asks "I want to interact with the tile in my front/clicked"
    ```
    local result = map.interactAt(x, y) -- Verificar se passa pro "map" essa responsa ou para outro lugar

    if result == "branch" then
        player.branches = player.branches + 1
    elseif result == "stone" then
        player.stones = player.stones + 1
    end
    ```

## References to check later

Layering reference:
- https://discussions.unity.com/t/issue-with-layering-for-a-2-5d-utima7-tibia-style-game/915601

Sprite references:
- https://shivashadowsong.wixsite.com/pixelrealm/archive
- https://github.com/peonso/opentibia_sprite_pack
- https://otsprites.wordpress.com/
- https://opengameart.org/
- https://opengameart.org/content/slates-32x32px-orthogonal-tileset-by-ivan-voirol

Other reference:
- https://www.tibiafanart.com/tibia-is-made-of-pixels/
