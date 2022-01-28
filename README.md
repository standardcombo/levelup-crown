# Level-Up Crown

## Setup the demo

### Rinkeby Metamask

* Enable testnets on Metamask
* Get test tokens here (0.1 is enough): https://faucets.chain.link/rinkeby

### Deploy the contract

Check the README file in Backend/web3.
Save the contract address, it will be used as an environment variable.

### Publish the Server Proxy game

* Create an empty project
* Drag and drop the `Core Server Proxy.pbt` file into the scene.
* Create a new Concurrent Creator Storage Key
* Drop that key in the CreatorKey custom property of the template.
* Enable Concurrent Creator Storage in the `Game Settings` object.
* Publish as Unlisted
* Copy the link somewhere, you need to join this game for the demo to work.

### Publish the Level Up Crown game

* Move this folder to the `Documents/My Games/CORE/Saved/Maps/` directory
* Open the project on Core
* Add the previously created Concurrent Creator Storage Key in the custom properties of `APICreatorServer - SetAddressChatCmd`.
* Publish as Unlisted

## Run the demo

Requirements:
* Computer A: where the server is running and the Server Proxy game is also running.
* Computer B: play to the Level Up Crown game

Steps:
* **Computer A:**
* Setup environment variables
* Check if you have at least 0.1 Ethereum on Rinkeby (to get test tokens https://faucets.chain.link/rinkeby)
* Start the NodeJS server (`npm run dev` in the directory Backend/server) and wait for the "Waiting for command..." message
* Open the Server Proxy game (https://www.coregames.com/games/3c5322/getserverinfo)

* **Computer B:**
* Open the game (https://www.coregames.com/games/4d440f/level-up-crown)
* Copy your wallet address
* Type "/eth YOUR_ADDRESS"
* Click on Mint
* Open your wallet on OpenSea
* Click on the newly minted NFT
* **Level Up**: Go back to the game and click on Level Up
* Wait for the end of the progress bar
* Go back to OpenSea and click on the "Refresh Metadata" icon at the top right
* Refresh the page
* Repeat from step "Level Up"
