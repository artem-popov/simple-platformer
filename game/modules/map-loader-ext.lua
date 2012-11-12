local ml = require "modules/map-loader/Loader"

function ml.get_objects_from_level( layer, collider )
	local objects = {}
	
	for i, j, tile in layer:iterate() do
		local object = collider:addRectangle( i*level.tileWidth, j*level.tileWidth, level.tileWidth, level.tileWidth )
        object.id = tile.id
		if tile.properties.hero then 
            object.name = "hero"
			object = ml.inherit_dynamic( object, 50 )
		elseif tile.properties.crate then
            object.name = "crate"
            object = ml.inherit_dynamic( object, 100 )
        else
            object.name = "noname"
            collider:setPassive(object)
		end
		
		table.insert( objects, object )
	end

    return objects
end

function ml.draw_objects( level, objects )
	for i, obj in pairs( objects ) do
		x, y = obj:bbox()
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
    object.px = object.x
    object.py = object.y
    function object:on_collide()
        --some action
    end
    return object
end

function ml.inherit_static( object )
    object.dynamic = false
    function object:on_collide()
        --no actions
    end
    return object
end

return ml