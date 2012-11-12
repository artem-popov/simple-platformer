function handle_hero( hero, dt )
	if love.keyboard.isDown("left") then
        hero:move( -100 * dt, 0)
    end
    if love.keyboard.isDown("right") then
        hero:move( 100 * dt, 0)
    end
end