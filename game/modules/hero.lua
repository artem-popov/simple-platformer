function handle_hero( hero, dt )
	if love.keyboard.isDown("left") then
        hero:move( -100 * dt, 0)
    end
    if love.keyboard.isDown("right") then
        hero:move( 100 * dt, 0)
    end
    if love.keyboard.isDown(" ") then
		if hero.on_ground == true then
			hero:move( 0, -200 * dt) 
			--hero.on_ground = false
		end
    end
end