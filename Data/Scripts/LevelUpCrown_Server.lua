
local APICREATOR_SERVER = require(script:GetCustomProperty("APICreatorServer"))

local MINT_WAIT_DURATION = script:GetCustomProperty("MintDuration")
local LEVEL_UP_DURATION = script:GetCustomProperty("LevelUpDuration")


function GetLevel()
	return script:GetCustomProperty("Level")
end

function SetLevel(value)
	script:SetCustomProperty("Level", value)
end


Events.ConnectForPlayer("Mint", function(player)
	if GetLevel() == 0 then
		success = false
		
		Task.Spawn(function()
			if success then
				SetLevel(1)
			else
				Events.BroadcastToAllPlayers("CancelMint")
			end
		end,
		MINT_WAIT_DURATION)
		
		APICREATOR_SERVER.SendPacket(player, "Mint")
		success = true
	end
end)


Events.ConnectForPlayer("LevelUp", function(player)
	Task.Spawn(function()
		SetLevel(GetLevel() + 1)
	end,
	LEVEL_UP_DURATION)
	
	APICREATOR_SERVER.SendPacket(player, "LevelUp")
end)


Events.ConnectForPlayer("Reset", function(player)
	if GetLevel() > 1 then
		SetLevel(1)
		APICREATOR_SERVER.SendPacket(player, "Reset")
	end
end)

