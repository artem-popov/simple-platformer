-- requered modules
local map_module = require "modules/map-loader-ext"
local camera_module = require "modules/camera-ext"
local collider_module = require "modules/hardon-collider"
local physics = require "modules/physics"
local logger = require "modules/logger" 

-- setup modules
map_module.path = "levels/"

function game:init()
    -- load level
	level = map_module.load("level_0.tmx")
	-- create collider object 
	collider = collider_module( 100, collide_objects )
    -- load objects
    game_objects = map_module.get_objects_from_level( level("objects"), collider )
    -- create camera ( zoom, speed, tsize, tw, th )
	camera = camera_module( 4, 200, 16, 15, 10 )
end

function game:draw()
    camera.fn:attach()

    map_module.draw_layer( level("background") )
    map_module.draw_layer( level("ground") )
    map_module.draw_objects( level, game_objects )

    camera.fn:detach()

    logger.draw()
end

function game:update( dt )
    camera:handle_camera( dt )
    collider:update( dt )
end

function game:keyreleased(key, code)
    if key == 'escape' then
        love.event.quit()
    end
    logger.log(key)
end