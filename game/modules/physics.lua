local physics = {}
local global = _G

function physics:init( gravity )
    self.world = love.physics.newWorld( 0, gravity, false )
    self.world:setCallbacks( self.beginContact, self.endContact )
end

function physics:create_box( x, y, w, h, type, name )
	local box = {}
    box.name = name
	box.body = love.physics.newBody( self.world, x, y, type )
	box.shape = global.love.physics.newRectangleShape( w, h )
	box.fixture = global.love.physics.newFixture( box.body, box.shape )
	box.fixture:setRestitution( 0 )
    box.fixture:setUserData( { name = name } )
    box.body:setFixedRotation( true )

    function box:get_xy()
        return box.body:getWorldPoints( box.shape:getPoints() )
    end

	return box
end

function physics:create_crate( x, y, w, h, type, name )
	local box = {}
    box.name = name
	box.body = love.physics.newBody( self.world, x, y, type )
	box.shape_box = global.love.physics.newRectangleShape( 0, 0, w, h / 2, 0 )
	box.shape_circle = global.love.physics.newCircleShape( w / 2 )
	box.fixture = global.love.physics.newFixture( box.body, box.shape_circle )
	box.fixture_box = global.love.physics.newFixture( box.body, box.shape_box )
	box.fixture:setRestitution( 0.3 )
    box.fixture:setFriction( 1 )
    box.fixture_box:setUserData( { name = "crate_roof" } )
    box.fixture:setUserData( { name = name } )
    box.body:setFixedRotation( true )

    function box:get_xy()
        return box.body:getX() - box.shape_circle:getRadius(), box.body:getY() - box.shape_circle:getRadius()
    end

	return box
end

--[[ makes hero shape
    contains rectangle and circle shapes
]]--
function physics:create_hero( x, y, w, h, type, name )
	local box = {}
    box.name = name
	box.body = love.physics.newBody( self.world, x, y, type )
	box.shape_box = global.love.physics.newRectangleShape( w, h * 0.75 )
	box.shape_circle = global.love.physics.newCircleShape( 0, h / 2, w / 2 - 2 )

	box.fixture_box = global.love.physics.newFixture( box.body, box.shape_box )
	box.fixture = global.love.physics.newFixture( box.body, box.shape_circle )

	box.fixture_box:setRestitution( 0 )
	box.fixture_box:setUserData( { name = "hero_body" } )
	box.fixture:setRestitution( 0 )
    box.fixture:setFriction( 1 )
    box.fixture:setUserData( { name = name, on_ground = false } )
    box.body:setFixedRotation( true )

    function box:get_xy()
        return box.body:getWorldPoints( box.shape_box:getPoints() )
    end

	return box
end

function physics.beginContact( a_fixture, b_fixture, coll)
    a = a_fixture:getUserData()
    b = b_fixture:getUserData()

    if a.name == "hero" then 
        a.on_ground = true
        a_fixture:setUserData( a )
    end
    if b.name == "hero" then 
        b.on_ground = true
        b_fixture:setUserData( b )
    end

end

function physics.endContact()

end

function physics:set_world_bounds( level )
    -- w, h in pixels
    local level_w, level_h = level.tileWidth * level.width, level.tileHeight * level.height
    local tile_w = level.tileWidth
    -- left
    physics:create_box( - tile_w / 2, level_h / 2, tile_w, level_h, "static", "bound" )
    -- right
    physics:create_box( level_w + tile_w / 2, level_h / 2, tile_w, level_h, "static", "bound" )

end
return physics