local physics = {}
local global = _G

function physics:init( gravity )
    self.world = love.physics.newWorld( 0, gravity, false )
    self.world:setCallbacks( self.beginContact, self.endContact )
end

function physics:create_box( x, y, w, h, type )
	local box = {}
	box.body = love.physics.newBody( self.world, x, y, type )
	box.shape = global.love.physics.newRectangleShape( w, h )
	box.fixture = global.love.physics.newFixture( box.body, box.shape )
	box.fixture:setRestitution( 0.2 )
    box.body:setFixedRotation( true )
	return box
end

function physics.beginContact()

end

function physics.endContact()

end
return physics