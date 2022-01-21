-- A script for swapping left-side shoulder-cam to right-side and vice versa.
-- This is a client script
-- You can enable and disable it in the CustomProperty Settings of it's parent

local propEnabled = script.parent:GetCustomProperty("Enabled")
local propKeybind = script.parent:GetCustomProperty("KeyBinding")
local propTransitionTime = script.parent:GetCustomProperty("TransitionTime")
local propEaseIn = script.parent:GetCustomProperty("EaseIn")

local player = Game.GetLocalPlayer()
Task.Wait()
local defaultCam = player:GetDefaultCamera()

local maxOffset = defaultCam:GetPositionOffset().y
local currentOffset = maxOffset
local currentSide = -1
if currentOffset > 0 then currentSide = 1 end


local cameraSwapTask = nil

function CameraSwapFunc()
	if maxOffset == 0 then return end
	currentSide = -currentSide
	local startOffset = currentOffset
	local endOffset = maxOffset * currentSide
	local dist = math.abs(startOffset - endOffset)
	local transTime = propTransitionTime * dist / (maxOffset * 2)
	local startTime = time()
	local positionOffset = defaultCam:GetPositionOffset()
	while time() < startTime + transTime do
		currentOffset =  LerpFunc(startOffset, endOffset, (time() - startTime) / transTime)
		positionOffset.y = currentOffset
		defaultCam:SetPositionOffset(positionOffset)
		Task.Wait()
	end
	cameraSwapTask = nil
	positionOffset.y = endOffset
	defaultCam:SetPositionOffset(positionOffset)
end


function LerpFunc(a, b, v)
	if propEaseIn then
		v = 1 - (1 - v) * (1 - v) * (1 - v) * (1 - v)
	end
	return CoreMath.Lerp(a, b, v)
end


function SwapSides(player, keybind)
	if keybind == propKeybind then
		if cameraSwapTask then cameraSwapTask:Cancel() end
		cameraSwapTask = Task.Spawn(CameraSwapFunc)
	end
end


-- if Shoulder Camera control feature is enabled
if propEnabled == true then
	player.bindingPressedEvent:Connect(SwapSides)
end