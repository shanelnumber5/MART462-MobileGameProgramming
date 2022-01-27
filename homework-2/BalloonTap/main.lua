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
platform.y = display.contentHeight - 0.5

local platform = display.newImageRect( "./images/platform2.png", 350, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight + 25

local platform = display.newImageRect( "./images/platform2.png", 350, 80 )
platform.x = display.contentCenterX
platform.y = display.contentHeight -0.8

local needle = display.newImageRect( "./images/needle.png", 15, 100 )
needle.x = display.contentCenterX + 25
needle.y = display.contentHeight - 485

physics.addBody( needle, "static" )
needle.myName = "needle"

local balloonpurple = display.newImageRect( "./images/balloon1.png", 100, 100 )
balloonpurple.x = display.contentCenterX - 5
balloonpurple.y = display.contentCenterY - 400
balloonpurple.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloonpurple, "dynamic", { radius = 50, bounce = 0.2 } )
balloonpurple:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )
balloonpurple.myName = "firstballoon"

local function pushBalloonpurple()
    balloonpurple:applyLinearImpulse( 0, -0.25, balloonpurple.x, balloonpurple.y )
    end

    balloonpurple:addEventListener( "tap", pushBalloonpurple )

local balloonpurple = display.newImageRect( "./images/balloon1.png", 100, 100 )
balloonpurple.x = display.contentCenterX - 5
balloonpurple.y = display.contentCenterY - 400
balloonpurple.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloonpurple, "dynamic", { radius = 50, bounce = 0.2 } )
balloonpurple:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )
balloonpurple.myName = "firstballoon"

local function onCollision(event)

    if ( event.phase == "began" ) then

        local balloonpurple = event.object1
        local needle = event.object2
    end
end

if ( ( balloonpurple.myName == "firstballoon" and needle.myName == "needle" ) or
( balloonpurple.myName == "needle" and needle.myName == "firstballoon" ) )
then
    display.remove( balloonpurple )


    Runtime:addEventListener( "collision", onCollision )
end

local platform = display.newImageRect( "./images/platform.png", 20, 2000 )
platform.x = display.contentCenterX + 170
platform.y = display.contentHeight - 25

local balloonred = display.newImageRect( "./images/balloon2.png", 125, 125 )
balloonred.x = display.contentCenterX - 8
balloonred.y = display.contentCenterY - 400
balloonred.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloonred, "dynamic", { radius = 50, bounce = 0.2 } )
balloonred:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )
balloonred.myName = "secondballoon"

local function pushBalloonred()
balloonred:applyLinearImpulse( 0, -0.25, balloonred.x, balloonred.y )
end

balloonred:addEventListener( "tap", pushBalloonred )

local platform = display.newImageRect( "./images/platform.png", 20, 2000 )
platform.x = display.contentCenterX - 170
platform.y = display.contentHeight - 25

local balloonblue = display.newImageRect( "./images/balloon3.png", 175, 175 )
balloonblue.x = display.contentCenterX - 9
balloonblue.y = display.contentCenterY - 400
balloonblue.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloonblue, "dynamic", { radius = 50, bounce = 0.2 } )
balloonblue:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )
balloonblue.myName = "thirdballoon"

local function pushBalloonblue()
balloonblue:applyLinearImpulse( 0, -0.25, balloonblue.x, balloonblue.y )
end

balloonblue:addEventListener( "tap", pushBalloonblue )

local balloongreen = display.newImageRect( "./images/balloon4.png", 90, 90 )
balloongreen.x = display.contentCenterX - 8
balloongreen.y = display.contentCenterY - 450
balloongreen.alpha = 0.7

physics.addBody( platform, "static" )
physics.addBody( balloongreen, "dynamic", { radius = 50, bounce = 0.2 } )
balloongreen:applyLinearImpulse("./images/balloon4.png", 0.005, 0.00025 )
balloongreen.myName = "fourthballoon"

local function pushBalloongreen()
balloongreen:applyLinearImpulse( 0, -0.25, balloongreen.x, balloongreen.y )
end

balloongreen:addEventListener( "tap", pushBalloongreen )