-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local background = display.newImageRect( "./images/background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0.99 )

local platform = display.newImageRect( "./images/platform2.png", 350, 80 )
platform.x = display.contentCenterX
platform.y = display.contentHeight -0.8

local needle = display.newImageRect( "./images/needle.png", 15, 100 )
needle.x = display.contentCenterX + 120
needle.y = display.contentHeight - 485

physics.addBody( needle, "static" )

local balloon = display.newImageRect( "./images/balloon1.png", 100, 100 )
balloon.x = display.contentCenterX - 6
balloon.y = display.contentCenterY - 400
balloon.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius = 50, bounce = 0.2 } )
balloon:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )

local function pushBalloon()
	balloon:applyLinearImpulse( 0, 0.75, balloon.x, balloon.y )
end

balloon:addEventListener( "tap", pushBalloon )

local platform = display.newImageRect( "./images/platform.png", 10, 2000 )
platform.x = display.contentCenterX - 170
platform.y = display.contentHeight - 25

local balloon = display.newImageRect( "./images/balloon2.png", 125, 125 )
balloon.x = display.contentCenterX - 8
balloon.y = display.contentCenterY - 400
balloon.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius = 50, bounce = 0.2 } )
balloon:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )

local function pushBalloon()
	balloon:applyLinearImpulse( 0, 0.75, balloon.x, balloon.y )
end

balloon:addEventListener( "tap", pushBalloon )

local balloon = display.newImageRect( "./images/balloon3.png", 175, 175 )
balloon.x = display.contentCenterX - 9
balloon.y = display.contentCenterY - 400
balloon.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius = 50, bounce = 0.2 } )
balloon:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )

local function pushBalloon()
	balloon:applyLinearImpulse( 0, 0.75, balloon.x, balloon.y )
end

balloon:addEventListener( "tap", pushBalloon )

local platform = display.newImageRect( "./images/platform.png", 10, 2000 )
platform.x = display.contentCenterX + 170
platform.y = display.contentHeight - 25

local balloon = display.newImageRect( "./images/balloon4.png", 90, 90 )
balloon.x = display.contentCenterX - 8
balloon.y = display.contentCenterY - 450
balloon.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius = 50, bounce = 0.2 } )
balloon:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )

local function pushBalloon()
	balloon:applyLinearImpulse( 0, 0.75, balloon.x, balloon.y )
end

balloon:addEventListener( "tap", pushBalloon )

balloon:addEventListener( "tap", pushBalloon )

local platform = display.newImageRect( "./images/platform2.png", 350, 80 )
platform.x = display.contentCenterX
platform.y = display.contentHeight - 0.5

local platform = display.newImageRect( "./images/platform2.png", 350, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight + 25

local function pushBalloon()
	balloon:applyLinearImpulse( 0, 0.75, balloon.x, balloon.y )
end

balloon:addEventListener( "tap", pushBalloon )



