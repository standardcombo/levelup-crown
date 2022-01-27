# Level Up Crown - Server

This project is listening to the Platform.log file to intercept logs written by the client of the Server Proxy game.

## Deploy the contract

Follow the README in the web3 folder.

## Before starting the project

* Open Metamask, make a new account and copy the private key (WALLET_PRIVATE_KEY)

![](docs\images\private_key.png)

* Make an Etherscan account and copy your API Key (ETHERSCAN_API_KEY) [(link to Etherscan API Key)](https://etherscan.io/myapikey
)

### Define the environment variables

Define 6 environment variables

Powershell
```bash
$Env:PATH_TO_PLATFORM_LOG = 'C:/../Documents/My Games/CORE/Saved/Logs/Platform.log'
$Env:CONTRACT_ADDRESS = '0x2784..24' # This is the contract that you deployed
$Env:WALLET_PUBLIC_KEY = '0x13...2'
$Env:WALLET_PRIVATE_KEY = 'ee28...81'
$Env:ETHERSCAN_API_KEY = 'Y26...TVK'

# Optional, must also be changed in the Proxy Server game (default value is THISISMYLOG_)
$Env:CORE_LOG_PREFIX = 'THISISMYLOG_'
```

## How to start the server

The command `npm run dev` is using nodemon so if the source changes, it will restart the server automatically.

```bash
npm install
npm run dev
```