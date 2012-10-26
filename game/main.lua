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

local hero
local collider
local ground_tiles
local hero_tile 

function love.load()
	-- load level
	level = ML.load("level1.tmx")
	-- set collisions callbacks
	collider = HC(100, on_collide)
	-- set ground tiles
    ground_tiles = get_ground_tiles( level )
	-- set hero obj 
	hero_tile = get_hero_tile( level )
	
	init_hero( 16, 16, tile_size, tile_size * 2 )
end

function love.update( dt )
	camera:handle_camera( dt )
	
	update_hero( dt )
	
	collider:update( dt )
	
end

function love.draw()
	camera:attach()
	
	level:draw()

	camera:detach()
end

function draw_hero()
	local hx, hy = hero:center()
	level.tiles[hero_tile.id]:draw( hx, hy )
end

function init_hero( x, y, w, h )
	hero = collider:addRectangle( x ,y, w, h )
    hero.speed = 200
end

function update_hero( dt )
    -- apply a downward force to the hero (=gravity)
    hero:move( 0, dt * hero.speed )
end

function get_ground_tiles( level )
	local collidable_tiles = {}
	
	for i, j, tile in level("ground"):iterate() do
		local ctile
		ctile = collider:addRectangle(i*tile_size,j*tile_size,tile_size,tile_size)
		ctile.type = "tile"
		collider:addToGroup("tiles", ctile)
		collider:setPassive(ctile)
		table.insert(collidable_tiles, ctile)
	end

    return collidable_tiles
end

function get_hero_tile( level )
	for i, obj in pairs( level("objects").objects ) do
		if obj.hero then 
			return obj
		end
	end
end

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    collide_hero(dt, shape_a, shape_b, mtv_x, mtv_y)
end

function collide_hero(dt, shape_a, shape_b, mtv_x, mtv_y)

    -- sort out which one our hero shape is
    local hero_shape, tileshape
    if shape_a == hero and shape_b.type == "tile" then
        hero_shape = shape_a
    elseif shape_b == hero and shape_a.type == "tile" then
        hero_shape = shape_b
    else
        -- none of the two shapes is a tile, return to upper function
        return
    end

    -- why not in one function call? because we will need to differentiate between the axis later
    hero_shape:move(mtv_x, 0)
    hero_shape:move(0, mtv_y)

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