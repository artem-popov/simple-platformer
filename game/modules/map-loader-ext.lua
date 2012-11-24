local ml = require "modules/map-loader/Loader"
local global = _G

function ml.get_objects_from_level( level, physics )
	local objects = {}
    local possible_widetile = { x = 0, y = 0, w = 0, h = 0, is_ground = false } --save data about possible tile that we can do if glue tiles
	for i, layer in pairs( level.layers ) do
        for i, j, tile in layer:iterate() do
            local x, y, w, h = i*level.tileWidth + level.tileWidth / 2, j*level.tileWidth + level.tileWidth / 2, level.tileWidth, level.tileWidth
            if tile.properties.hero then 
                local object = physics:create_hero( x, y, w/2, h, "dynamic", "hero" )
                object.id = tile.id
                object = ml.set_handling( object )
                table.insert( objects, object )
            elseif tile.properties.crate then
                local object = physics:create_crate( x, y, w, h, "dynamic", "crate" )
                object.id = tile.id
                table.insert( objects, object )
            elseif tile.properties.ground or tile.properties.spike then
                
                local object = physics:create_box( x, y, w, h-1, "static", "ground" )
                object.id = tile.id
                table.insert( objects, object )
            end
        end
    end
    return objects
end

function ml.draw_objects( level, objects )
	for i, obj in pairs( objects ) do
        local x, y = obj:get_xy()
        
        --level.tiles[obj.id]:draw( x , y )
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor( 0, 255, 0, 255 )
        local x1, y1, x2, y2 = obj.fixture:getBoundingBox()
        love.graphics.rectangle("line", x1, y1, x2 - x1, y2 - y1 )
        love.graphics.setColor( r, g, b, a )
	end
end

function ml.draw_layer( layer )
	for i, j, tile in layer:iterate() do
		tile:draw( i * tile.width, j * tile.width )
	end
end

function ml.get_by_name( objects, name)
    for i, obj in pairs( objects ) do
        if obj.name == name then return obj end
    end
end

function ml.set_handling( object )
    function object:handle( dt )
        local vx, vy = object.body:getLinearVelocity()
        if love.keyboard.isDown("right") then
            object.body:setLinearVelocity( 75, vy )
        end
        if love.keyboard.isDown("left") then
            object.body:setLinearVelocity( -75, vy )
        end
    end
    return object
end 

function check_hit( x, y )

end

function ml.inherit_dynamic( object, mass )
    object.dynamic = true
    object.mass = mass
    function object:on_collide()
        --some action
    end
    return object
end

function ml.inherit_static( object )
    object.dynamic = false
    return object
end

return ml