map_loader_module = require "modules/map-loader/Loader"

function map_loader_module.get_objects_from_level( level, layer_name, collider, is_active, tsize )
	local objects = {}
	
	for i, j, tile in level( layer_name ):iterate() do
		local ctile = collider:addRectangle( i*tsize, j*tsize, tsize, tsize )
		if tile.properties.hero then 
			ctile.hero = true
			ctile.on_jump = false
			ctile.on_fall = true
			ctile.jtimer = 0 -- jump timer
		end
		ctile.id = tile.id
		ctile.type = layer_name
		--collider:addToGroup("tiles", ctile)
		if not(is_active) then collider:setPassive(ctile)
		else ctile.on_ground = false end
		table.insert(objects, ctile)
	end

    return objects
end

function map_loader_module.draw_layer( level, layer_name )
	for i, j, tile in level( layer_name ):iterate() do
		tile:draw( i * tile.width, j * tile.width ) -- hero not correctly draw
	end
end

function map_loader_module.draw_objects( level, objects )
	for i, obj in pairs( objects ) do
		x, y = obj:bbox()
		level.tiles[obj.id]:draw( x, y )
		--obj:draw()
	end
end

return map_loader_module