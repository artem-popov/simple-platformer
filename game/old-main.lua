-- requered modules
local ML = require "modules/map-loader/Loader"
local HC = require "modules/hardon-collider"
local CAM = require "modules/hamp/camera"

-- setup modules

ML.path = "levels/"

local tile_size = 16
local tiles_h = 20
local tiles_w = 40
local zoom = 4
	
local camera_dx = love.graphics.getWidth() / ( zoom * 2 )
local camera_dy = tile_size * tiles_h - love.graphics.getHeight() / ( zoom * 2 )

local camera = CAM( camera_dx, camera_dy , zoom )
camera.speed = 128;

local hero
local collider
local ground_tiles

function love.load()
	-- load level
	level = ML.load("level1.tmx")
	-- set collisions callbacks
	collider = HC(50, on_collide)
	-- set ground tiles
    ground_tiles = get_ground_tiles( level )
	-- set hero obj 
	hero = get_hero_tile( level )
end

function love.update( dt )
	camera:handle_camera( dt )
	
	handle_hero( dt )
	update_hero( dt )
	
	collider:update( dt )
end

function love.draw()
	camera:attach()
	
	level:draw()
	--draw_hero()
	hero:draw("fill")
	
	camera:detach()
end

function draw_hero()
	local hx, hy = hero:center()
	level.tiles[hero.id]:draw( hx - tile_size / 2, hy - tile_size * 2 )
end

function update_hero( dt )
    -- apply a downward force to the hero (=gravity)
    hero:move( 0, dt * hero.speed )
end

function get_ground_tiles( level )
	local collidable_tiles = {}
	
	for i, j, tile in level("ground"):iterate() do
		if tile.properties.ground then
			local ctile
			ctile = collider:addRectangle(i*tile_size,j*tile_size,tile_size,tile_size - 10)
			ctile.type = "tile"
			collider:addToGroup("tiles", ctile)
			collider:setPassive(ctile)
			table.insert(collidable_tiles, ctile)
		end
	end

    return collidable_tiles
end

function get_hero_tile( level )
	for i, j, tile in level("objects"):iterate() do
		if tile.properties.hero then
			local hero = collider:addRectangle(i*tile_size,j*tile_size,tile_size,2*tile_size - 4)
			hero.id = tile.id
			hero.speed = 100
			return hero
		end
	end
end

function handle_hero( dt )

    if love.keyboard.isDown("left") then
        hero:move(-hero.speed*dt, 0)
    end
    if love.keyboard.isDown("right") then
        hero:move(hero.speed*dt, 0)
    end
    if love.keyboard.isDown("up") then

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

