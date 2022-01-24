local API = {}

local MAX_TRIES_BEFORE_DROPPING = 5
local SECONDS_BETWEEN_TRIES = 1

API.CreatorKey = nil

function API.SetPlayerAddress(player, ethAddress)
	player.serverUserData.ethAddress = ethAddress
end

function API.SetCreatorKey(key)
	API.CreatorKey = key
end

function API.SendPacket(player, packet, tries)
	if not API.CreatorKey then
		error("Creator Key not set (use SetCreatorKey(key))")
	end

	if not player.serverUserData.ethAddress then
		error("ethAddress has not been set (use SetPlayerAddress(player, ethAddress))")
	end

	local data, result, message = Storage.SetConcurrentCreatorData(API.CreatorKey, function(data)
		data.log = os.time()..","..player.serverUserData.ethAddress..","..packet
	    return data
	end)
	
	if result ~= StorageResultCode.SUCCESS then
		tries = tries and tries + 1 or 1
		if tries > MAX_TRIES_BEFORE_DROPPING then
			return
		end
		Task.Wait(SECONDS_BETWEEN_TRIES)
		API.SendPacket(player, data, tries)
	end
end

return API