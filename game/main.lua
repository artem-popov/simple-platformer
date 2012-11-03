-- requered modules
local map_loader_module = require "modules/map-loader/Loader"
local collider_module = require "modules/hardon-collider"
local camera_module = require "modules/camera-ext"

require "modules/map-loader-ext"
require "modules/objects"
require "modules/hero"

-- setup modules
map_loader_module.path = "levels/"

local ground_objects
local active_objects
local hero

function love.load()
	-- load level
	level = map_loader_module.load("level1.tmx")
	-- create camera ( zoom, speed, tsize, tw, th )
	camera = camera_module( 4, 200, 16, 40, 20 )
	-- create collider object 
	collider = collider_module( 100, collide_objects )
	-- load objects ( level, layer_name, collider, is_active, tsize )
	ground_objects = get_objects_from_level( level, "ground", collider, false, 16 )
	active_objects = get_objects_from_level( level, "objects", collider, true, 16 )
	hero = get_hero_object( active_objects )
end

function love.update( dt )
	camera:handle_camera( dt )
	
	handle_hero( hero, dt )
	
	collider:update( dt )
	gravity_objects( active_objects, dt )
end

function love.draw()
	camera.fn:attach()
	
	draw_layer( level, "background" )
	draw_objects( level, ground_objects )
	draw_objects( level, active_objects )
	
	camera.fn:detach()

	if hero.on_ground == true then love.graphics.print( "on ground", 10,10)
	elseif hero.on_jump == true then love.graphics.print( "on jump", 10,10)
	elseif hero.on_fall == true then love.graphics.print( "on fall", 10,10)
	end
end