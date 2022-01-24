local APICREATOR_SERVER = require(script:GetCustomProperty("APICreatorServer"))
local SERVER = script:GetCustomProperty("Server")

APICREATOR_SERVER.SetCreatorKey(SERVER)

function CmdChecker(speaker, params)
	local cmd,address = CoreString.Split(string.lower(params.message), {
		delimiters = { " " }
	})
	if cmd == "/eth" then
		params.message = ""
		if not address or #address == 0 then
			Chat.BroadcastMessage("USAGE: /eth <YOUR_ETH_ADDRESS>")
		end
		if address:sub(1,2) ~= "0x" then
			Chat.BroadcastMessage("Invalid address")
			return
		end
		Chat.BroadcastMessage("Your Ethereum Address has been linked to your account "..speaker.name.."("..address..").")
		APICREATOR_SERVER.SetPlayerAddress(speaker, address)
	end
end

Chat.receiveMessageHook:Connect(CmdChecker)