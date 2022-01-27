const Web3 = require('web3')
const fetch = require('node-fetch')
const Tx = require("ethereumjs-tx").Transaction

const IS_DEV = true
const PATH_TO_PLATFORM_LOG = process.env.PATH_TO_PLATFORM_LOG
const LOG_PREFIX = process.env.CORE_LOG_PREFIX || 'THISISMYLOG_'

const PUBLIC_ADDRESS = process.env.WALLET_PUBLIC_KEY
const PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS

const INTERVAL_READ_SECONDS = 1 // Read each second

const INFURA_URL = `https://${IS_DEV ? "rinkeby" : "mainnet"}.infura.io/v3/be63d41aaacb46639be813ab0e549488`

const startDate = (new Date()).getTime() / 1000 // Save current timestamp to avoid interpreting old requests
const web3 = new Web3(new Web3.providers.HttpProvider(INFURA_URL))

const fs = require('fs')
const BITE_SIZE = 256;
let file, readbytes = 0;

let isWaiting = false

async function openFile() {
    return new Promise((resolve, reject) => {
        fs.open(PATH_TO_PLATFORM_LOG, 'r', function (err, fd) {
            if (err) reject(err)
            resolve(fd)
        })    
    })
}

function readFile() {
    const stats = fs.fstatSync(file);
    if (stats.size < readbytes + 1) {
        if (!isWaiting) {
            console.log("Waiting for command...")
            isWaiting = true
        }
        setTimeout(readFile, INTERVAL_READ_SECONDS * 1000);
    } else {
        isWaiting = false
        fs.read(file, Buffer.alloc(BITE_SIZE), 0, BITE_SIZE, readbytes, readLine);
    }
}

function readLine(err, bytecount, buff) {
    const line = buff.toString('utf-8', 0, bytecount)
    if (line.includes(LOG_PREFIX)) {
        const value = line.split(LOG_PREFIX)[1]
        let [time, address, cmd, extradata] = value.split(',')
        if (time && time > startDate) {
            console.log(cmd + " " + address)
            cmd = cmd.replace(/(\r\n|\n|\r)/gm,"")
            address = address.replace(/(\r\n|\n|\r)/gm,"")
            processCmd(cmd, address, extradata)                
        }
    }
    readbytes += bytecount;
    process.nextTick(readFile);
}

// CONTRACT CALLS

const getAbiFromAddress = async (contractAddress, apiKey) => {
    return new Promise((resolve, reject) => {
        fetch(`https://api${IS_DEV ? "-rinkeby" : ""}.etherscan.io/api?module=contract&action=getabi&address=${contractAddress}&apikey=${apiKey}`)
            .then(res => res.json())
            .then(json => resolve(JSON.parse(json.result)))
            .catch(reject)
    })
}

function sendTransaction(method) {
    web3.eth.getTransactionCount(PUBLIC_ADDRESS).then(txCount => {
        const txData = {
            nonce: web3.utils.toHex(txCount),
            gasLimit: web3.utils.toHex(300000),
            gasPrice: web3.utils.toHex(15e9), // 15 Gwei
            to: CONTRACT_ADDRESS,
            from: PUBLIC_ADDRESS,
            chainId: IS_DEV ? 4 : 1,
            data: method.encodeABI()
        }
        sendSigned(txData, function (err, result) {
            if (err) return console.log('error', err)
            console.log('Successfully sent (transaction: ', result, ')')
        })
    })
}

function sendSigned(txData, cb) {
    const privateKey = new Buffer.from(PRIVATE_KEY, 'hex')
    const transaction = new Tx(txData, {
        chain: 'rinkeby'
    })
    transaction.sign(privateKey)
    const serializedTx = transaction.serialize().toString('hex')
    web3.eth.sendSignedTransaction('0x' + serializedTx, cb)
}
// END CONTRACT CALLS

let NFTContract

const COMMANDS = {
    "Mint": (address) => sendTransaction(NFTContract.methods.mint(address)),
    "LevelUp": (address) => sendTransaction(NFTContract.methods.levelUp(address)),
    "Reset": (address) => sendTransaction(NFTContract.methods.reset(address))
}

async function processCmd(cmd, address) {
    if (!NFTContract || !cmd || !address) return
    address = address.toLowerCase()
    const func = COMMANDS[cmd]
    if (!func) {
        console.error(`Error: invalid command ${cmd}.`)
        return
    }
    func(address)
    console.log("Sent transaction levelUp for address '" + address + "'")
}

const main = async () => {
    const contract_abi = await getAbiFromAddress(CONTRACT_ADDRESS, ETHERSCAN_API_KEY)
    NFTContract = new web3.eth.Contract(contract_abi, CONTRACT_ADDRESS);

    file = await openFile()
    readFile()
}

main()

// caillef links
// https://www.coregames.com/games/4d440f/level-up-crown
// https://www.coregames.com/games/3c5322/getserverinfo