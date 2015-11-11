-- Project: StructuralCompass
-- File name: main.lua
--
-- Author: Amir Farazmand
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local widget = require( "widget" )
local lfs = require( "lfs" )
---
local appupdate = function( event )
os.exit()
end

if os.time () > 1477008000 then

native.showAlert( "Alert!",
"Update the app from Google Play!", { "OK" }, appupdate
);
end
----
for i = 1,math.floor(250/5) do
      local titleBar = display.newLine( 0, i, 320*2, i )
       titleBar:setStrokeColor( 0.4-i/400, 0.5-i/400, 0.8-i/400 )
end
projectNameText = display.newText( "Project List", 110, 25, native.systemFont, 14 )
projectNameText : setTextColor( 0,0,0)

------function-----------------------------------------------------------------

local function startRecording(  )
	 recordGroup = display.newGroup()

local currentLatitude = 0
local currentLongitude = 0
projectname = "project"
--display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "anchorX", 0.0 )	-- default to Left anchor point
---------------------------------------------------------------------------------------
--AdBuddiz.showAd()
local background = display.newImage("images/background.png")
		recordGroup:insert( background )
background.y = 300		-- Top anchor

local log = native.newTextField( 15, 150, 280, 60 )
log.size = 26
log.text = "Jn, 10mm, R, etc"
  recordGroup:insert( log )

projectNameText.text = selectedFile

textObject = display.newText( "Discontinuty Full Log", 15, 100, native.systemFont, 16 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( textObject )

local latitude = display.newText( "00.12345", 0, 0, "DBLCDTempBlack", 12 )
latitude.anchorX = 0
latitude.x, latitude.y = 105, 240
latitude:setFillColor( 0, 0, 240 )
textObject = display.newText( "Lat", 80, 240, native.systemFont, 16 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( latitude )
recordGroup:insert( textObject )

local longitude = display.newText( "000.000000", 0, 0, "DBLCDTempBlack", 12 )
longitude.x, longitude.y = 215, 240
longitude:setFillColor( 0, 0, 255 )
textObject = display.newText( "Long", 175, 240, native.systemFont, 16 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( longitude )
recordGroup:insert( textObject )

local altitude = display.newText( "--", 0, 0, "DBLCDTempBlack", 12 )
altitude.x, altitude.y = 30, 240
altitude:setFillColor( 0, 0, 255 )
textObject = display.newText( "Alt", 10, 240, native.systemFont, 16 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( altitude )
recordGroup:insert( textObject )

local magnetic = display.newText( "000.000000", 0, 0, "DBLCDTempBlack", 20 )
magnetic.x, magnetic.y = 175, 215
magnetic:setFillColor( 0, 0, 255 )
textObject = display.newText( "DipDir ", 115, 215, native.systemFont, 20 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( magnetic )
recordGroup:insert( textObject )

local dip = display.newText( "00.000", 0, 0, "DBLCDTempBlack", 20 )
dip.x, dip.y = 45, 215
dip:setFillColor( 0, 0, 255 )
textObject = display.newText( "Dip ", 10, 215, native.systemFont, 20 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( dip )
recordGroup:insert( textObject )

local time = display.newText( "--", 0, 0, "DBLCDTempBlack", 14 )
time.x, time.y = 55, 280
time:setFillColor( 0, 0, 255 )
textObject = display.newText( "Time ", 10, 280, native.systemFont, 14 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( time )
recordGroup:insert( textObject )

local accuracy = display.newText( "--", 0, 0, "DBLCDTempBlack", 14 )
accuracy.x, accuracy.y = 80, 260
accuracy:setFillColor( 0, 0, 255 )
textObject = display.newText( "Accuracy ", 10, 260, native.systemFont, 14 )
textObject : setTextColor( 0,0,0)
recordGroup:insert( accuracy )
recordGroup:insert( textObject )

display.setDefault( "anchorX", 0.5 )	-- default to Center anchor point
---------------------------------------------------------------------------------------

--FUNCTIONS

local locationHandler1 = function( event )

	-- Check for error (user may have turned off Location Services)
	if event.errorCode then
		native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
		print( "Location error: " .. tostring( event.errorMessage ) )
	else

		local latitudeText = string.format( '%.5f', event.latitude )
		currentLatitude = latitudeText
		latitude.text = latitudeText

		local longitudeText = string.format( '%.5f', event.longitude )
		currentLongitude = longitudeText
		longitude.text = longitudeText

		local altitudeText = string.format( '%.3f', event.altitude )
		altitude.text = altitudeText

		local accuracyText = string.format( '%.3f', event.accuracy )
		accuracy.text = accuracyText

		-- Note: event.time is a Unix-style timestamp, expressed in seconds since Jan. 1, 1970
	--	local timeText = string.format( '%.0f', event.time )
		local timeText = (os.date( "%c" ))
		time.text = timeText


	end
end

-------------------
local directionHandler1 = function( event )
		local magneticText = string.format( '%.1f', event.magnetic )
		magnetic.text = magneticText
end
-------------------
local function processor(event)
	local theta = math.atan2(event.yGravity, -event.zGravity)
	local phi = math.atan2(event.xGravity, -event.zGravity)
	local dipText = string.format( '%.0f', math.deg(theta) )
	dip.text = dipText
end

-----------------------------------------------
local saverecord = function( event )

local filePath = system.pathForFile( selectedFile, system.DocumentsDirectory )

file = io.open( filePath, "a" )
file:write( dip.text  .. " " .. magnetic.text .. " ".. latitude.text .. " " .. longitude.text .. " " )
file:write( altitude.text .. " " .. log.text .. " " .. time.text )
file:write( " " .. accuracy.text )
file:write( "\n" )
io.close( file )
print(filePath)

local click = audio.loadSound("click.wav");
audio.play(click)

end
----------------------------------------------------------------------------------------
-- Handle the projectsave keyboard input
-------------------------------------------------------------------------------------------------------
-- Buttons

----------------------------------------------
local function ProjectList( event )
	projectNameText.text = "Project List"
	if ( event.phase == "ended" ) then
	print(event.phase)
   		recordGroup:removeSelf()
		tableView.isVisible=true
	end
		return true
end
projectListB = widget.newButton
{
	defaultFile = "images/export.png",
	overFile = "images/exportover.png",
	label = "Project List",
	fontSize = 116,
	labelColor =
	{
		default = { 0, 0, 0 },
	},
	emboss = true,
	onEvent= ProjectList,
}
projectListB.x, projectListB.y = 250, 25
projectListB:scale( .1, .1 )
recordGroup:insert( projectListB )
-------------------------------------------------
exportB = widget.newButton
{
	defaultFile = "images/export.png",
	overFile = "images/exportover.png",
	label = "Export",
	fontSize = 116,
	labelColor =
	{
		default = { 0, 0, 0 },
	},
	emboss = true,
	onEvent= projectExport,
}
exportB.x, exportB.y = 250, 445
exportB:scale( .1, .1 )
recordGroup:insert( exportB )
-------------------------------------------
local saverecordB = widget.newButton
{
	defaultFile = "images/buttonRust.png",
	overFile = "images/buttonRustOver.png",
	label = "Save Record",
	labelColor =
	{
		default = { 200/255, 200/255, 200/255, 1},
		over = { 200/255, 200/255, 200/255, 128/255 }
	},
	font = "TrebuchetMS-Bold",
	fontSize = 22,
	emboss = true,
	onPress = saverecord,
}
saverecordB.x, saverecordB.y = 160, 340
recordGroup:insert( saverecordB )
--------------------------------------
-------------------------------------------------------------------------------------------------------------------------


-- Activate location listener
Runtime:addEventListener( "location", locationHandler1 )
Runtime:addEventListener( "heading", directionHandler1 )
Runtime:addEventListener('accelerometer', processor)
	
end -- end of startRecording
---
 -- project Export Pressed

  function projectExport(  )

	-- compose an HTML email with two attachments
	local options =
	{
	   to = { },
	 
	   subject = selectedFile,
	   isBodyHtml = true,
	   body = "<html><body>Structural mapping project</body></html>",
	   attachment =
	   {
		  { baseDir=system.DocumentsDirectory, filename = selectedFile, type="text" },
	   },
	}
	local result = native.showPopup("mail", options)
 end
 -----------
 function projectnamefield( event )

	if ( "began" == event.phase ) then

		textMode = true

	elseif ( "ended" == event.phase ) then
		-- This event is called when the user stops editing a field: for example, when they touch a different field
        textField.isVisible = false
        tableView.isVisible = true
        local filePath = system.pathForFile( textField.text, system.DocumentsDirectory )
        file = io.open( filePath, "a" )
		io.close( file )
	   listFile(imageOption)
	elseif ( "submitted" == event.phase ) then
		-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
			tableView.isVisible = true
		-- Hide keyboard
		native.setKeyboardFocus( nil )
		textMode = false
		textField.isVisible = false
		 local filePath = system.pathForFile( textField.text, system.DocumentsDirectory )
        file = io.open( filePath, "a" )
		io.close( file )
	    listFile(imageOption)
	end

end

------------File list
 fileOption = {["del"]="images/delete.jpg", ["open"]="images/file.jpg", ["exp"]="images/export.jpg" }
 imageOption  = fileOption["open"]
 ------
local function mainMenu()

 function listFile(x)
	fileNo=0
	fileName = {}
	_W=320
	_H=480
  local doc_path = system.pathForFile( "", system.DocumentsDirectory )
 for file in lfs.dir(doc_path) do
 	fileNo = fileNo+1
 	fileName[fileNo]=file
  end
  if fileNo <3 then fileNo=3 end 
  ----
   function delProject( event )
 	   if event.action == "clicked" then
        local ii = event.index
        if ii == 1 then
  			filePath = system.pathForFile( selectedFile, system.DocumentsDirectory )
                os.remove( filePath  )
                listFile(fileOption["del"])
      elseif ii == 2 then
            
        end
    end
 end
 ----

  local function whatToDoToFile( )

 	if imageOption == "images/file.jpg" then
 		  	  	   startRecording()
          tableView.isVisible=false

 		elseif imageOption == "images/export.jpg" then
 			projectExport()

 		else
 			local alert = native.showAlert( "ALERT", "Are you sure to delete this file?  "..selectedFile, { "Yes", "No" }, delProject )
    end
  end
 -----
  local function onRowRender( event )
     -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

     if jobText then jobText =nil end
     local jobText = display.newText( row, row.id, 0, 0, systemFontBold, _W*.06)
    jobText:setFillColor( 0,0,0 )
    jobText.anchorX = 0
    jobText.x = _W*.08
    jobText.y = rowHeight * 0.55

   if row.id == "Export or Delete a Project" then
   	elseif row.id == "Create a New Project" then
   		else
 	 -- Precalculate y position. NOTE: row's height will change as we add children
	   local rowArrow = display.newImageRect( row, x, 20, 20, false )
	  -- Right-align the arrow
 	 rowArrow.anchorX = 1
 	 rowArrow.x = rowWidth - _W/20
 	 rowArrow.y = rowHeight*.5
 	 rowArrow.image = "images/delete.jpg"
end
 end
local function onRowTouch( event)
 if ( "tap" == event.phase ) then
		local function projectOption( event )
		  if event.action == "clicked" then
       			 local i = event.index
      		  if i == 1 then
        		listFile(fileOption["del"])
        		imageOption = fileOption["del"]

        	   elseif i == 3 then
        		  listFile(fileOption["exp"])
        		  imageOption = fileOption["exp"]
        	   else
        	    	listFile(fileOption["open"])
        	    	imageOption = fileOption["open"]
              end
          end
   			 return true
  		end
  	  selectedFile = event.row.id
  	  if selectedFile == "Export or Delete a Project" then 
  	  	   local alert = native.showAlert( "Project", "What to do with this file?  "..selectedFile, { "Delete Project", "Open", "Export" }, projectOption )

  	     elseif  selectedFile == "Create a New Project" then  
  	  	  	  	tableView.isVisible=false
			local tHeight = 35
			if isAndroid then tHeight = 35 end		-- adjust for Android
			textField = native.newTextField( 155, 20, 280, tHeight )
			textField.text = "EnterProjectName"
			textField:addEventListener( "userInput", projectnamefield )

  	     else
  	  		whatToDoToFile()

	  end
 end
end
-- Create the file List
if tableView then tableView:removeSelf() end
  tableView = widget.newTableView
{
    left = 0,
    top = 50,
    height = 480,
    width = 320,
    onRowRender = onRowRender,
    onRowTouch = onRowTouch,
    listener = scrollListener
}

-- Insert 40 rows
  for i = 1, fileNo do
    -- Insert a row into the tableView

      if i==1 then
    	tableView:insertRow{id = "Export or Delete a Project", rowHeight = 60} 
       elseif i == 2 then
    	 tableView:insertRow{id = "Create a New Project", rowHeight = 60} 
       else
        tableView:insertRow{id = fileName[i], rowHeight = 60}
      end
   end

end-- end of listFile
listFile(imageOption)
end --end of main menu

-----first page
local golfer = display.newImageRect( "images/firstPage.jpg",320,568)
golfer.x = display.contentCenterX
golfer.y = display.contentCenterY
transition.fadeOut( golfer, { time=5000 } )
timer.performWithDelay( 3500, mainMenu )

