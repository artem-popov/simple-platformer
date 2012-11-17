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

    function box:get_xy()
        return box.body:getWorldPoints( box.shape:getPoints() )
    end

	return box
end

function physics:create_circle( x, y, r, type )
	local box = {}
	box.body = love.physics.newBody( self.world, x, y, type )
	box.shape = global.love.physics.newCircleShape( r )
	box.fixture = global.love.physics.newFixture( box.body, box.shape )
	box.fixture:setRestitution( 0.2 )
    box.body:setFixedRotation( true )

    function box:get_xy()
        return box.body:getX() - box.shape:getRadius(), box.body:getY() - box.shape:getRadius()
    end

	return box
end

--[[ makes hero shape
    contains rectangle and circle shapes
]]--
function physics:create_hero( x, y, w, h, type )
	local box = {}
	box.body = love.physics.newBody( self.world, x, y, type )
	box.shape_box = global.love.physics.newRectangleShape( w, h / 2 )
	box.shape_circle = global.love.physics.newCircleShape( 0, h / 2, w / 2 )

	box.fixture_box = global.love.physics.newFixture( box.body, box.shape_box )
	box.fixture_circle = global.love.physics.newFixture( box.body, box.shape_circle )

	box.fixture_box:setRestitution( 0.2 )
	box.fixture_circle:setRestitution( 0.2 )

    box.body:setFixedRotation( true )

    function box:get_xy()
        return box.body:getWorldPoints( box.shape_box:getPoints() )
    end

	return box
end
function physics.beginContact()

end

function physics.endContact()

end
return physics