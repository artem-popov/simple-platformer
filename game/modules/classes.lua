--[[
    Game object classes
]]
local global = _G

-- Physic_Object --

Physic_Object = {}

function Physic_Object:construct( args, world )
    if args.name then self.name = args.name else self.name = 'noname' end
    if args.type then self.type = args.type else self.type = 'static' end
    if args.visible then self.visible = args.visible else self.visible = true end
    if args.fix_rotation then self.fix_rotation = args.fix_rotation else self.fix_rotation = true end
    if args.restitution then self.restitution = args.restitution else self.restitution = 0.3 end
    if args.friction then self.friction = args.friction else self.friction = 1 end

	self.body = love.physics.newBody( world, args.x, args.y, self.type )
	self.shape = love.physics.newRectangleShape( args.w, args.h )

	self.fixture = love.physics.newFixture( self.body, self.shape )
	self.fixture:setRestitution( self.restitution )
    self.fixture:setFriction( self.friction )
    self.fixture:setUserData( { self = self } )
    self.body:setFixedRotation( self.fix_rotation )

    self:add_special_data()
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

function Hero_Object:add_special_data()
    self.on_ground = false
end

function Hero_Object:on_collide( object )
    if object.name == 'ground' or object.name == 'crate' then
        self.on_ground = true
    end
end

function Hero_Object:get_xy()
    return Physic_Object.get_xy( self )
end

function Hero_Object:set_tiles( tiles )
    Physic_Object.set_tiles( self, tiles )
end

function Hero_Object:jump()
    if self.on_ground then
        self.body:applyForce(0, -1500)
        self.on_ground = false
    end
end

function Hero_Object:handle( dt )
    local vx, vy = self.body:getLinearVelocity()
    if love.keyboard.isDown("right") then
        self.body:setLinearVelocity( 75, vy )
    end
    if love.keyboard.isDown("left") then
        self.body:setLinearVelocity( -75, vy )
    end
end