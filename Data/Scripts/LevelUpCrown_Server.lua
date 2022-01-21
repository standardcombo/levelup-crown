
local WORLD_TEXT = script:GetCustomProperty("WorldText"):WaitForObject()

local level = 1

Events.ConnectForPlayer("LevelUp", function(player)
	level = level + 1
	WORLD_TEXT.text = tostring(level)
end)

Events.ConnectForPlayer("Reset", function(player)
	level = 1
	WORLD_TEXT.text = tostring(level)
end)