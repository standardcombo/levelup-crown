# Level Up Crown - Contracts

## Before deploying

* Make an Alchemy account, a new project and copy the Alchemy HTTP url (ALCHEMY_HTTP_URL)

![](docs\images\alchemy_http_key.png)

* Open Metamask, make a new account and copy the private key (WALLET_PRIVATE_KEY)

![](docs\images\private_key.png)

* Make an Etherscan account and copy your API Key (ETHERSCAN_API_KEY) [(link to Etherscan API Key)](https://etherscan.io/myapikey
)

### Define the environment variables

Define 3 environment variables

Powershell
```bash
$Env:ALCHEMY_HTTP_URL = 'https://eth-rinkeby.alchemyapi.io/v2/WHl...Lz'
$Env:WALLET_PRIVATE_KEY = 'ee28...81'
$Env:ETHERSCAN_API_KEY = 'Y26...TVK'
```

## How to deploy and verify the contract on testnet

### Deploy the contract on Rinkeby

```bash
npx hardhat run .\scripts\deploy.js --network rinkeby
```

Copy the contract address and visit https://rinkeby.etherscan.io/token/CONTRACT_ADDRESS.
To call the methods, you need to verify the contract.

### Verify the contract

```bash
npx hardhat verify --network rinkeby CONTRACT_ADDRESS
```

If the above commands don't work, try to clean and try again
```bash
npx hardhat clean
```