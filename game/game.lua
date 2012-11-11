-- requered modules
local map_loader_module = require "modules/map-loader-ext"
local camera_module = require "modules/camera-ext"

-- setup modules
map_loader_module.path = "levels/"

function game:init()
    -- load level
	level = map_loader_module.load("level_1.tmx")
    -- create camera ( zoom, speed, tsize, tw, th )
	camera = camera_module( 4, 200, 16, 15, 10 )
end

function game:draw()
    camera.fn:attach()

    level:draw()

    camera.fn:detach()
end

function game:update( dt )
    camera:handle_camera( dt )
end

function game:keyreleased(key, code)
    if key == 'escape' then
        love.event.quit()
    end
end