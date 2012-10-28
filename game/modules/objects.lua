function gravity_objects( objects, dt )
	for i, obj in pairs( objects ) do
		if not(obj.on_ground) then obj:move( 0, dt * 50 ) end
	end
end

function get_hero_object( objects )
	for i, obj in pairs( objects ) do
		if obj.hero then return obj end
	end
end

function collide_objects( dt, a, b, dx, dy )
	if a.type == "objects" and b.type == "ground" then
		if not( a.on_ground ) then a:move( dx, dy )
		else a.on_ground = true end
	elseif b.type == "objects" and a.type == "ground" then
		if not( b.on_ground ) then b:move( dx, dy )
		else b.on_ground = true end
	elseif a.type == "objects" and b.type == "objects" then
		a:move( dx, dy )
		b:move( -dx, -dy )
	end
end