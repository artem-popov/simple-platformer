local ml = require "modules/map-loader/Loader"
local global = _G

function ml.get_objects_from_level( level, physics )
	local objects = {}
	for i, layer in pairs( level.layers ) do
        for i, j, tile in layer:iterate() do
            local x, y, w, h = i*level.tileWidth + level.tileWidth / 2, j*level.tileWidth + level.tileWidth / 2, level.tileWidth, level.tileWidth
            if tile.properties.hero then 
                local object = physics:create_box( x, y, w/2, h, "dynamic" )
                object.id = tile.id
                object.name = "hero"
                object = ml.set_hero( object )
                table.insert( objects, object )
            elseif tile.properties.crate then
                local object = physics:create_box( x, y, w, h, "dynamic" )
                object.id = tile.id
                object.name = "crate"
                table.insert( objects, object )
            elseif tile.properties.ground or tile.properties.spike then
                local object = physics:create_box( x, y, w + 1, h, "static" )
                object.id = tile.id
                object.name = "ground"
                table.insert( objects, object )
            end
        end
    end
    return objects
end

function ml.draw_objects( level, objects )
	for i, obj in pairs( objects ) do
		local x, y = obj.body:getWorldPoints( obj.shape:getPoints() )
		if obj.name == "hero" then level.tiles[obj.id]:draw( x - 4, y )
		else level.tiles[obj.id]:draw( x, y ) end
        
        --love.graphics.polygon("fill", obj.body:getWorldPoints( obj.shape:getPoints()))
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

function ml.set_hero( object )
    function object:handle_hero( dt )
        if love.keyboard.isDown("right") then 
            object.body:applyForce(100, 0)
        end
        if love.keyboard.isDown("left") then
            object.body:applyForce(-100, 0)
        end
        if love.keyboard.isDown(" ") then
            object.body:applyForce(0, -300)
        end
    end
    return object
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