-- requered modules
local ML = require "modules/map-loader/Loader"
local HC = require "modules/hardon-collider"
local CAM = require "modules/hamp/camera"

-- setup modules

ML.path = "levels/"

local tile_size = 16
local tiles_h = 20
local tiles_w = 40
local zoom = 2
	
local camera_dx = love.graphics.getWidth() / ( zoom * 2 )
local camera_dy = tile_size * tiles_h - love.graphics.getHeight() / ( zoom * 2 )

local camera = CAM( camera_dx, camera_dy , zoom )
camera.speed = 128;

function love.load()
	-- load level
	level = ML.load("level1.tmx")
	
	
	
end

function love.update( dt )
	camera:handle_camera( dt )
end

function love.draw()
	camera:attach()
	
	level:draw()
	
	camera:detach()
	
	local cx, cy = camera:pos()
	love.graphics.print( cx, 10, 10)
	love.graphics.print( cy, 10, 20)
end

function camera:handle_camera( dt )
	if love.keyboard.isDown("a") then
        if self:is_out_screen( -self.speed * dt, 0 ) == false then
			camera:move( -self.speed * dt, 0 )
		end
    end
    if love.keyboard.isDown("d") then
		if self:is_out_screen( self.speed * dt, 0 ) == false then
			camera:move( self.speed * dt, 0 )
		end
    end
    if love.keyboard.isDown("w") then
		if self:is_out_screen( 0, -self.speed * dt ) == false then
			camera:move( 0, -self.speed * dt )
		end
    end
	if love.keyboard.isDown("s") then
		if self:is_out_screen( 0, self.speed * dt ) == false then
			camera:move( 0, self.speed * dt )
		end
    end
end

function camera:is_out_screen( mdx, mdy )
	local cx, cy = camera:pos()
	if cx + mdx < camera_dx or cx + mdx > tile_size * tiles_w - camera_dx or cy + mdy > camera_dy or cy + mdy < love.graphics.getHeight() / ( zoom * 2 ) then 
		return true
	end
	return false
end