-- special love function
-- gets called only once, used for start configurations
function love.load()
    Object = require "lib/classic"  -- library for easy implementation on OOP in Lua
    camera = require "lib/camera"   -- library for implementation of camera in the game

    cam = camera()  -- creating the camera object (looks like OOP right? Yeah .. it is actually just a function which return an object .. so basically OOP .. and it works! No need for heavy, complicated constructs)

    anim8 = require "lib/anim8" -- library for animation related stuff
    sti = require "lib/sti" -- library for map related stuff (loading, rendering, etc. )
    wf = require "lib/windfield" -- library for implementing gravity and colliders into the game

    love.graphics.setDefaultFilter("nearest", "nearest")    -- does something important I presume .. althought I dont know what .. Imma leave it here tho

    world = wf.newWorld(0, 100) -- creates a ned windfield world and sets the strength of its gravity

    gameMap = sti('maps/GameMap.lua')  -- loads the game map (it is created using tiled, which can export the map into lua code, so it can be used here)

    require "player"    -- loads our player code onto here .. it is important to require it right here, because it uses the libraries above

    player = Player()   -- creates the player object

    -- will load the colliders created in tiled into our real map
    solidObjects = {}   -- 
    if gameMap.layers["SolidObjects"] then
        for i, obj in pairs(gameMap.layers["SolidObjects"].objects) do
            local solidObject = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            solidObject:setType('static')
            table.insert(solidObjects, solidObject)
        end
    end

    letterObjects = {}
    if gameMap.layers["LettersObjects"] then
        for i, obj in pairs(gameMap.layers["LettersObjects"].objects) do
            local letterObject = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            letterObject:setType('ghost')
            table.insert(letterObjects, letterObject)
        end
    end
end

-- special love function which is called repeatedly
-- updates everything before it gets drawn
function love.update(dt)
    world:update(dt)
    player:update(dt)
    cam:lookAt(player.x, player.y)
end

-- special love function which is called repeatedly
-- draws everything on the screen
function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Background'])
        gameMap:drawLayer(gameMap.layers['Trees'])
        gameMap:drawLayer(gameMap.layers['Bushes'])
        gameMap:drawLayer(gameMap.layers['Props'])
        gameMap:drawLayer(gameMap.layers['Letters'])
        gameMap:drawLayer(gameMap.layers['Wheat'])
        gameMap:drawLayer(gameMap.layers['Grass'])
        gameMap:drawLayer(gameMap.layers['Building'])
        gameMap:drawLayer(gameMap.layers['Ground'])
        player:draw()
    cam:detach()
end
