local global = _G

local game_status = { gold = 0, death = 0 }

function game_status:show()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor( 50, 50, 50, 255 )
    love.graphics.rectangle('fill', 0 , 0, love.graphics.getWidth(), 30)
    
    love.graphics.setColor( 200, 200, 200, 255 )
    love.graphics.print( 'GOLD:', 10, 8 )
    love.graphics.print( game_status.gold, 60, 8 )
    love.graphics.print( 'DEATH:', 100, 8 )
    love.graphics.print( game_status.death, 150, 8 )
    love.graphics.setColor( r, g, b, a )
end

return game_status