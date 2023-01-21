// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

const main = async () => {
  // コントラクトがコンパイルします
  // コントラクトを扱うために必要なファイルが'artifcts'ディレクトリの直下に生成される
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  // HardhatがローカルなEternetを作成
  const nftContract = await nftContractFactory.deploy();
  // コントラクトがMintされ，ローカルのブロックチェーンにdeployされるまで待つ
  await nftContract.deployed();
  console.log("Contract deployes to:", nftContract.address);

  // makeAnEpicNFT関数を呼び出すとNFTがMINTされる
  let txn = await nftContract.makeAnEpicNFT();
  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();
  console.log("Minted NFT #1");
  // // makeAnEpicNFT関数をもう一度呼び出す．NFTがまたMINTされる
  //txn = await nftContract.makeAnEpicNFT();
  // // Mintingが仮想マイナーによって承認されるのを待つ
  //await txn.wait();
  //console.log("Minted NFT #2");
};

// エラー処理
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

/*
const hre = require("hardhat");

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const lockedAmount = hre.ethers.utils.parseEther("1");

  const Lock = await hre.ethers.getContractFactory("Lock");
  const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  await lock.deployed();

  console.log(
    `Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
*/