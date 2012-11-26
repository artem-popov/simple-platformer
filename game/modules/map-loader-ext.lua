local ml = require "modules/map-loader/Loader"
local global = _G

function ml.get_objects( layer, physics )
	local objects = {}

    for i, j, tile in layer:iterate() do
        local x, y, w, h = i*level.tileWidth + level.tileWidth / 2, j*level.tileWidth + level.tileWidth / 2, level.tileWidth, level.tileWidth
        if tile.properties.hero then 
            local object = physics:create_hero( x, y, w/2, h-1, "dynamic", "hero" )
            object.id = tile.id
            object = ml.set_handling( object )
            table.insert( objects, object )
        elseif tile.properties.crate then
            local object = physics:create_crate( x, y, w, h, "dynamic", "crate" )
            object.id = tile.id
            table.insert( objects, object )
        end
    end

    return objects
end

function ml.get_objects_glued( layer, physics )
	local objects = {}
    local p_box = { x = 0, y = 0, w = 0, h = 0, exist = false } -- possible box, if we glue it with current tile
    for j = 0, layer.map.height do
        for i = 0, layer.map.width do
            if layer:get( i, j ) then
                if p_box.exist then
                    p_box.w = p_box.w + level.tileWidth
                    p_box.x = p_box.x + level.tileWidth / 2
                else
                    p_box.exist = true
                    p_box.x, p_box.y, p_box.w, p_box.h = i*level.tileWidth + level.tileWidth / 2, j*level.tileWidth + level.tileWidth / 2, level.tileWidth, level.tileWidth
                end
                -- the last one
                if (i == layer.map.width - 1) and ( j == layer.map.height - 1 ) then
                    -- create glued rectangle
                    local object = physics:create_box( p_box.x, p_box.y, p_box.w, p_box.h, "static", "ground" )
                   
                    table.insert( objects, object )
                    p_box.exist = false
                end
            else
                if p_box.exist then 
                    -- create glued rectangle
                    local object = physics:create_box( p_box.x, p_box.y, p_box.w, p_box.h, "static", "ground" )
                    table.insert( objects, object )
                    p_box.exist = false
                end
            end 
        end
    end
    return objects
end

function ml.is_near( box1, box2 )
    if math.abs( box2.x - box1.x ) < box1.w or math.abs( box1.x - box2.x ) < box2.w then 
        return true
    end
    return false
end

function ml.join_tables( table1, table2 )
    for i, item in pairs( table2 ) do
        table.insert( table1, item )
    end
    return table1
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