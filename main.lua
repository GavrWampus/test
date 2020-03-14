local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
W = display.contentWidth
H = display.contentHeight
-- Seed the random number generator
math.randomseed( os.time() )

-- Get back
function gotoBack()
    composer.getSceneName( composer.getSceneName( "previous" ) )
end


-- Go to the menu screen
composer.gotoScene( "menu" )
