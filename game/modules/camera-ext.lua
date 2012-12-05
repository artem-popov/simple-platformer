--[[
This is an extension for hump camera class
Adds movement functions amd checking restrictions

Copyright (c) 2012 Khakimov Ruslan
]]--
local _PATH = (...):match('^(.*[%./])[^%.%/]+$') or ''
local camera_module = require (_PATH .. "/hump/camera")

local camera_ext = {}

local function new( zoom, speed, tsize, tw, th )
	local dx = love.graphics.getWidth() / ( zoom * 2 )
	local dy = tsize * th - love.graphics.getHeight() / ( zoom * 2 )
	
	camera_ext.fn = camera_module( dx, dy , zoom )
	camera_ext.speed = speed
	camera_ext.dx = dx
	camera_ext.dy = dy
	camera_ext.tsize = tsize
	camera_ext.tw = tw
	camera_ext.th = th
	camera_ext.zoom = zoom
	
	return camera_ext
end

function camera_ext:handle_camera( dt )
	if love.keyboard.isDown("a") then
        self:move_please( -self.speed * dt, 0 )
    end
    if love.keyboard.isDown("d") then
        self:move_please( self.speed * dt, 0 )
    end
    if love.keyboard.isDown("w") then
        self:move_please( 0, -self.speed * dt )
    end
    if love.keyboard.isDown("s") then
        self:move_please( 0, self.speed * dt )
    end
end

function camera_ext:is_out_screen( mdx, mdy )
	local cx, cy = camera_ext.fn:pos()
	if cx + mdx < self.dx or cx + mdx > self.tsize * self.tw - self.dx or cy + mdy > self.dy or cy + mdy < love.graphics.getHeight() / ( self.zoom * 2 ) then 
		return true
	end
	return false
end

function camera_ext:move_please( dx, dy )
    if self:is_out_screen( dx, dy ) == false then
		camera_ext.fn:move( dx, dy )
	end
end

-- the module
return setmetatable({new = new},
	{__call = function(_, ...) return new(...) end})