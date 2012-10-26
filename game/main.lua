-- requered modules
local ML = require "modules/map-loader/Loader"
local HC = require "modules/hardon-collider"

-- setup modules

ML.path = "levels/"

-- global variables

function love.load()
	map = ML.load("level1.tmx")
end

function love.update(dt)

end

function love.draw()
	map:draw()
end