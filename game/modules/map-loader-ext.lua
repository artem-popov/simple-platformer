local ml = require "modules/map-loader/Loader"
local global = _G

function ml.get_objects_from_level( level, collider )
	local objects = {}
	for i, layer in pairs( level.layers ) do
        for i, j, tile in layer:iterate() do
            local object = {}
            object = collider:addRectangle( i*level.tileWidth, j*level.tileWidth, level.tileWidth, level.tileWidth )
            object.id = tile.id
            if tile.properties.hero then 
                object = collider:addRectangle( i*level.tileWidth, j*level.tileWidth, level.tileWidth, level.tileWidth )
                object.id = tile.id
                object.name = "hero"
                object = ml.inherit_dynamic( object, 50 )
                table.insert( objects, object )
            elseif tile.properties.crate then
                object = collider:addRectangle( i*level.tileWidth, j*level.tileWidth, level.tileWidth, level.tileWidth )
                object.id = tile.id
                object.name = "crate"
                object = ml.inherit_dynamic( object, 100 )
                table.insert( objects, object )
            elseif tile.properties.ground or tile.properties.spike then
                object = collider:addRectangle( i*level.tileWidth, j*level.tileWidth, level.tileWidth, level.tileWidth )
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
		local x, y = obj:bbox()
		level.tiles[obj.id]:draw( x, y )
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