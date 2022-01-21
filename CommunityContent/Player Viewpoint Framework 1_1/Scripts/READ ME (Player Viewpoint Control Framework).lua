--[[

Player Viewpoint Control Framework
Version 1.0
Chaz Scholton (XRStudio) 

 
This framework was put together to allow players to toggle between
Third Person and First Person Viewpoints during game play.


	The "Player Viewpoint Control" is designed to support Swapping between 2 viewpoints (First and Third Person)
	
	/// Player Viewpont Control - Custom Properties ///
	[KeyBinding] is the name of the ability_extra key which the players use to change viewpoints during game play
	The Default KeyBinding is set for "V" (ability_extra_42) on the keyboard
	
	The following settings reference the Default (starting) Core Object Player Settings and Camera 
		[PlayerSettings1] 	default set to use third person player settings
		[Camera1]			default set to use third person camera
	
	The following settings reference the Alternative Core Object Player Settings and Camera.
		[PlayerSettings2]	default set to use first person player settings
		[Camera2]			default set to use first person camera


	The Framework comes with two default Player View Point Groups
		1).  Third Person - Player Viewpoint (player and Camera Settings)
		2).  First Person - Player Viewpoint (player and Camera Settings)

The PlayerSettings[1,2] and Camera[1,2] Custom Properties reference the Player Settings (Core Object)
and Camera (Core Objects) contained in these groups.


		// Third Person right-left shoulder Camera Toggle //
		The Third Person - Player Viewpoint (Player and Camera settings) group contains the
		Third Person - Switch Shoulder Camera View 
		
		This allows players in Third person viewpoint mode to toggler the camera between the left and right shoulders
		You can enable/disable this within it's Custom Properties, along with configuration of the KeyBinding used.
		
		The Default keybinding is set to ability_extra_10 (Left Ctrl)


This framework is based upon CC (community contect) posted by zurishmi (Game Style Swapper Example) and Chris (Shoulder Cam Switcher),
Along with the default first and third person player and camera settings for Third and First Person Deathmatch Templates.


NOTES: 

Third Person and First Person "Player Settings" to control things such as player jump, Max Acceleration, movement, crouch and more will need to be updated
in each player settings.  That is if you wish to maintain a consistent experience.  This framework is a bit different from the default
First and Third Person Project Templates.  Because it relies upon Two "Player Settings" Components instead of a single "Player Settings" game component.


I wanted to piece together a framework to allow players to toggle between First and Third Person mode like many other video games.

One that was easy to drop into an existing third or first person game created using the Default Core Project Templates.


--]]








