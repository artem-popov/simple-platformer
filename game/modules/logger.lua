local logger = {}

logger.messages = {}
logger.max = 10

function logger.log( message )
    if #logger.messages > logger.max then
        for k in pairs(logger.messages) do logger.messages[k] = nil end
        table.insert( logger.messages, message )
    else 
        table.insert( logger.messages, message )
    end
end

function logger.draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor( 0, 100, 0, 255 )
    for i, m in pairs( logger.messages ) do
        love.graphics.print( m, 10, i * 15 )
    end
    love.graphics.setColor( r, g, b, a )
end

return logger