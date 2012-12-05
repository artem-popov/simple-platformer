-- requered modules
logger = require "modules/logger" 
game_status = require "modules/game-status"
map_module = require "modules/map-loader-ext"
camera_module = require "modules/camera-ext"
physics = require "modules/physics"

-- setup modules
map_module.path = "levels/"

function game:init()
    -- load level
	level = map_module.load("level_0.tmx")
    -- init physics. set gravity
    physics:init( 800 )
    -- set bounds
    physics:set_world_bounds( level )
    -- load objects
    game_objects = map_module.get_objects_glued( level("ground"), physics )
    game_objects = map_module.join_tables( game_objects, map_module.get_objects( level("objects"), physics ) )
    -- get hero
    hero = map_module.get_by_name( game_objects, "hero" )
    
    -- create camera ( zoom, speed, tsize, tw, th )
    local zoom = love.graphics.getHeight() / ( level.tileWidth * level.height )
    --local zoom = 4
	camera = camera_module( zoom, 200, level.tileWidth, level.width, level.height )
end

function game:draw()
    camera.fn:attach()

    map_module.draw_layer( level("background") )
    map_module.draw_objects( level, game_objects )

    camera.fn:detach()
    game_status:show()
    logger.draw()
end

function game:update( dt )
    hero:handle( dt )
    camera:handle_camera( dt )
    physics.world:update( dt )
end

function game:keyreleased( key, code )
    if key == 'escape' then
        love.event.quit()
    end
    
end

function game:keypressed( key, code )
    if key == " " then
        hero:what_under_me()
    elseif key == 'z' then
        hero:take_bred()
    end
end

function hero_jump_if_can( fixture )
    local a = fixture:getUserData()
    if not( a.name == 'hero' ) then 
        hero:jump()
        return false
    end
    return true
end

function hero_take_bred( fixture )
    local a = fixture:getUserData()
    if a.name == 'bred' then
        if hero.bred_joint == nil then
            local hx, hy = hero:get_xy()
            a.body:setPosition( hx + 4, hy + 10 )
            hero.bred_joint = love.physics.newWeldJoint( hero.body, a.body, 0, 0, false )
            hero.bred_joint:setFrequency(1)
        else
            hero.bred_joint:destroy()
            hero.bred_joint = nil
            a.body:applyForce( 100, -200 )
        end
        return false
    end
    return true
end