--[[
    Game object classes
]]
local global = _G

-- Physic_Object --

Physic_Object = {}

function Physic_Object:construct( args, world )
    self:check_args( args )

    self:set_box2d_objects( args, world )

    self:add_special_data()
end

function Physic_Object:check_args( args )
    if not( args.name == nil ) then self.name = args.name else self.name = 'noname' end
    if not( args.type == nil ) then self.type = args.type else self.type = 'static' end
    if not( args.visible == nil ) then self.visible = args.visible else self.visible = true end
    if not( args.fix_rotation == nil ) then self.fix_rotation = args.fix_rotation else self.fix_rotation = true end
    if not( args.restitution == nil ) then self.restitution = args.restitution else self.restitution = 0.1 end
    if not( args.friction == nil ) then self.friction = args.friction else self.friction = 1 end
end

function Physic_Object:set_box2d_objects( args, world )
	self.body = love.physics.newBody( world, args.x, args.y, self.type )
	self.shape = love.physics.newRectangleShape( args.w - 1, args.h - 1 )

	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setRestitution( self.restitution )
    self.fixture:setFriction( self.friction )
    self.fixture:setUserData( self )
    self.body:setFixedRotation( self.fix_rotation )
end

function Physic_Object:add_special_data()
    -- nothing
end

function Physic_Object:on_collide( object )
    -- nothing
end

function Physic_Object:get_xy()
    return self.body:getWorldPoints( self.shape:getPoints() )
end

function Physic_Object:set_tiles( tiles )
    self.tiles = tiles
end

-- Hero_Object -- 

Hero_Object = {}
setmetatable( Hero_Object, { __index == Physic_Object } )

function Hero_Object:check_args( args ) -- Physic_Object method
    Physic_Object.check_args( self, args )
end

function Hero_Object:set_box2d_objects( args, world )

    self.body = love.physics.newBody( world, args.x, args.y, self.type )
	self.shape = love.physics.newRectangleShape( args.w, args.h - 2 )

	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setRestitution( 0 )
    self.fixture:setFriction( 0 )
    self.fixture:setUserData( self )
    self.body:setFixedRotation( self.fix_rotation )
   
    self.foot_shape = love.physics.newRectangleShape( 4-args.w / 2, args.h / 2, args.w - 6, 2, 0 )
	self.foot_fixture = love.physics.newFixture( self.body, self.foot_shape )
	self.foot_fixture:setRestitution( 0 )
    self.foot_fixture:setFriction( 0.9 )
    self.foot_fixture:setUserData( self )

end

function Hero_Object:add_special_data()
    self.on_ground = false
end

function Hero_Object:on_collide( object )

end

function Hero_Object:get_xy() -- Physic_Object method
    return Physic_Object.get_xy( self )
end

function Hero_Object:set_tiles( tiles ) -- Physic_Object method
    Physic_Object.set_tiles( self, tiles )
end

function Hero_Object:jump()
    self.body:applyForce(0, -1500)
end

function Hero_Object:what_under_me( physics )
    local x1, y1, x2, y2 = self.fixture:getBoundingBox()
    physics.world:queryBoundingBox( x1 + 4, y2 - 1, x2 - 4, y2, hero_jump_if_can )
end

function Hero_Object:handle( dt )
    local vx, vy = self.body:getLinearVelocity()
    if love.keyboard.isDown("right") then
        self.body:setLinearVelocity( 60, vy )
    end
    if love.keyboard.isDown("left") then
        self.body:setLinearVelocity( -60, vy )
    end
end