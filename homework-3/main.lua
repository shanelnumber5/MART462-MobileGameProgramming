--[[

This is the main.lua file. It executes first and in this demo
is sole purpose is to set some initial visual settings and
then you execute our game or menu scene via composer.

Composer is the official scene (screen) creation and management
library in Corona SDK. This library provides developers with an
easy way to create and transition between individual scenes.

https://docs.coronalabs.com/api/library/composer/index.html 

-- ]]

local composer = require( "composer" )

-- Removes status bar on iOS
display.setStatusBar( display.HiddenStatusBar ) 

-- Removes bottom bar on Android 
if ( system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 ) then
	native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end

-- Reserve audio for menu, background sounds, and wheels
audio.reserveChannels( 3 )

-- Are we running in a simulator?
local isSimulator = "simulator" == system.getInfo( "environment" )
local isMobile = ( "ios" == system.getInfo("platform") ) or ( "android" == system.getInfo("platform") )

-- Load visual monitor and allow press of the "F" key to show frame rate and memory usage
if isSimulator then 

	-- Load visual monitor
	local visualMonitor = require( "com.ponywolf.visualMonitor" )
	local visMon = visualMonitor:new()
	visMon.isVisible = false  -- Initially hide it

	-- Show/hide physics
	local function debugKeys( event )
		local phase = event.phase
		local key = event.keyName
		if phase == "up" then
			if key == "f" then
				visMon.isVisible = not visMon.isVisible 
			end
		end
	end
	Runtime:addEventListener( "key", debugKeys )
end

-- This module turns gamepad axis events and mobile accelometer events into keyboard events
-- so we don't have to write separate code for joystick and keyboard control
require( "com.ponywolf.joykey" ).start()

-- Add virtual buttons to mobile 
system.activate( "multitouch" )
if isMobile or isSimulator then
	local vjoy = require( "com.ponywolf.vjoy" )
	local right = vjoy.newButton( "scene/game/img/ui/wheelButton.png", "right" )
	local left = vjoy.newButton( "scene/game/img/ui/footButton.png", "left" )  
	local jump = vjoy.newButton( "scene/game/img/ui/jumpButton.png", "space" )  
	right.x, right.y = display.screenOriginX + 256 + 32, display.screenOriginY + display.contentHeight - 96
	left.x, left.y =  display.screenOriginX + 128,display.screenOriginY + display.contentHeight - 96 - 32  
	jump.x, jump.y = -display.screenOriginX + display.contentWidth - 128, display.screenOriginY + display.contentHeight - 96
	right.xScale, right.yScale = 0.5, 0.5
	left.xScale, left.yScale = 0.5, 0.5
	jump.xScale, jump.yScale = 0.5, 0.5
end

-- Go to menu screen
composer.gotoScene( "scene.menu", { params={} } )

-- Uncomment to delete high scores
--system.deletePreferences( "app", { "scores" } )
