gamestate = require "modules/hump/gamestate"

menu = gamestate.new()
game = gamestate.new()

require "game"
require "menu"

function love.load()
    gamestate.registerEvents()
    gamestate.switch(menu)
end