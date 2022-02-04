
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1) balloon 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) balloon 2
            x = 75,
            y = 95,
            width = 90,
            height = 83
        },
        {   -- 3) balloon 3
            x = 75,
            y = 178,
            width = 100,
            height = 97
        },
        {   -- 4) cat
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}
local objectSheet = graphics.newImageSheet( "./images/gameObjects.png", sheetOptions )

-- Initialize variables
local lives = 3
local score = 0
local died = false

local balloonsTable = {}

local cat
local gameLoopTimer
local livesText
local scoreText

local backGroup
local mainGroup
local uiGroup

local explosionSound
local catSound
local fireSound
local musicTrack


local function updateText()
	livesText.text = "Lives: " .. lives
	scoreText.text = "Score: " .. score
end


local function createBalloon()

	local newBalloon = display.newImageRect( mainGroup, objectSheet, 1, 102, 85 )
	table.insert( balloonsTable, newBalloon )
	physics.addBody( newBalloon, "dynamic", { radius=40, bounce=0.8 } )
	newBalloon.myName = "balloon"

	local whereFrom = math.random( 3 )

	if ( whereFrom == 1 ) then
		-- From the left
		newBalloon.x = -60
		newBalloon.y = math.random( 500 )
		newBalloon:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
	elseif ( whereFrom == 2 ) then
		-- From the top
		newBalloon.x = math.random( display.contentWidth )
		newBalloon.y = -60
		newBalloon:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
	elseif ( whereFrom == 3 ) then
		-- From the right
		newBalloon.x = display.contentWidth + 60
		newBalloon.y = math.random( 500 )
		newBalloon:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
	end

	newBalloon:applyTorque( math.random( -6,6 ) )
end


local function fireLaser()

	-- Play fire sound!
	audio.play( fireSound )

	local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40 )
	physics.addBody( newLaser, "dynamic", { isSensor=true } )
	newLaser.isBullet = true
	newLaser.myName = "laser"

	newLaser.x = cat.x
	newLaser.y = cat.y
	newLaser:toBack()

	transition.to( newLaser, { y=-40, time=500,
		onComplete = function() display.remove( newLaser ) end
	} )
end


local function dragCat( event )

	local cat = event.target
	local phase = event.phase

	if ( "began" == phase ) then
		-- Set touch focus on the cat
		display.currentStage:setFocus( cat )
		-- Store initial offset position
		cat.touchOffsetX = event.x - cat.x

	elseif ( "moved" == phase ) then
		-- Move the cat to the new touch position
		cat.x = event.x - cat.touchOffsetX

	elseif ( "ended" == phase or "cancelled" == phase ) then
		-- Release touch focus on the cat
		display.currentStage:setFocus( nil )
	end

	return true  -- Prevents touch propagation to underlying objects
end


local function gameLoop()

	-- Create new balloon
	createBalloon()

	-- Remove balloons which have drifted off screen
	for i = #balloonsTable, 1, -1 do
		local thisBalloon = balloonsTable[i]

		if (thisBalloon.x < -100 or
			thisBalloon.x > display.contentWidth + 100 or
			thisBalloon.y < -100 or
			thisBalloon.y > display.contentHeight + 100 )
		then
			display.remove( thisBalloon )
			table.remove( balloonsTable, i )
		end
	end
end


local function restoreCat()

	cat.isBodyActive = false
	cat.x = display.contentCenterX
	cat.y = display.contentHeight - 100

	-- Fade in the cat
	transition.to( cat, { alpha=1, time=4000,
		onComplete = function()
			cat.isBodyActive = true
			died = false
		end
	} )
end


local function endGame()
	composer.setVariable( "finalScore", score )
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end


local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "laser" and obj2.myName == "balloon" ) or
			 ( obj1.myName == "balloon" and obj2.myName == "laser" ) )
		then
			-- Remove both the laser and balloon
			display.remove( obj1 )
			display.remove( obj2 )

			-- Play explosion sound!
			audio.play( explosionSound )

			for i = #balloonsTable, 1, -1 do
				if ( balloonsTable[i] == obj1 or balloonsTable[i] == obj2 ) then
					table.remove( balloonsTable, i )
					break
				end
			end

			-- Increase score
			score = score + 100
			scoreText.text = "Score: " .. score

		elseif ( ( obj1.myName == "cat" and obj2.myName == "balloon" ) or
				 ( obj1.myName == "balloon" and obj2.myName == "cat" ) )
		then
			if ( died == false ) then
				died = true

				-- Play cat sound!
				audio.play( catSound )

				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives

				if ( lives == 0 ) then
					display.remove( cat )
					timer.performWithDelay( 2000, endGame )
				else
					cat.alpha = 0
					timer.performWithDelay( 1000, restoreCat )
				end
			end
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the cat, balloons, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	-- Load the background
	local background = display.newImageRect( backGroup, "./images/background.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	cat = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
	cat.x = display.contentCenterX
	cat.y = display.contentHeight - 100
	physics.addBody( cat, { radius=30, isSensor=true } )
	cat.myName = "cat"

	-- Display lives and score
	livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
	scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )

	cat:addEventListener( "tap", fireLaser )
	cat:addEventListener( "touch", dragCat )

	explosionSound = audio.loadSound( "./audio/explosion.wav" )
	catSound = audio.loadSound( "./audio/cat.wav" )
	fireSound = audio.loadSound( "./audio/fire.wav" )
	musicTrack = audio.loadStream( "./audio/80s-Space-Game_Looping.wav" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
		-- Start the music!
		audio.play( musicTrack, { channel=1, loops=-1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		-- Stop the music!
		audio.stop( 1 )
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
	audio.dispose( explosionSound )
	audio.dispose( catSound )
	audio.dispose( fireSound )
	audio.dispose( musicTrack )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
