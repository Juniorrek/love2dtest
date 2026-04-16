# love2dtest

This is a small survival game made with Love2D.

The main inspiration is:
- Don't Starve for gameplay
- Tibia for graphics and map feeling

## TODO

MERGEMERGEMERGE

 Stabilize the current network movement
Do this first, before prediction.

Fix the FPS/blocking issue.
Why:
Right now low FPS makes all movement debugging confusing. If the game drops from 60 to 5 FPS, it becomes hard to know whether the bug is networking or just frame stalls.

Finish the authoritative movement flow.
Why:
The server should be the source of truth before you add client-side tricks.

Make hold-to-walk work correctly with inputState.
Why:
You already moved away from “one persistent intention”, which is good. Now you need a clean rule for:

press
hold
release
tile boundary continue/stop
Make the client render movement smoothly from server data.
Why:
Even without prediction, smooth drawing already improves feel a lot.

Only then evaluate prediction.
Why:
Prediction is easier when the base system is already correct.

Phase 1: Fix what is broken now
This should be your immediate focus.

Remove blocking network polling from the frame loop.
Make client input sending consistent with server input freshness rules.
Make tile-boundary movement decisions fully server-side.
Make sure one tap never becomes endless walking.
Make sure holding a key keeps walking.
This phase is done when:

FPS stays stable after F1
tap walks a controlled amount
hold keeps moving
release stops at the next correct boundary
Phase 2: Clean multiplayer foundation
After movement feels correct for one player, organize the server/client roles better.

Add a real server-side player registry.
Why:
Right now the code looks close to “one global player”. Multiplayer will be much easier if the server owns players by peer/client id.

Separate server player state from client visual player objects.
Why:
The server version should care about simulation.
The client version should care about drawing and interpolation.

Add a small shared protocol module.
Why:
Packet names like "initial" and "update" should live in one place.

Make the server broadcast all relevant player states.
Why:
That is the base for remote players.

This phase is done when:

each connected client gets its own server player
clients know which player is “me”
clients can also see other players
Phase 3: Improve movement presentation
This is where the game starts feeling nicer, not just correct.

Draw from interpolated/smoothed position instead of snapping only by grid.
Add interpolation for other players.
Add interpolation later for creatures too.
Why:
For remote entities, interpolation is usually simpler and safer than prediction.

This phase is done when:

local movement looks smooth
remote players do not teleport tile by tile
Phase 4: Decide if you really need prediction
Only do this after the previous phases.

Prediction is useful if:

local movement still feels delayed
you want movement to begin instantly on the client
Prediction is not necessary yet if:

localhost already feels good
your game is tile-based and slower-paced
For your project, I think:

interpolation for remote entities is very important
prediction for local player is optional, but nice later
lag compensation for combat is probably unnecessary for now
A simpler roadmap from your notes

Now
Fix FPS/blocking
Finish authoritative tile movement
Fix input state send/hold/release
Make stop/continue happen only at tile boundaries
Smooth client drawing
Next
Server player registry
Shared protocol file
Separate simulation player from render player
Broadcast all player positions
Test with 2 localhost clients
Later
Interpolation for remote players
Interpolation for creatures
Optional local prediction
Chunked map sending
Camera-based rendering optimization
Much later
Combat improvements
Interaction cleanup
Hunger/berries
Bush hiding
Better mouse system
World/character structure



MERGEMERGEMERGE





Fix the FPS/blocking issue.
Fix input handling so the server stores inputState, not only a persistent desiredDirection.
Make the server decide “continue or stop” from the latest stored input state at tile boundaries.
Make the client draw movement smoothly.
Only after that, add prediction if you still want more responsiveness.


Client send input state instead input event
-Sends on event and every fixed tick rate
Server reads, update and responds
While, the clients predicts

Later interpolation for creatures and other players
Lag compensation maybe unnecessary



Make server movement continuous.
Add a proper server-side player registry/handler.
Separate server player creation from client visual player creation.
Change input sending from “single key press event” to “current input state”.
Only after that, think about client prediction/interpolation.

- NETWORK
    1. Draw ground on client sent by server
    Create the base folders: src/server, src/client, src/shared.
    Create src/shared/protocol.lua with the first packet/message names.
    Create a minimal server that starts and accepts connections.
    Make the server create one player per connected client.
    Make the client connect to the server and receive its player id.
    Create a simple client input state: up, down, left, right.
    Send that input from client to server.
    Move players only on the server.
    Broadcast player positions from server to all clients.
    Draw local and remote players on the client.
    Test with 2 clients on localhost first.
    Test with 2 different machines after localhost works.
- COMBAT
    - ~~Player take hit~~
    - Battle list
        - List from the creatures grid? List creatures around
    - Add player attack cooldown/timer
    - Mouse click target
    - Fix creature movement around blocked tiles (maybe pathfinding?)
- Place to hide from monster like (bushes)
- Add hunger system & grab berries
- Multiplayer
    - Can be played singleplayer or multiplayer, but I think both will run a "server"
    - Player can have multiple characters and "worlds" like Terraria (maybe need to think more about the worlds cause the world is mostly static but for sure would be areas "procedurally generated", or maybe the worlds to "hold" a state where the game is, cause the game will be a series of quests like Tibia and will be unlocking other areas)

## Improvements

- Server send chunks instead whole map
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
