local ml = require "modules/map-loader/Loader"
local global = _G

function ml.get_objects( layer, physics )
	local objects = {}

    for i, j, tile in layer:iterate() do
        local x, y, w, h = i*level.tileWidth + level.tileWidth / 2, j*level.tileWidth + level.tileWidth / 2, level.tileWidth, level.tileWidth
        if tile.properties.hero then 
            local object = physics:create_hero( x, y, w/2, h-1 )
            object:set_tiles( { { id = tile.id, x = x, y = y } } )
            table.insert( objects, object )
        elseif tile.properties.crate then
            local object = physics:create_crate( x, y, w, h )
            object:set_tiles( { { id = tile.id, x = x, y = y } } )
            table.insert( objects, object )
        end
    end

    return objects
end

function ml.get_objects_glued( layer, physics )
	local objects = {}
    local p_box = { x = 0, y = 0, w = 0, h = 0, tiles = {}, exist = false } -- possible box, if we glue it with current tile
    for j = 0, layer.map.height do
        for i = 0, layer.map.width do
            local tile = layer:get( i, j )
            if tile then
                if p_box.exist then
                    p_box.w = p_box.w + level.tileWidth
                    p_box.x = p_box.x + level.tileWidth / 2
                    table.insert( p_box.tiles, { id = tile.id, x = i*level.tileWidth, y = j*level.tileWidth } )
                else
                    p_box.exist = true
                    p_box.x, p_box.y, p_box.w, p_box.h = i*level.tileWidth + level.tileWidth / 2, j*level.tileWidth + level.tileWidth / 2, level.tileWidth, level.tileWidth
                    table.insert( p_box.tiles, { id = tile.id, x = i*level.tileWidth, y = j*level.tileWidth } )
                end
                -- the last one
                if (i == layer.map.width - 1) and ( j == layer.map.height - 1 ) then
                    -- create glued rectangle
                    local object = physics:create_ground( p_box.x, p_box.y, p_box.w, p_box.h )
                    object:set_tiles( p_box.tiles )
                    table.insert( objects, object )
                    p_box.tiles = {}
                    p_box.exist = false
                end
            else
                if p_box.exist then 
                    -- create glued rectangle
                    local object = physics:create_ground( p_box.x, p_box.y, p_box.w, p_box.h )
                    object:set_tiles( p_box.tiles )
                    table.insert( objects, object )
                    p_box.tiles = {}
                    p_box.exist = false
                end
            end 
        end
    end
    return objects
end

function ml.join_tables( table1, table2 )
    for i, item in pairs( table2 ) do
        table.insert( table1, item )
    end
    return table1
end

function ml.draw_objects( level, objects )
	for i, object in pairs( objects ) do
        if object.type == 'static' then 
            for t, tile in pairs( object.tiles ) do
                level.tiles[tile.id]:draw( tile.x , tile.y )
            end
        else
            local x, y = object:get_xy()
            for t, tile in pairs( object.tiles ) do
                level.tiles[tile.id]:draw( x , y )
            end
        end
	end
end

function ml.draw_layer( layer )
	for i, j, tile in layer:iterate() do
		tile:draw( i * tile.width, j * tile.width )
	end
end

function ml.get_by_name( objects, name)
    for i, object in pairs( objects ) do
        if object.name == name then return object end
    end
end

return ml