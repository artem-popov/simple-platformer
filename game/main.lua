-- requered modules
local map_loader_module = require "modules/map-loader/Loader"
local camera_module = require "modules/camera-ext"

-- setup modules
map_loader_module.path = "levels/"

function love.load()
	-- load level
	level = map_loader_module.load("level1.tmx")
	-- create camera
	camera = camera_module( 2, 200, 16, 40, 20 )
end

function love.update( dt )
	camera:handle_camera( dt )
end

function love.draw()
	camera.fn:attach()
	
	level:draw()
	
	camera.fn:detach()
end