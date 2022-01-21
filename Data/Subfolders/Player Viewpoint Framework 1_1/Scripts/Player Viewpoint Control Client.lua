local BINDING = script.parent.parent:GetCustomProperty("KeyBinding")
local CAMERA1 = script.parent.parent:GetCustomProperty("Camera1"):WaitForObject()
local CAMERA2 = script.parent.parent:GetCustomProperty("Camera2"):WaitForObject()
local LOCAL_PLAYER = Game.GetLocalPlayer()
local activeCameraIndex = 1
local result

function OnBindingPressed(player, binding)

	if player == LOCAL_PLAYER and binding == BINDING then

		if activeCameraIndex == 1 then
			LOCAL_PLAYER:SetDefaultCamera(CAMERA2)
		else
			LOCAL_PLAYER:SetDefaultCamera(CAMERA1)
		end
		
		activeCameraIndex = activeCameraIndex % 2 + 1
		
		result = Events.BroadcastToServer("ChangeViewPoint", activeCameraIndex)
		
		-- code to rebroadcast this event change if failure to insure player Settings are changed on Server side.
		while result ~= BroadcastEventResultCode.SUCCESS do
				
				result = Events.BroadcastToServer("ChangeViewPoint", activeCameraIndex)
				
				Task.Wait(.5)
				
				-- result was a warning but broadcast was a sucess
				if result == BroadcastEventResultCode.EXCEEDED_RATE_WARNING_LIMIT then
				   result = BroadcastEventResultCode.SUCCESS
				end
				
		end
		

	end
end

LOCAL_PLAYER.bindingPressedEvent:Connect(OnBindingPressed)
