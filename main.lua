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
    world:addCollisionClass('Solid') -- adds a collision class for solid objects
    world:addCollisionClass('Player') -- adds collision class for the player
    world:addCollisionClass('Enemy') -- adds collision class for the enemy
    world:addCollisionClass('Ghost', {ignores = {'Solid', 'Enemy', 'Player'}}) -- adds a collision class for abstract objects
    world:addCollisionClass('Gun', {ignores = {'Solid', 'Enemy', 'Player'}})
    world:addCollisionClass('Bullet', {ignores = {'Solid', 'Player', 'Enemy', 'Ghost', 'Gun'}})

    gameMap = sti('maps/GameMap.lua')  -- loads the game map (it is created using tiled, which can export the map into lua code, so it can be used here)
    
    gameState = {
        menuScreen = true,
        runningScreen = false,
        deathScreen = false
    }

    bullet_delay = 60

    enemies = {}
    bullets = {}

    require "player"    -- loads our player code onto here .. it is important to require it right here, because it uses the libraries above
    require "enemy"     -- loads our enemy code onto here .. it is important to require it right here, because it uses the libraries above and also need the player object to be created
    require "button"
    require "bullet"
    require "menu"

    player = Player()   -- creates the player object

    menu = Menu()

    -- will load the colliders created in tiled into our real map
    solidObjects = {}   -- just to keep track of all solid walls and stuff
    if gameMap.layers["SolidObjects"] then  -- checking if this layer exists in the map
        for i, obj in pairs(gameMap.layers["SolidObjects"].objects) do  -- adds a solid collier to every object in the SolidObjects layer
            local solidObject = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            solidObject:setType('static')
            solidObject:setCollisionClass('Solid')
            table.insert(solidObjects, solidObject)
        end
    end

    letterObjects = {} -- just to keep track of all letter colliders
    if gameMap.layers["LettersObjects"] then    -- checking if this layer exists in the map
        for i, obj in pairs(gameMap.layers["LettersObjects"].objects) do -- adds an abstract collider to every object in the LettersObjects layer
            local letterObject = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            letterObject:setType('static')
            letterObject:setCollisionClass('Ghost')
            -- letterObject itself does not hold any information about its position or dimensions .. since it is just a table, I can store them in it like this
            letterObject.x = obj.x
            letterObject.y = obj.y
            letterObject.width = obj.width
            letterObject.height = obj.height
            table.insert(letterObjects, letterObject)
        end
    end


    enemySpawns = {} 
    if gameMap.layers["EnemySpawns"] then    
        for i, obj in pairs(gameMap.layers["EnemySpawns"].objects) do
            local enemySpawn = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            enemySpawn:setType('static')
            enemySpawn:setCollisionClass('Ghost')
            -- letterObject itself does not hold any information about its position or dimensions .. since it is just a table, I can store them in it like this
            enemySpawn.x = obj.x
            enemySpawn.y = obj.y
            enemySpawn.width = obj.width
            enemySpawn.height = obj.height
            table.insert(enemySpawns, enemySpawn)
        end
    end


    gunObject = nil
    if gameMap.layers["GunObject"] then
        obj = gameMap.layers["GunObject"].objects[1]
        gunObject = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        gunObject:setType('static')
        gunObject:setCollisionClass('Gun')
    end


    letterTexts = {"First letter", "Second letter", "Third letter", "Fourth letter", "Fifth letter", "Sixth letter", "Seventh letter", "Eight letter", "Nineth letter"}

end

-- special love function which is called repeatedly
-- updates everything before it gets drawn
function love.update(dt)
    if gameState.menuScreen then
        menu:update(dt)
    elseif gameState.runningScreen then
        world:update(dt)
        player:update(dt)

        if bullet_delay > 0 then bullet_delay = bullet_delay - 1 end
        
        for i, enemy in pairs(enemies) do
            enemy:update(dt)

            if enemy.collider:enter('Bullet') then
                table.remove(enemies, i)
                enemy.collider:destroy()
            end
        end

        for i, bullet in pairs(bullets) do
            bullet:update(dt)
            
            if math.abs(bullet.x - bullet.starting_x) >= bullet.disappear or math.abs(bullet.y - bullet.starting_y) >= bullet.disappear then
                table.remove(bullets, i)
                bullet.collider:destroy()
            end

            if bullet.collider:enter('Enemy') then
                table.remove(bullets, i)
                bullet.collider:destroy()
            end
        end

        for i, enemySpawn in pairs(enemySpawns) do

           if enemySpawn.x < player.x + 400 and math.abs(player.y - enemySpawn.y) <= 100 then
                table.insert(enemies, Enemy(enemySpawn.x, enemySpawn.y))
                table.remove(enemySpawns, i)
                enemySpawn:destroy()
            end
        end

        if love.mouse.isDown(1) and (bullet_delay <= 0) and (player.armed)
        then
            local mouse_x, mouse_y = cam:mousePosition()

            local angle = math.atan2((mouse_y - player.y), (mouse_x - player.x))

            local velocity_x = 36e3 * math.cos(angle)

            local velocity_y = 36e3 * math.sin(angle)

            table.insert(bullets, Bullet(player.x, player.y, velocity_x, velocity_y))

            bullet_delay = 60
        end

        cam:lookAt(player.x, player.y)
    elseif gameState.deathScreen then
        if love.keyboard.isDown('e') then
            love.event.quit('restart')
        end
    end

end

-- special love function which is called repeatedly
-- draws everything on the screen
function love.draw()
    if gameState.menuScreen then
        menu:draw()
    elseif gameState.runningScreen and player.x then
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

            for i, enemy in ipairs(enemies) do
                enemy:draw()
            end
                
            for i, bullet in ipairs(bullets) do
                bullet:draw()
            end
        cam:detach()

                    -- Used to render a letter on the screen, when the player passes around it
        -- It is called outside the camera:attach() because we want it move with the player
        for i, obj in pairs(letterObjects) do

            if (player.x >= obj.x 
            and player.x <= obj.x + obj.width) 
            and (player.y >= obj.y 
            and player.y <= obj.y + obj.height) then -- checking if the player collides with any of the letter ghost colliders
                love.graphics.setColor(255, 255, 255, .8)   -- setting the color of background for the letter and adjusting alpha value, so it will be a little transparent
                love.graphics.rectangle("fill", 100, 30, love.graphics.getWidth() - 200, love.graphics.getHeight() - 60)
                love.graphics.setColor(255, 255, 255, 1)    -- setting back the default alpha value, so only the background of the letter becomes transparent
                love.graphics.printf({{0, 0, 0}, letterTexts[i]}, 100, 30, love.graphics.getWidth() - 200, 'left')  -- printing the letter onto the background
                                                                                                                    -- thanks to this function, the text will wrap itself .. also we are getting the texts from external files
            end
        end
    elseif gameState.deathScreen then
        love.graphics.print("GAME OVER")
    end
end
