
local UIBUTTON = script:GetCustomProperty("UIButton"):WaitForObject()
local WORLD_TEXT = script:GetCustomProperty("WorldText"):WaitForObject()
local LEVEL_UP_VFX = script:GetCustomProperty("LevelUpVFX"):WaitForObject()
local LEVEL_UP_SFX = script:GetCustomProperty("LevelUpSFX"):WaitForObject()
local BASE_GEO = script:GetCustomProperty("BaseGeo"):WaitForObject()
local POINT_LIGHT = script:GetCustomProperty("PointLight"):WaitForObject()
local EMBER_VOLUME_VFX = script:GetCustomProperty("EmberVolumeVFX"):WaitForObject()
local CANDLE_FLAME_VFX = script:GetCustomProperty("CandleFlameVFX"):WaitForObject()
local ENERGY_CHARGE_UP_HOLD_VFX = script:GetCustomProperty("EnergyChargeUpHoldVFX"):WaitForObject()
local EXPLOSION_KIT_FIRE_RING_VFX = script:GetCustomProperty("ExplosionKitFireRingVFX"):WaitForObject()

local MAX_INTENSITY = POINT_LIGHT.intensity
local FREQUENCY = 2

UI.SetCursorVisible(true)
UI.SetCanCursorInteractWithUI(true)


function Tick(deltaTime)
	local level = 0
	if WORLD_TEXT.text ~= "" then
		level = tonumber(WORLD_TEXT.text)
	end
	
	if level == 0 then
		UIBUTTON.text = "Mint"
		BASE_GEO.visibility = Visibility.FORCE_OFF
	else
		UIBUTTON.text = "Level Up"
		BASE_GEO.visibility = Visibility.INHERIT
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

UIBUTTON.clickedEvent:Connect(function()
	Events.BroadcastToServer("LevelUp")
	
	LEVEL_UP_VFX:Stop()
	LEVEL_UP_VFX:Play()
	
	LEVEL_UP_SFX:Stop()
	LEVEL_UP_SFX:Play()
end)

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

