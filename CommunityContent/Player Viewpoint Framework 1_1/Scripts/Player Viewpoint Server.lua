local PLAYER_SETTINGS1 = script.parent.parent:GetCustomProperty("PlayerSettings1"):WaitForObject()
local PLAYER_SETTINGS2 = script.parent.parent:GetCustomProperty("PlayerSettings2"):WaitForObject()

local activeSettingsIndex = 1


function OnChangeViewPoint(player, activeSettingsIndex)

		if activeSettingsIndex == 2 then
			PLAYER_SETTINGS2:ApplyToPlayer(player)
		else
			PLAYER_SETTINGS1:ApplyToPlayer(player)
		end

end


Events.ConnectForPlayer("ChangeViewPoint", OnChangeViewPoint)
