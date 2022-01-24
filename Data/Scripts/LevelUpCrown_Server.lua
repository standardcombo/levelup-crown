
local WORLD_TEXT = script:GetCustomProperty("WorldText"):WaitForObject()
local APICREATOR_SERVER = require(script:GetCustomProperty("APICreatorServer"))

local level = 0

Events.ConnectForPlayer("Mint", function(player)
	if level == 0 then
		APICREATOR_SERVER.SendPacket(player, "Mint")
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