function get_objects_from_level( level, layer_name, collider, is_active, tsize )
	local objects = {}
	
	for i, j, tile in level( layer_name ):iterate() do
		local ctile = collider:addRectangle( i*tsize, j*tsize, tsize, tsize )
		if tile.properties.hero then 
			ctile.hero = true 
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

function draw_layer( level, layer_name )
	for i, j, tile in level( layer_name ):iterate() do
		tile:draw( i * tile.width, j * tile.width ) -- hero not correctly draw
	end
end

function draw_objects( level, objects )
	for i, obj in pairs( objects ) do
		x, y = obj:bbox()
		level.tiles[obj.id]:draw( x, y )
		--obj:draw()
	end
end