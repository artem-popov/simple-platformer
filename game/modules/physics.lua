require "modules/classes"

local physics = {}
local global = _G

function physics:init( gravity )
    self.world = love.physics.newWorld( 0, gravity, false )
    self.world:setCallbacks( self.beginContact, self.endContact )
end

function physics:create_bound( x, y, w, h )
	local object = {}
    setmetatable( object, { __index = Physic_Object } )
    args = {}
    args.name = 'bound'
    args.type = 'static'
    args.visible = false
    args.restitution = 0
    args.x, args.y, args.w, args.h = x, y, w, h
    
    object:construct( args, self.world )

	return object
end

function physics:create_ground( x, y, w, h )
	local object = {}
    setmetatable( object, { __index = Physic_Object } )
    args = {}
    args.name = 'ground'
    args.type = 'static'
    args.restitution = 0
    args.x, args.y, args.w, args.h = x, y, w, h
    
    object:construct( args, self.world )

	return object
end

function physics:create_crate( x, y, w, h )
	local object = {}
    setmetatable( object, { __index = Physic_Object } )
    args = {}
    args.name = 'crate'
    args.type = 'dynamic'
    args.x, args.y, args.w, args.h = x, y, w, h
    
    object:construct( args, self.world )

	return object
end

function physics:create_hero( x, y, w, h )
	local object = {}
    setmetatable( object, { __index = Hero_Object } )
    args = {}
    args.name = 'hero'
    args.type = 'dynamic'
    args.x, args.y, args.w, args.h = x, y, w, h
    
    Physic_Object.construct( object, args, self.world )

	return object
end

function physics.beginContact( a_fixture, b_fixture, coll)
    a = a_fixture:getUserData()
    b = b_fixture:getUserData()

    a.self:on_collide( b.self )
    b.self:on_collide( a.self )

end

function physics.endContact()

end

function physics:set_world_bounds( level )
    -- w, h in pixels
    local level_w, level_h = level.tileWidth * level.width, level.tileHeight * level.height
    local tile_w = level.tileWidth
    -- left
    physics:create_bound( - tile_w / 2, level_h / 2, tile_w, level_h )
    -- right
    physics:create_bound( level_w + tile_w / 2, level_h / 2, tile_w, level_h )

end
return physics