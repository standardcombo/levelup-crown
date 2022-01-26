const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('LevelUpCrown');
    const gameContract = await gameContractFactory.deploy();
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let txn;
    txn = await gameContract.mint("0x1317fDa26cdac538C3C9BC51AD73a408674674B7");
    await txn.wait();

    txn = await gameContract.levelUp("0x1317fDa26cdac538C3C9BC51AD73a408674674B7");
    await txn.wait();
    
    txn = await gameContract.reset("0x1317fDa26cdac538C3C9BC51AD73a408674674B7");
    await txn.wait();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();