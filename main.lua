function love.load()
    Object = require "lib/classic"
    camera = require "lib/camera"

    cam = camera()

    anim8 = require "lib/anim8"
    sti = require "lib/sti"
    wf = require "lib/windfield"

    love.graphics.setDefaultFilter("nearest", "nearest")

    world = wf.newWorld(0, 100)

    gameMap = sti('maps/FourthMap.lua')

    require "player"

    player = Player()

    solidObjects = {}
    if gameMap.layers["SolidObjects"] then
        for i, obj in pairs(gameMap.layers["SolidObjects"].objects) do
            local solidObject = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            solidObject:setType('static')
            table.insert(solidObjects, solidObject)
        end
    end

end

function love.update(dt)
    world:update(dt)
    player:update(dt)
    cam:lookAt(player.x, player.y)
end

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
