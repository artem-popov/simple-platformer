-- requered modules
logger = require "modules/logger" 
local map_module = require "modules/map-loader-ext"
local camera_module = require "modules/camera-ext"
local physics = require "modules/physics"

-- setup modules
map_module.path = "levels/"

function game:init()
    -- load level
	level = map_module.load("level_0.tmx")
    -- init physics. set gravity
    physics:init( 500 )
    -- set bounds
    physics:set_world_bounds( level )
    -- load objects
    game_objects = map_module.get_objects_glued( level("ground"), physics )
    game_objects = map_module.join_tables( game_objects, map_module.get_objects( level("objects"), physics ) )
    -- get hero
    hero = map_module.get_by_name( game_objects, "hero" )
    
    -- create camera ( zoom, speed, tsize, tw, th )
	camera = camera_module( love.graphics.getHeight() / ( level.tileWidth * level.height ), 200, level.tileWidth, level.width, level.height )
end

function game:draw()
    camera.fn:attach()

    map_module.draw_layer( level("background") )
    map_module.draw_objects( level, game_objects )

    local x, y = hero:get_xy()
    love.graphics.rectangle('line', x + 2, y + 15, 2, 1 )
    camera.fn:detach()

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
        local x, y = hero:get_xy()
        physics.world:queryBoundingBox( x + 2, y + 15, x + 4, y + 16, on_query )
        hero:jump()
    end
end

function on_query( fixt )
    local a = fixt:getUserData()
    logger.log( a.name )
    return true
end