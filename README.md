# love2dtest

This is a small survival game made with Love2D.

The main inspiration is:
- Don't Starve for gameplay
- Tibia for graphics and map feeling

## TODO
- COMBAT
    - ~~Player take hit~~
    - Player attack closest creature (attackTarget) with hotkey
        - List closests creatures. Based on player position on map, creatures outside the view range doesn't appear on "battle list"
    - Add player attack cooldown/timer
    - Mouse click target
    - Fix creature movement around blocked tiles (maybe pathfinding?)
- Place to hide from monster like (bushes)
- Add hunger system & grab berries
- Multiplayer
    - Can be played singleplayer or multiplayer, but I think both will run a "server"
    - Player can have multiple characters and "worlds" like Terraria (maybe need to think more about the worlds cause the world is mostly static but for sure would be areas "procedurally generated", or maybe the worlds to "hold" a state where the game is, cause the game will be a series of quests like Tibia and will be unlocking other areas)

## Improvements

- Improve things drawn in screen only in camera view
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
- Improve mouse core
    - Own resposibilities map/player
    ```
    inventory:getItem(slot), inventory:moveItem(from,to),
    map:getObjectAt(x,y), map:moveObject(from,to).
    ```
    - Include update state for functionalities like "item icon following the mouse"
    - Drag with trashhold 5 pixels to start counting as drag
- Improve light system with a dark overlay +  light spots...

## Studies for later
- State machine
    - normal, dragging, placing
- Controller pattern
    - keyboard/mouse convert input into actions
- Single responsibility
    - player is not also input manager and map editor
- Data-driven definitions
    - items and harvestable objects described by tables
- World object abstraction
    - dropped wood and bonfire can both live in a world-object system
- Differences between transform and camera offset
- Window width vs camera width (big monitor see more or fixed?)


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
