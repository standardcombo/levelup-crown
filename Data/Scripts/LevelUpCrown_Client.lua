
local UIBUTTON = script:GetCustomProperty("UIButton"):WaitForObject()
local WORLD_TEXT = script:GetCustomProperty("WorldText"):WaitForObject()
local MINT_BEGIN_VFX = script:GetCustomProperty("MintBeginVFX"):WaitForObject()
local MAGIC_CIRCLE = script:GetCustomProperty("MagicCircle"):WaitForObject()
local LEVEL_UP_VFX = script:GetCustomProperty("LevelUpVFX"):WaitForObject()
local LEVEL_UP_SFX = script:GetCustomProperty("LevelUpSFX"):WaitForObject()
local BASE_GEO = script:GetCustomProperty("BaseGeo"):WaitForObject()
local POINT_LIGHT = script:GetCustomProperty("PointLight"):WaitForObject()
local EMBER_VOLUME_VFX = script:GetCustomProperty("EmberVolumeVFX"):WaitForObject()
local CANDLE_FLAME_VFX = script:GetCustomProperty("CandleFlameVFX"):WaitForObject()
local ENERGY_CHARGE_UP_HOLD_VFX = script:GetCustomProperty("EnergyChargeUpHoldVFX"):WaitForObject()
local EXPLOSION_KIT_FIRE_RING_VFX = script:GetCustomProperty("ExplosionKitFireRingVFX"):WaitForObject()
local CUSTOM_PROGRESS_BAR_ROOT = script:GetCustomProperty("CustomProgressBarRoot"):WaitForObject()
local CUSTOM_PROGRESS_BAR_SCRIPT = script:GetCustomProperty("CustomProgressBarScript"):WaitForObject()

local SERVER_SCRIPT = script:GetCustomProperty("ServerScript"):WaitForObject()
local MINT_DURATION = SERVER_SCRIPT:GetCustomProperty("MintDuration")
local LEVEL_UP_DURATION = SERVER_SCRIPT:GetCustomProperty("LevelUpDuration")

local MAX_INTENSITY = POINT_LIGHT.intensity
local FREQUENCY = 2

UI.SetCursorVisible(true)
UI.SetCanCursorInteractWithUI(true)

local level = 0
local prevLevel = 0

local STATE_WAIT_FOR_ADDRESS = 1
local STATE_WAIT_FOR_MINT = 2
local STATE_MINTING = 3
local STATE_IDLE = 4
local STATE_LEVELING_UP = 5

local currentState = STATE_WAIT_FOR_ADDRESS
local elapsedTime = 0


function SetState(newState)
	if currentState == STATE_MINTING then
		MAGIC_CIRCLE.visibility = Visibility.FORCE_OFF
	end
	
	if newState == STATE_WAIT_FOR_ADDRESS then
		UIBUTTON.text = "Connect Wallet"
		UIBUTTON.visibility = Visibility.INHERIT
		
	elseif newState == STATE_WAIT_FOR_MINT then
		UIBUTTON.text = "Mint"
		UIBUTTON.visibility = Visibility.INHERIT
		
	elseif newState == STATE_MINTING then
		UIBUTTON.visibility = Visibility.FORCE_OFF
		CUSTOM_PROGRESS_BAR_ROOT.visibility = Visibility.INHERIT
		
		MINT_BEGIN_VFX:Play()
		LEVEL_UP_SFX:Play()
		
		Task.Wait(0.2)
		MAGIC_CIRCLE.visibility = Visibility.INHERIT
	
	elseif newState == STATE_IDLE then
		UIBUTTON.text = "Level Up"
		UIBUTTON.visibility = Visibility.INHERIT
		CUSTOM_PROGRESS_BAR_ROOT.visibility = Visibility.FORCE_OFF
		PlayLevelUpVFX()
		
	elseif newState == STATE_LEVELING_UP then
		UIBUTTON.visibility = Visibility.FORCE_OFF
		CUSTOM_PROGRESS_BAR_ROOT.visibility = Visibility.INHERIT
	end
	
	currentState = newState
	elapsedTime = 0
end


function Tick(deltaTime)
	elapsedTime = elapsedTime + deltaTime
	
	local level = SERVER_SCRIPT:GetCustomProperty("Level")
	
	if currentState == STATE_MINTING then
		if level > 0 then
			SetState(STATE_IDLE)
		else
			CUSTOM_PROGRESS_BAR_SCRIPT.context.SetPercent(elapsedTime / MINT_DURATION)
		end
		
	elseif currentState == STATE_LEVELING_UP then
		if level > prevLevel then
			SetState(STATE_IDLE)
		else
			CUSTOM_PROGRESS_BAR_SCRIPT.context.SetPercent(elapsedTime / LEVEL_UP_DURATION)
		end
	end
	
	if prevLevel ~= level then
		prevLevel = level
		
		Task.Wait(0.4)
	end
		
	-- Update Crown Visuals
	
	if level == 0 then
		BASE_GEO.visibility = Visibility.FORCE_OFF
		WORLD_TEXT.text = ""
	else
		BASE_GEO.visibility = Visibility.INHERIT
		WORLD_TEXT.text = tostring(level)
	end
	
	if level <= 1 then
		POINT_LIGHT.visibility = Visibility.FORCE_OFF
	else
		local t = (math.sin(time() * FREQUENCY) + 1) / 2
		POINT_LIGHT.intensity = CoreMath.Lerp(0, MAX_INTENSITY, t)
		POINT_LIGHT.visibility = Visibility.INHERIT
	end
	
	if level <= 2 then
		EMBER_VOLUME_VFX.visibility = Visibility.FORCE_OFF
		CANDLE_FLAME_VFX.visibility = Visibility.FORCE_OFF
	else
		EMBER_VOLUME_VFX.visibility = Visibility.INHERIT
		CANDLE_FLAME_VFX.visibility = Visibility.INHERIT
	end
	
	if level <= 3 then
		ENERGY_CHARGE_UP_HOLD_VFX.visibility = Visibility.FORCE_OFF
	else
		ENERGY_CHARGE_UP_HOLD_VFX.visibility = Visibility.INHERIT
	end
	
	if level <= 4 and EXPLOSION_KIT_FIRE_RING_VFX.visibility ~= Visibility.FORCE_OFF then
		EXPLOSION_KIT_FIRE_RING_VFX.visibility = Visibility.FORCE_OFF
		EXPLOSION_KIT_FIRE_RING_VFX:Stop()
		
	elseif EXPLOSION_KIT_FIRE_RING_VFX.visibility ~= Visibility.INHERIT then
		EXPLOSION_KIT_FIRE_RING_VFX.visibility = Visibility.INHERIT
		EXPLOSION_KIT_FIRE_RING_VFX:Play()
	end
end


Events.Connect("AddressAdded", function()
	if currentState == STATE_WAIT_FOR_ADDRESS then
		SetState(STATE_WAIT_FOR_MINT)
	end
end)


Events.Connect("CancelMint", function()
	SetState(STATE_WAIT_FOR_MINT)
end)


UIBUTTON.clickedEvent:Connect(function()
	if currentState == STATE_WAIT_FOR_ADDRESS then
		UI.PrintToScreen("Type /eth <address>")
		
	elseif currentState == STATE_WAIT_FOR_MINT then
		SetState(STATE_MINTING)
		Events.BroadcastToServer("Mint")
		
	elseif currentState == STATE_IDLE then
		SetState(STATE_LEVELING_UP)
		Events.BroadcastToServer("LevelUp")
	end
end)
function PlayLevelUpVFX()
	LEVEL_UP_VFX:Stop()
	LEVEL_UP_VFX:Play()
	
	LEVEL_UP_SFX:Stop()
	LEVEL_UP_SFX:Play()
end


-- DEV cheats:
Game.GetLocalPlayer().bindingPressedEvent:Connect(function(_, action)
	-- Hide UI by pressing zero key
	if action == "ability_extra_0" then
		if UIBUTTON.visibility == Visibility.FORCE_OFF then
			UIBUTTON.visibility = Visibility.INHERIT
		else
			UIBUTTON.visibility = Visibility.FORCE_OFF
		end
		
	elseif action == "ability_secondary" then
		Events.BroadcastToServer("Reset")
	end
end)

