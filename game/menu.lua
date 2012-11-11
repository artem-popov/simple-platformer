function menu:draw()
    love.graphics.print( "Please insert coins or press enter...", 10, 10)
end

function menu:keyreleased(key, code)
    if key == "return" then
        gamestate.switch(game)
    end
end