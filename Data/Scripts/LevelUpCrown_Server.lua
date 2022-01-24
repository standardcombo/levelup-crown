
local WORLD_TEXT = script:GetCustomProperty("WorldText"):WaitForObject()
local APICREATOR_SERVER = require(script:GetCustomProperty("APICreatorServer"))

local MINT_WAIT_DURATION = 50

local level = 0

Events.ConnectForPlayer("Mint", function(player)
	if level == 0 then
		success = false
		
		Task.Spawn(function()
			if success then
				level = 1
				WORLD_TEXT.text = tostring(level)
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
	level = level + 1
	WORLD_TEXT.text = tostring(level)
	APICREATOR_SERVER.SendPacket(player, "LevelUp")
end)

Events.ConnectForPlayer("Reset", function(player)
	if level > 0 then
		level = 0
		WORLD_TEXT.text = ""
		APICREATOR_SERVER.SendPacket(player, "Reset")
	end
end)