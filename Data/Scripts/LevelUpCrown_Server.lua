
local WORLD_TEXT = script:GetCustomProperty("WorldText"):WaitForObject()
local APICREATOR_SERVER = require(script:GetCustomProperty("APICreatorServer"))

local level = 1

Events.ConnectForPlayer("LevelUp", function(player)
	level = level + 1
	WORLD_TEXT.text = tostring(level)
	APICREATOR_SERVER.SendPacket(player, "LevelUp")
end)

Events.ConnectForPlayer("Reset", function(player)
	level = 1
	WORLD_TEXT.text = tostring(level)
	APICREATOR_SERVER.SendPacket(player, "Reset")
end)