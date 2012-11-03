function gravity_objects( objects, dt )
	for i, obj in pairs( objects ) do
		if obj.hero then
			if not( obj.on_ground ) then
				if obj.on_jump then
					obj:move( 0, -dt * 100 )
					if obj.jtimer < 15 then
						obj.jtimer = obj.jtimer + 1
					else 
						obj.on_jump = false
						obj.on_fall = true
					end		
				elseif obj.on_fall then
					obj:move( 0, dt * 100 ) 
				end
			elseif obj.on_jump then
				obj:move( 0, -dt * 100 )
				obj.jtimer = 0
			end
		elseif not( obj.on_ground ) then obj:move( 0, dt * 50 ) end
		
	end
end

function get_hero_object( objects )
	for i, obj in pairs( objects ) do
		if obj.hero then return obj end
	end
end

function collide_objects( dt, a, b, dx, dy )
	if a.type == "objects" and b.type == "ground" then
		if not( a.on_ground ) then 
			a:move( dx, dy )
			a.on_ground = true
			if a.hero then 
				a.on_fall = false 
			end
		end
	elseif b.type == "objects" and a.type == "ground" then
		if not( b.on_ground ) then 
			b:move( dx, dy )
			b.on_ground = true
			if b.hero then 
				b.on_fall = false 
			end
		end
	elseif a.type == "objects" and b.type == "objects" then
		a:move( dx, dy )
		b:move( -dx, -dy )
	end
end